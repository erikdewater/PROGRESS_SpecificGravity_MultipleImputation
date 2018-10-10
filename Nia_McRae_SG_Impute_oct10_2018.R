install.packages("mice")
library(haven)
library(mice)
library(data.table)
library(ggplot2)

#load data
SG_data <- read_sas("J:/PM/Element/DATABASES-Mexico/DATASETS SENT/erik_nia_sg_imp_oct10_2018.sas7bdat")

SG_data <-as.data.table(SG_data)

#subset to variables needed for model
SG_sub <- SG_data[,.(folio, fechanac_M, etapa, fecha_control, mothers_age, mother_bmi, SG,
mEP2_Conc_ngml, mBP_Conc_ngml, miBP_Conc_ngml, mBzP2_Conc_ngml, mECPP_Conc_ngml)]



#see that all phtalates and SG are numeric 
class(SG_sub$mEP2_Conc_ngml)
class(SG_sub$mBP_Conc_ngml)
class(SG_sub$miBP_Conc_ngml)
class(SG_sub$mBzP2_Conc_ngml)
class(SG_sub$mECPP_Conc_ngml)
class(SG_sub$SG)


#create natural log of phtalates of interest
SG_sub$mEP2_Conc_ngml_l <- log(SG_sub$mEP2_Conc_ngml)
SG_sub$mBP_Conc_ngml_l <- log(SG_sub$mBP_Conc_ngml)
SG_sub$miBP_Conc_ngml_l <- log(SG_sub$miBP_Conc_ngml)
SG_sub$mBzP2_Conc_ngml_l <- log(SG_sub$mBzP2_Conc_ngml)
SG_sub$mECPP_Conc_ngml_l <- log(SG_sub$mECPP_Conc_ngml)



#create exponential function then create variable which is geometric mean
e <- exp(1) 
SG_sub$phthalates <-e^(rowMeans(SG_sub[, c("mEP2_Conc_ngml_l", "mBP_Conc_ngml_l", "miBP_Conc_ngml_l", 
                                               "mBzP2_Conc_ngml_l", "mECPP_Conc_ngml_l")]))

#look at scatterplots and see if there is any outliers
ggplot(SG_sub, aes(x=phthalates, y=SG)) + geom_point()
ggplot(SG_sub, aes(x=mothers_age, y=SG)) + geom_point()
ggplot(SG_sub, aes(x=mother_bmi, y=SG)) + geom_point()
 


