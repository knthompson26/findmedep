###############################################
# ERM QC + Descriptives for MTG2 ERMs (no extension)
#
# What this script does:
#  1) Reads each MTG2 environmental relatedness matrix (ERM) stored in
#     "GCTA/MTG2-style lower triangle" format (columns: i, j, N, value).
#  2) Reconstructs an N x N sparse matrix in R for each ERM.
#  3) Extracts OFF-diagonal values (pairwise relatedness between different people)
#     and computes distribution summaries (mean, sd, quantiles, etc.).
#  4) Computes a correlation matrix across ERMs (correlation of off-diagonal values).
#  5) Saves:
#     - ERM_descriptives.tsv
#     - ERM_correlations.tsv
#
###############################################

suppressPackageStartupMessages({
  library(data.table)
})

# ------------------- USER SETTINGS -------------------

# Which model are you running? "domains" or "systems"
# model <- "domains"
 model <- "systems"

base_dir <- paste0("/project/rche/data/datasets/addhealth/scratch/kthompson/findme/sub_sample/EUR/revisions/W124/", model)
out_dir  <- "/project/rche/data/datasets/addhealth/scratch/kthompson/findme/sub_sample/EUR/revisions/descriptives/"

# Your ID mapping file used in MTG2: -p IDs_IID.fam
fam_file <- file.path(base_dir, "IDs_IID.fam")

### HASH OUT ONE SET OF ERMS DEPENDING ON MODEL ###
# domain ERMs
# erm_files <- c(
#   "erm_dat_theory1_clean_dummy_dem",
#   "erm_dat_theory1_clean_dummy_frfam",
#   "erm_dat_theory1_clean_dummy_poscog",
#   "erm_dat_theory1_clean_dummy_school",
#   "erm_dat_theory1_clean_dummy_sle",
#   "erm_dat_theory1_clean_dummy_health_general",
#   "erm_dat_theory1_clean_dummy_health_mental",
#   "erm_dat_theory1_clean_dummy_health_physical"
# )

# system ERMs
erm_files <- c(
  "erm_dat_psych_syst",
  "erm_dat_soc_syst",
  "erm_dat_built_syst",
  "erm_dat_nat_syst"
)

# Optional: check that (i,j) ordering matches across all ERMs
# Set TRUE the first time you run; if it passes, you can set FALSE later.
check_pair_order <- TRUE
# -----------------------------------------------------


# ------------------- 1) Read the .fam to get IDs + n -------------------
# PLINK .fam columns are typically:
# 1 FID, 2 IID, 3 Father, 4 Mother, 5 Sex, 6 Phenotype
read_fam_ids <- function(fam_file) {
  if (!file.exists(fam_file)) stop("Missing fam file: ", fam_file)
  
  fam <- fread(fam_file, header = FALSE)
  if (ncol(fam) < 2) stop(".fam must have at least 2 columns (FID IID): ", fam_file)
  
  ids <- fam$V2  # IID in column 2
  n <- length(ids)
  
  list(ids = ids, n = n)
}


# ------------------- 2) Read ERM triplets (i j value N) -------------------
# Your screenshot indicates:
#  V1 = i index
#  V2 = j index
#  V3 = value (relatedness)
#  V4 = N (constant, e.g., 19)
read_erm_triplets <- function(path_noext) {
  if (!file.exists(path_noext)) stop("Missing ERM file: ", path_noext)
  
  dt <- fread(path_noext, header = FALSE)
  if (ncol(dt) < 3) stop("ERM file must have at least 3 columns: ", path_noext)
  
  # Standardize column names
  setnames(dt, paste0("V", seq_len(ncol(dt))))
  
  # Create explicit variables
  dt[, `:=`(
    i = as.integer(V1),
    j = as.integer(V2),
    value = as.numeric(V3)
  )]
  
  if (ncol(dt) >= 4) dt[, N_const := V4]
  
  # Keep only relevant columns
  keep <- c("i", "j", "value")
  if ("N_const" %in% names(dt)) keep <- c(keep, "N_const")
  dt[, ..keep]
}


# ------------------- 3) Compute descriptives (no NxN needed) -------------------
# Off-diagonal values are i != j
# Diagonal values are i == j
erm_descriptives <- function(tri, erm_name, n_from_fam) {
  
  off <- tri[i != j, value]
  diagv <- tri[i == j, value]
  
  # Known number of individuals from the fam file
  n_ind <- n_from_fam
  n_pairs <- n_ind * (n_ind - 1) / 2
  
  # Basic QC: do the indices in this ERM exceed n_ind?
  max_index_seen <- max(tri$i, tri$j, na.rm = TRUE)
  
  data.table(
    ERM = erm_name,
    
    n_individuals_fam = n_ind,
    n_pairs_offdiag_expected = n_pairs,
    
    # QC: max index in file (should be <= n_ind)
    max_index_in_file = max_index_seen,
    
    # Off-diagonal distribution summaries
    off_mean   = mean(off),
    off_sd     = sd(off),
    off_min    = min(off),
    off_q1     = as.numeric(quantile(off, 0.25, na.rm = TRUE)),
    off_median = median(off),
    off_q3     = as.numeric(quantile(off, 0.75, na.rm = TRUE)),
    off_max    = max(off),
    off_iqr    = as.numeric(quantile(off, 0.75, na.rm = TRUE)) -
      as.numeric(quantile(off, 0.25, na.rm = TRUE)),
    
    off_p1  = as.numeric(quantile(off, 0.01, na.rm = TRUE)),
    off_p5  = as.numeric(quantile(off, 0.05, na.rm = TRUE)),
    off_p95 = as.numeric(quantile(off, 0.95, na.rm = TRUE)),
    off_p99 = as.numeric(quantile(off, 0.99, na.rm = TRUE)),
    
    off_prop_neg  = mean(off < 0),
    off_prop_pos  = mean(off > 0),
    off_prop_zero = mean(off == 0),
    
    # Diagonal distribution summaries (self-relatedness QC)
    diag_mean   = mean(diagv),
    diag_sd     = sd(diagv),
    diag_min    = min(diagv),
    diag_median = median(diagv),
    diag_max    = max(diagv),
    
    # Optional QC: is N constant? (if present)
    N_unique = if ("N_const" %in% names(tri)) tri[, uniqueN(N_const)] else NA_integer_
  )
}


# ------------------- 4) Check that (i,j) ordering matches across ERMs -------------------
# Correlations are only valid if the vectors align to the same (i,j) pairs.
# MTG2 typically writes the lower triangle in a deterministic order, so this is usually TRUE.
pair_order_ok <- function(tri_a, tri_b) {
  # only compare i and j columns
  identical(tri_a[, .(i, j)], tri_b[, .(i, j)])
}


# ------------------- 5) Main pipeline: loop, summarize, correlate, save -------------------
run_erm_qc <- function(base_dir, out_dir, fam_file, erm_files, check_pair_order = TRUE) {
  
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  
  # Read IDs from fam (mainly to get n and have documentation of ordering)
  fam <- read_fam_ids(fam_file)
  n_ind <- fam$n
  
  desc_list <- vector("list", length(erm_files))
  off_list  <- vector("list", length(erm_files))
  ref_pairs <- NULL
  
  for (k in seq_along(erm_files)) {
    
    erm_name <- erm_files[k]
    erm_path <- file.path(base_dir, erm_name)
    message("Reading: ", erm_path)
    
    tri <- read_erm_triplets(erm_path)
    
    # On first ERM, keep reference ordering of (i,j)
    if (k == 1) {
      ref_pairs <- tri[, .(i, j)]
    } else if (check_pair_order) {
      # Check that this ERM has the same (i,j) ordering as the first
      same <- identical(ref_pairs, tri[, .(i, j)])
      if (!same) {
        stop("Pair ordering mismatch for ERM: ", erm_name,
             "\nCorrelations would be invalid unless we align by merging on (i,j).")
      }
    }
    
    # Descriptives
    desc_list[[k]] <- erm_descriptives(tri, erm_name, n_from_fam = n_ind)
    
    # Store off-diagonal values for correlation step
    off_list[[k]] <- tri[i != j, value]
    
    rm(tri); gc()
  }
  
  desc <- rbindlist(desc_list, fill = TRUE)
  
  # Correlation across ERMs (columns = ERMs; rows = off-diagonal pairs)
  off_mat <- do.call(cbind, off_list)
  colnames(off_mat) <- erm_files
  cor_mat <- cor(off_mat, use = "pairwise.complete.obs")
  
  # Save outputs
  fwrite(desc, file.path(out_dir, paste0(model, "_ERM_descriptives.tsv")), sep = "\t", quote = FALSE)
  fwrite(as.data.table(cor_mat, keep.rownames = "ERM"),
         file.path(out_dir, paste0(model, "_ERM_correlations.tsv")),
         sep = "\t", quote = FALSE)
  
  # Also save the IID ordering used (helpful for reproducibility / methods)
  fwrite(data.table(IID = fam$ids),
         file.path(out_dir, paste0(model, "_IDs_IID_used.tsv")),
         sep = "\t", quote = FALSE)
  
  message("Saved outputs to: ", out_dir)
  
  invisible(list(descriptives = desc, correlations = cor_mat))
}


# ------------------- RUN -------------------
run_erm_qc(
  base_dir = base_dir,
  out_dir  = out_dir,
  fam_file = fam_file,
  erm_files = erm_files,
  check_pair_order = check_pair_order
)

