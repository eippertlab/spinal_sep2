##### SRMR2 - analyses on relationships along the neuraxis #####
# TS, 08/2022


# packages
library(R.matlab)
library(lme4)
library(lmerTest)


#### Import and prepare single-trial data (alternating stimulation conditions) ####

# path names
datapath <- '/data/pt_02068/analysis/tilman/'
savepath_figures <- '/data/pt_02068/analysis/tilman/figures/'

# load data
rawdata_hand <- readMat(paste(datapath, 'SRMR2_single_trials_hand_concatenated_forR.mat', sep='')) # all hand conditions
rawdata_foot <- readMat(paste(datapath, 'SRMR2_single_trials_foot_concatenated_forR.mat', sep='')) # all foot conditions


## create data frames
# hand conditions
ID <- c(rawdata_hand$ID)
cond <- c(rawdata_hand$cond) # 1=m, 2=d1, 3=d2, 4=d12
peri <- c(scale(c(rawdata_hand$peri)))
ESG <- c(scale(c(rawdata_hand$ESG)))
EEG <- c(scale(c(rawdata_hand$EEG)))

dat_hand <- as.data.frame(cbind(ID, cond, peri, ESG, EEG))

dat_hand$ID <- as.factor(dat_hand$ID)
dat_hand$cond <- as.factor(dat_hand$cond)



# foot conditions
ID <- c(rawdata_foot$ID)
cond <- c(rawdata_foot$cond) # 1=m, 2=d1, 3=d2, 4=d12
peri <- c(scale(c(rawdata_foot$peri)))
ESG <- c(scale(c(rawdata_foot$ESG)))
EEG <- c(scale(c(rawdata_foot$EEG)))

dat_foot <- as.data.frame(cbind(ID, cond, peri, ESG, EEG))

dat_foot$ID <- as.factor(dat_foot$ID)
dat_foot$cond <- as.factor(dat_foot$cond)



#### LMEs ####


## hand
summary(lmer(EEG ~ ESG + (1 | ID), data=dat_hand, REML=F)) # effect of ESG when not controlling for cond
      summary(lmer(EEG ~ ESG + (1 | ID), data=dat_hand, REML=F))$coefficients
summary(lmer(EEG ~ ESG * cond + (1 | ID), data=dat_hand, REML=F)) # no effect of ESG but of cond
      summary(lmer(EEG ~ ESG * cond + (1 | ID), data=dat_hand, REML=F))$coefficients

summary(lmer(ESG ~ peri + (1 | ID), data=dat_hand, REML=F)) # effect of peri when not controlling for cond
      summary(lmer(ESG ~ peri + (1 | ID), data=dat_hand, REML=F))$coefficients
summary(lmer(ESG ~ peri * cond + (1 | ID), data=dat_hand, REML=F)) # no effect of peri but of cond
      summary(lmer(ESG ~ peri * cond + (1 | ID), data=dat_hand, REML=F))$coefficients

# foot
summary(lmer(EEG ~ ESG + (1 | ID), data=dat_foot, REML=F)) # effect of ESG when not controlling for cond
      summary(lmer(EEG ~ ESG + (1 | ID), data=dat_foot, REML=F))$coefficients
summary(lmer(EEG ~ ESG * cond + (1 | ID), data=dat_foot, REML=F)) # ESG sign. 
      summary(lmer(EEG ~ ESG * cond + (1 | ID), data=dat_foot, REML=F))$coefficients

summary(lmer(ESG ~ peri + (1 | ID), data=dat_foot, REML=F)) # effect of peri when not controlling for cond
      summary(lmer(ESG ~ peri + (1 | ID), data=dat_foot, REML=F))$coefficients
summary(lmer(ESG ~ peri * cond + (1 | ID), data=dat_foot, REML=F)) # no effect of peri but of cond
      summary(lmer(ESG ~ peri * cond + (1 | ID), data=dat_foot, REML=F))$coefficients






