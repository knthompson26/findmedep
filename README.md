# findmedep
This repository holds all the scripts for the manuscript: *Illuminating the complex interplay of risk factors for depression within a large-scale US longitudinal cohort*. 

Original: July, 2025
Updated: March 2026

Currently under review at Social Psychiatry and Psychiatric Epidemiology. 

**Katherine N Thompson**, Baptiste Couvy-Duchesne, S. Hong Lee, Rafael Geurgas, Yeongmi Jeong, Saranya Arirangan, Saul Newman, Felix C Tropf, and Robbee Wedow

All code created by [Katherine N Thompson](https://scholar.google.co.uk/citations?user=xD4dn1IAAAAJ&hl=en). 

[Pre-registration on OSF](https://osf.io/akzhd/) and [Pre-print on PsyArXiv](https://doi.org/10.31234/osf.io/wf52a_v1). 

***

**Abstract from preprint**: 
Purpose: Understanding depression susceptibility requires research to assimilate a vast and complex array of risk factors comprehensively. We quantify the influence of prominent individual-level and wider social environmental risk factors on symptom occurrence. 
Methods: We leverage data from the National Longitudinal Study of Adolescent to Adult Health (US) to integrate factors spanning biological (genetic), psychological (health, personality, positive cognition), social (family, peers, school, and neighbourhood), built (geo-coded healthcare, education, religion, crime, poverty, political climate), and natural (geo-coded population density, rainfall, and urbanicity) systems. We test their contribution to concurrent adolescent depression symptoms (W1), one year later (W2), and a decade later in early adulthood (W4) using relatedness-based linear mixed models (European-like ancestries only; N=3,867). 
Results: First, a subset of 81 individual-level factors together explained 85.5% of the variance in concurrent adolescent depression symptoms, 68.4% one year later, and 52.5% in adulthood. When split by domains, positive cognition (feeling accepted and loved) contributed most in adolescence (W1 15.1%(SE=4%); W2 6.6%(2%)), and domains contributed equally in adulthood. Second, all 162 factors capturing interconnected genetic, psychological, social, built, and natural systems explained 80.5% in concurrent depression symptoms, 54.7.4% one year later, and 44.9% in adulthood. The psychological system (W1 38.5%(4%); W2 21.9%(3%); W4 7.7%(1%), psychological-genetic interaction (W1 26.7%(4%); W2 25.1%(4%); W4 12.4%(3%)), social-genetic interaction (W1 10.1%(3%); W2 11.8%(3%); W4 9.6%(3%)) explained most variance in depression symptoms at all ages.
Conclusion: We provide a holistic understanding of depression risk, where feeling supported and accepted was most crucial, and emphasise the complexity of modelling the environment. 

Information on Add Health data: https://addhealth.cpc.unc.edu/

Analyses for this project were conducted in R (Version 4.0.3). Below names and locations for all  scripts are listed, with a brief explanation of what each script entails, for more detail you can email me on thom1336@purdue.edu. 

**IMPORTANT NOTE:** For anyone wanting to use this approach, the *FINDME_missingE_dep_RQ2.Rmd* file includes more succinct syntax and less data prep, so the script is one third of the size (!!). I reccommend using this script as a reference. [Xuan Zhou & S. Hong Lee, 2021](https://www.nature.com/articles/s41598-021-00427-y) provide original methods and corresponding equations for the EREML approach.  

***

**Research Question 1:** How do prominent individual-level risk factors for depression contribute to concurrent and longitudinal symptom occurrence? 

1. FINDME_missingE_dep_EREML.Rmd. Mixed linear models were conducted on 81 variables on three depression outcomes (W1A, W1B, W4). First, This is done by estimating one random effect for "environmental" data and one random effect for genetic data. Second, we estimate specific random effects for each domain. 
                
***

**Research Question 2:** To what extent does the wider environment add to the explanation of depression symptoms?

1. FINDME_missingE_dep_RQ2.Rmd. Mixed linear models were conducted on 162 variables on three depression outcomes (W1A, W1B, W4). This is done by estimating a random effect for each system: biological/genetic systems, psychological systems, social environment, the built environment, and the natural environment.  


***
