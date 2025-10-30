# findmedep
This repository holds all the scripts for the manuscript: *Illuminating the complex interplay of risk factors for depression within a large-scale US longitudinal cohort*. 

July, 2025

Currently under review at Social Psychiatry and Psychiatric Epidemiology. 

**Katherine N Thompson**, Baptiste Couvy-Duchesne, S. Hong Lee, Rafael Geurgas, Yeongmi Jeong, Saranya Arirangan, Saul Newman, Felix C Tropf, and Robbee Wedow

All code created by [Katherine N Thompson](https://scholar.google.co.uk/citations?user=xD4dn1IAAAAJ&hl=en). 

Pre-registration and pre-print are available on the OSF: https://osf.io/akzhd/

***

**Abstract from preprint**: A thorough understanding of depression susceptibility requires research to comprehensively assimilate a vast and complex array of risk factors. We leverage data from the National Longitudinal Study of Adolescent to Adult Health to integrate factors spanning genetic, psychological, social, built, and natural systems and their contribution to depression symptoms from adolescence to adulthood using linear mixed models (N=5,030). First, a subset of 81 prominent individual-level factors explained 83-86% of the variance in adolescence and 14% in adulthood symptoms. Feeling accepted and loved were the most influential in adolescence, and factors contributed relatively equally in adulthood. Second, all 162 factors capturing interconnected systems explained 82-86% of the variance in adolescence and 32% in adulthood. Psychological systems were integral, and we show a complex interplay between genetic vulnerability and psychological processes. We provide a holistic understanding of depression risk and emphasise feeling supported and accepted as crucial for early detection.

Information on Add Health data: https://addhealth.cpc.unc.edu/

Analyses for this project were conducted in R (Version 4.0.3). Below names and locations for all  scripts are listed, with a brief explanation of what each script entails, for more detail you can email me on thom1336@purdue.edu. 

**IMPORTANT NOTE:** For anyone wanting to use this approach, the *FINDME_missingE_dep_RQ2.Rmd* file includes more succinct syntax and less data prep, so the script is one third of the size (!!) so I reccommend using this script as a reference. [Xuan Zhou & S. Hong Lee, 2021](https://www.nature.com/articles/s41598-021-00427-y) provide original methods and corresponding equations for the EREML approach.  

***

**Research Question 1:** How do prominent individual-level risk factors for depression contribute to concurrent and longitudinal symptom occurrence? 

1. FINDME_missingE_dep_EREML.Rmd. Mixed linear models were conducted on 81 variables on three depression outcomes (W1A, W1B, W4). First, This is done by estimating one random effect for "environmental" data and one random effect for genetic data. Second, we estimate specific random effects for each domain. 
                
***

**Research Question 2:** To what extent does the wider environment add to the explanation of depression symptoms?

1. FINDME_missingE_dep_RQ2.Rmd. Mixed linear models were conducted on 162 variables on three depression outcomes (W1A, W1B, W4). This is done by estimating a random effect for each system: biological/genetic systems, psychological systems, social environment, the built environment, and the natural environment.  

***

**Sensitivity analyses** 

1. FINDME_missingE_dep_EREML.Rmd. First, we calculated the heritability of all environmental factors and removed the top ten most heritable items from the environmental component, and reclaculated the G + E + G * E model.
2. FINDME_missingE_dep_EREML.Rmd. Second, we removed all health-related variables from the environmental component to assess if mental or physical health factors were driving the variance explained, and recalucated the G + E + G * E model.

***
