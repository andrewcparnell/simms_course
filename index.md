---
title: "Stable Isotope Mixing Models: course timetable"
author: "Andrew Parnell and Andrew Jackson, with Emma Govan"
date: "March 2024 - online"
output: html_document
---

Course pre-requisites can be found [here](https://andrewcparnell.github.io/simms_course/Prerequisites.html). All the raw files and code can be found [here](https://github.com/andrewcparnell/simms_course). Click 'Clone or Download' near the top right and then 'Download ZIP' if you want an offline copy of everything. 

As this module will be delivered online please install [Zoom](https://www.zoom.us) and [Slack](https://slack.com) to access the videos and interactive components of the course. All the Zoom links to the meeting will be posted to the Slack `#zoom-links` channel.

Please note that the course will be recorded so that attendees in different time zones can catch up on material.

## Tuesday

Introduction to SIA data and revision of basic statistical and R concepts

<span style="display: inline-block; width:100px">Time</span> | Class
------------- | ----------------------------------------------------
9:30-10:30 | [Introduction: why use a SIMM? (AJ & AP)](https://andrewcparnell.github.io/simms_course/aj-content/intro-why-use-a-SIMM.html)
10:30-10:45 | Coffee break
10:45-11:45 | [Revision of likelihood and regression (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/revision_of_likelihood_regression/revision_of_likelihood_and_regression.pdf)
11:45-12:00 | Break 
12:00-13:00 | [Guided practical: Revision of important R concepts (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/revision_of_R/Revision_of_R.R)
13:00-14:00 | Lunch
14:00-15:00 | [Guided practical: Intro to SI data](https://andrewcparnell.github.io/simms_course/aj-content/practicals/day-1-pm1/Exploring-Basic-SIA-Data.nb.html) and [biplots](https://andrewcparnell.github.io/simms_course/aj-content/practicals/day-1-pm1/first-biplot.nb.html) (AJ)
15:00-15:30 | Coffee break
15:30-17:00 | [Guided Practical: Simple linear models to explain SIA data](https://andrewcparnell.github.io/simms_course/aj-content/practicals/day-1-pm2/basic-SIA-linear-models.nb.html) (AJ)

## Wednesday

Introduction to Bayes and SIMMs

<span style="display: inline-block; width:100px">Time</span> | Class
------------- | ----------------------------------------------------
9:30-10:30 | [An introduction to Bayesian statistics (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/intro_bayes/intro_bayes.pdf)
10:30-10:45 | Coffee break
10:45-11:45 | [Guided practical: R, JAGS, and linear regression (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/prac_jags/practical_R_jags_and_lr.R)
11:45-12:00 | Break 
12:00-13:00 | [Differences between regression models and SIMMs (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/reg_and_simms/reg_and_simms.pdf) 
13:00-14:00 | Lunch
14:00-15:00 | [Guided practical: intro to simmr (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/prac_using_simmr/simmr_vignette_code.R)
15:00-15:30 | Coffee break
15:30-17:00 | Practical: options are (1) run your data through AJ's plots from yesterday, or (2) get your data to run in `simmr`, or (3) go back and learn ggplot2 from [this script](https://andrewcparnell.github.io/simms_course/ap_notes/gg_plot_class.R)

## Thursday

simmr / MixSIAR

<span style="display: inline-block; width:100px">Time</span> | Class
------------- | ----------------------------------------------------
9:30-10:30 | [The statistical model behind simmr (and SIAR) (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/siar_stats/siar_stats.pdf)
10:30-10:45 | Coffee break
10:45-11:45 | Guided Practical: using [MixSIAR](https://andrewcparnell.github.io/simms_course/ap_notes/prac_mixsiar_and_jags/mixsiar_script.R) and [incorporating prior information in simmr (AP)](https://andrewcparnell.github.io/simms_course/ap_notes/prac_using_simmr/simmr_with_priors.R)
11:45-12:00 | Break 
12:00-13:00 | [Dos and don'ts of using mixing models with discussion (AJ)](https://andrewcparnell.github.io/simms_course/aj-content/siar-dos-and-donts.html)
13:00-14:00 | Lunch
14:00-15:00 | Dos and don'ts continued (AJ)
15:00-15:30 | Coffee break
15:30-17:00 | [Practical: Source grouping, when and how? (AJ)](https://andrewcparnell.github.io/simms_course/aj-content/practicals/source-aggregation.nb.html) 


## Friday 

Source grouping, SIBER, and (new!) cosimmr

<span style="display: inline-block; width:100px">Time</span> | Class
------------- | ----------------------------------------------------
9:30-10:30 |  [Creating and understanding Stable Isotope Bayesian Ellipses (SIBER) (AJ)](https://andrewcparnell.github.io/simms_course/aj-content/siber-intro-ellipses.html)
10:30-10:45 | Coffee break
10:45-11:45 | [Guided Practical: Using SIBER to compare populations using ellipses (AJ)](https://andrewcparnell.github.io/simms_course/aj-content/practicals/siber-comparing-populations.nb.html)
11:45-12:00 | Break 
12:00-13:00 | [Practical: pick a MixSIAR example](https://cran.r-project.org/web/packages/MixSIAR/vignettes/) and [look at the manual](https://github.com/brianstock/MixSIAR/blob/master/Manual/mixsiar_manual_3.1.pdf) (AP & AJ)
13:00-14:00 | Lunch
14:00-15:00 | [Introduction to cosimmr](https://andrewcparnell.github.io/simms_course/ap_notes/cosimmr/cosimmr_presentation.pdf) and [practical](https://raw.githubusercontent.com/emmagovan/cosimmr/master/vignettes/cosimmr.Rmd) (EG & AP)
15:00-15:30 | Coffee break
15:30-17:00 | [Guided Practical: Using SIBER to compare communities using convex hulls (AJ)](https://andrewcparnell.github.io/simms_course/aj-content/practicals/siber-comparing-communities.nb.html)

