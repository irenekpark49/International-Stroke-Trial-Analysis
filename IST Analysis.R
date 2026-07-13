---
title: "IST Analysis"
author: "Irene Kimura Park"
date: "`r Sys.Date()`"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(expss)
library(gtsummary)
library(mediation)
set.seed(1234)
```

### International Stroke Trial Dataset
```{r Data Prep}
ist <- read.csv("C:/Irene Park's Documents/Academics/MS Applied Biostatistics/BS 851 - Applied Statistics in Clinical Trials I/Project/IST.csv") %>%
  # Select variables for analysis
  dplyr::select(sex = SEX, 
                age = AGE, 
                aspirin = RXASP, 
                heparin = RXHEP, 
                hemorrhagic_stroke = DRSH, 
                pulmonary_embolism = DPE) %>% 
  # Create treatment variable & recode sex
  dplyr::mutate(treatment = case_when((aspirin == "Y" & heparin == "N") ~ "Yes", 
                                      (aspirin == "N" & heparin == "N") ~ "No") %>%
                  factor(levels = c("Yes", "No")),
                sex = recode_factor(sex, "M" = "Male", "F" = "Female") %>%
                  factor(levels = c("Male", "Female"))) %>%
  # Select subjects of interest
  dplyr::filter(treatment %in% c("Yes", "No"),
                hemorrhagic_stroke %in% c("Y", "N"),
                pulmonary_embolism %in% c("Y", "N")) %>%
  # Recode and factor Yes/No binary variables
  dplyr::mutate_at(.vars = c("hemorrhagic_stroke", "pulmonary_embolism"),
                   .funs = ~ dplyr::recode_factor(.x, "Y" = "Yes", "N" = "No")) %>%
  # Create new 0/1 binary variables for analysis
  dplyr::mutate(stroke = dplyr::case_when(hemorrhagic_stroke == "Yes" ~ 1,
                                          hemorrhagic_stroke == "No" ~ 0),
                embolism = dplyr::case_when(pulmonary_embolism == "Yes" ~ 1,
                                            pulmonary_embolism == "No" ~ 0),
                trt = dplyr::case_when(treatment == "Yes" ~ 1,
                                       treatment == "No" ~ 0)) %>%
  # Remove input variable
  dplyr::select(-aspirin, -heparin) %>%
  # Label variables
  expss::apply_labels(sex = "Sex", 
                      age = "Age", 
                      trt = "Treatment",
                      hemorrhagic_stroke = "Recurrent Hemorrhagic Stroke", 
                      pulmonary_embolism = "Pulmonary Embolism")



# Table 1 - Demographic Characteristics
table1 <- ist %>%
  gtsummary::tbl_summary(
    by = treatment,
    include = c(sex, age, hemorrhagic_stroke, pulmonary_embolism),
    type = gtsummary::all_dichotomous() ~ "categorical",
    percent = "column", 
    statistic = list(gtsummary::all_categorical() ~ "{n} ({p}%)", 
                     gtsummary::all_continuous() ~ "{mean} ({sd})"),
    digits = list(gtsummary::all_categorical() ~ c(0, 2),
                  gtsummary::all_continuous() ~ c(2, 2)),
    label = list(sex = "Sex (n, %)",
                 age = "Age (mean, SD)",
                 hemorrhagic_stroke = "Hemorrhagic Stroke (n, %)",
                 pulmonary_embolism = "Pulmonary Embolism (n, %)") 
    ) %>%
  # Add overall column
  gtsummary::add_overall(last = TRUE) %>%
  # Add column headers and N
  gtsummary::modify_header(
    update = list(
      label = "",
      stat_1 = "**Treatment** \n 
      (Aspirin 300 mg & no heparin) \n
      N = {prettyNum(n, big.mark = ',')}", 
      stat_2 = "**Placebo** \n 
      (No aspirin or heparin) \n
      N = {prettyNum(n, big.mark = ',')}", 
      stat_0 = "**Total** \n 
      N = {prettyNum(n, big.mark = ',')}")) %>%
  # Remove automatically generated footnotes
  gtsummary::remove_footnote_header(columns = gtsummary::everything()) 
```



### Mediation Analysis
```{r}
# Logarithmic mediator model
mediator_model <- stats::glm(embolism ~ trt + age + sex, 
                             data = ist, family = "binomial")
summary(mediator_model)


# Logarithmic outcome model
outcome_model <- stats::glm(stroke ~ trt + embolism + age + sex, 
                            data = ist, family="binomial")
summary(outcome_model)


# Calculate mediated effects
mediated_effects <- mediation::mediate(mediator_model, outcome_model, treat = "trt",
                                       mediator = "embolism")
summary(mediated_effects)
```
