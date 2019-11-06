1.회귀분석(Logistic Regresson.R)
#경로설정
getwd()
setwd("/root/Dev/workspace/pr_lifesemantics/Python/DATA/I109")

#출력 자릿수 설정
options(scipen=100, digit = 10, digits = 8)

#특정 질병에 대한 csv읽기
csv_6Y <- read.csv("EXP_{illname}_2_6YEAR.csv",header=TRUE,sep=",")

csv_exp_6Y <- read.csv("EXP_{illname}_2_6YEAR.csv",header=TRUE,sep=",")
csv_exp_6Y$MAIN_SICKS <- 1

csv_ctr_6Y <- read.csv("CTR_{illname}_2_6YEAR.csv",header=TRUE,sep=",")
csv_ctr_6Y$MAIN_SICKS <- 0

#실험군:대조군 비율을 1:1 또는 임의설정하기 위한 샘플링
samp <- sample(1:29084,6282, replace=FALSE)

#생성한 samp를 저장하고 불러오는 코드
# save(samp, file = "samp_1vs1.RData")
# get(load("samp_1vs1.RData"))

#실험군:대조군 비율을 1:1로 하여 통합
csv_6Y[csv_6Y$MAIN_SICKS==1,]
csv_6Y<- rbind(csv_exp_6Y,csv_ctr_6Y[samp,])

#각 성분별 분포비율을 보고 판단하여 범위 통합 및 특정 값을 가진 레코드 삭제
#ㅇㅖ측모델 생성방법 문서의 R생성규칙 참고
csv_6Y$AGE_GROUP[csv_6Y$AGE_GROUP==1]<-2
csv_6Y$AGE_GROUP[csv_6Y$AGE_GROUP==7]<-6
csv_6Y<-csv_6Y[csv_6Y$SIDO<4,]
csv_6Y<-csv_6Y[csv_6Y$IPSN_TYPE_CD!=3,]
csv_6Y<-csv_6Y[csv_6Y$CTRB_PT_TYPE_CD!=0,]
csv_6Y$DFAB_GRD_CD[csv_6Y$DFAB_GRD_CD==2]<-1

#연속형으로 읽어들인 데이터값을 범주형으로 변환하는 작업
#범주의 기준은 대부분 처음의 값임, 그 이외의 값을 범주로 설정하려면 따로 함수를 써야함
csv_6Y$SEX                      	<- as.factor(csv_6Y$SEX                   	)
csv_6Y$AGE_GROUP                	<- as.factor(csv_6Y$AGE_GROUP             	)
csv_6Y$AGE_GROUP         	<-relevel(csv_6Y$AGE_GROUP, ref="2")
csv_6Y$SIDO                     	<- as.factor(csv_6Y$SIDO                  	)
csv_6Y$IPSN_TYPE_CD             	<- as.factor(csv_6Y$IPSN_TYPE_CD          	)
csv_6Y$IPSN_TYPE_CD         	<-relevel(csv_6Y$IPSN_TYPE_CD, ref="2")
csv_6Y$CTRB_PT_TYPE_CD          	<- as.factor(csv_6Y$CTRB_PT_TYPE_CD       	)
csv_6Y$CTRB_PT_TYPE_CD      	<-relevel(csv_6Y$CTRB_PT_TYPE_CD, ref="4")
csv_6Y$DFAB_GRD_CD              	<- as.factor(csv_6Y$DFAB_GRD_CD           	)
csv_6Y$DFAB_PTN_CD              	<- as.factor(csv_6Y$DFAB_PTN_CD           	)
csv_6Y$HCHK_APOP_PMH_YN         	<- as.factor(csv_6Y$HCHK_APOP_PMH_YN      	)
csv_6Y$HCHK_HDISE_PMH_YN        	<- as.factor(csv_6Y$HCHK_HDISE_PMH_YN     	)
csv_6Y$HCHK_HPRTS_PMH_YN        	<- as.factor(csv_6Y$HCHK_HPRTS_PMH_YN     	)
csv_6Y$HCHK_DIABML_PMH_YN       	<- as.factor(csv_6Y$HCHK_DIABML_PMH_YN    	)
csv_6Y$HCHK_HPLPDM_PMH_YN       	<- as.factor(csv_6Y$HCHK_HPLPDM_PMH_YN    	)
csv_6Y$HCHK_PHSS_PMH_YN         	<- as.factor(csv_6Y$HCHK_PHSS_PMH_YN      	)
csv_6Y$HCHK_ETCDSE_PMH_YN       	<- as.factor(csv_6Y$HCHK_ETCDSE_PMH_YN    	)
csv_6Y$FMLY_APOP_PATIEN_YN      	<- as.factor(csv_6Y$FMLY_APOP_PATIEN_YN   	)
csv_6Y$FMLY_HDISE_PATIEN_YN     	<- as.factor(csv_6Y$FMLY_HDISE_PATIEN_YN  	)
csv_6Y$FMLY_HPRTS_PATIEN_YN     	<- as.factor(csv_6Y$FMLY_HPRTS_PATIEN_YN  	)
csv_6Y$FMLY_DIABML_PATIEN_YN    	<- as.factor(csv_6Y$FMLY_DIABML_PATIEN_YN 	)
csv_6Y$FMLY_CANCER_PATIEN_YN    	<- as.factor(csv_6Y$FMLY_CANCER_PATIEN_YN 	)
csv_6Y$X2Y_YKIHO_GUBUN_CD       	<- as.factor(csv_6Y$X2Y_YKIHO_GUBUN_CD    	)
csv_6Y$X2Y_YKIHO_GUBUN_CD    	<-relevel(csv_6Y$X2Y_YKIHO_GUBUN_CD, ref="3")
csv_6Y$X2Y_BMI                  	<- as.factor(csv_6Y$X2Y_BMI               	)
csv_6Y$X2Y_BP                   	<- as.factor(csv_6Y$X2Y_BP                	)
csv_6Y$X2Y_BLDS                 	<- as.factor(csv_6Y$X2Y_BLDS              	)
csv_6Y$X2Y_TOT_CHOLE            	<- as.factor(csv_6Y$X2Y_TOT_CHOLE         	)
csv_6Y$X2Y_HMG                  	<- as.factor(csv_6Y$X2Y_HMG               	)
csv_6Y$X2Y_OLIG_PROTE_CD        	<- as.factor(csv_6Y$X2Y_OLIG_PROTE_CD     	)
csv_6Y$X2Y_SGOT_AST             	<- as.factor(csv_6Y$X2Y_SGOT_AST          	)
csv_6Y$X2Y_SGPT_ALT             	<- as.factor(csv_6Y$X2Y_SGPT_ALT          	)
csv_6Y$X2Y_GAMMA_GTP            	<- as.factor(csv_6Y$X2Y_GAMMA_GTP         	)
csv_6Y$X2Y_SMK_STAT_TYPE_RSPS_CD	<- as.factor(csv_6Y$X2Y_SMK_STAT_TYPE_RSPS_CD )
csv_6Y$X2Y_SMK_TERM_RSPS_CD     	<- as.factor(csv_6Y$X2Y_SMK_TERM_RSPS_CD  	)
csv_6Y$X2Y_DSQTY_RSPS_CD        	<- as.factor(csv_6Y$X2Y_DSQTY_RSPS_CD     	)
csv_6Y$X2Y_DRNK_HABIT_RSPS_CD   	<- as.factor(csv_6Y$X2Y_DRNK_HABIT_RSPS_CD	)
csv_6Y$X2Y_TM1_DRKQTY_RSPS_CD   	<- as.factor(csv_6Y$X2Y_TM1_DRKQTY_RSPS_CD	)
csv_6Y$X2Y_EXERCI_FREQ_RSPS_CD  	<- as.factor(csv_6Y$X2Y_EXERCI_FREQ_RSPS_CD   )
csv_6Y$X4Y_YKIHO_GUBUN_CD       	<- as.factor(csv_6Y$X4Y_YKIHO_GUBUN_CD    	)
csv_6Y$X4Y_YKIHO_GUBUN_CD    	<-relevel(csv_6Y$X4Y_YKIHO_GUBUN_CD, ref="3")
csv_6Y$X4Y_BMI                  	<- as.factor(csv_6Y$X4Y_BMI               	)
csv_6Y$X4Y_BP                   	<- as.factor(csv_6Y$X4Y_BP                	)
csv_6Y$X4Y_BLDS                 	<- as.factor(csv_6Y$X4Y_BLDS              	)
csv_6Y$X4Y_TOT_CHOLE            	<- as.factor(csv_6Y$X4Y_TOT_CHOLE         	)
csv_6Y$X4Y_HMG                  	<- as.factor(csv_6Y$X4Y_HMG               	)
csv_6Y$X4Y_OLIG_PROTE_CD        	<- as.factor(csv_6Y$X4Y_OLIG_PROTE_CD     	)
csv_6Y$X4Y_SGOT_AST             	<- as.factor(csv_6Y$X4Y_SGOT_AST          	)
csv_6Y$X4Y_SGPT_ALT             	<- as.factor(csv_6Y$X4Y_SGPT_ALT          	)
csv_6Y$X4Y_GAMMA_GTP            	<- as.factor(csv_6Y$X4Y_GAMMA_GTP         	)
csv_6Y$X4Y_SMK_STAT_TYPE_RSPS_CD	<- as.factor(csv_6Y$X4Y_SMK_STAT_TYPE_RSPS_CD )
csv_6Y$X4Y_SMK_TERM_RSPS_CD     	<- as.factor(csv_6Y$X4Y_SMK_TERM_RSPS_CD  	)
csv_6Y$X4Y_DSQTY_RSPS_CD        	<- as.factor(csv_6Y$X4Y_DSQTY_RSPS_CD     	)
csv_6Y$X4Y_DRNK_HABIT_RSPS_CD   	<- as.factor(csv_6Y$X4Y_DRNK_HABIT_RSPS_CD	)
csv_6Y$X4Y_TM1_DRKQTY_RSPS_CD   	<- as.factor(csv_6Y$X4Y_TM1_DRKQTY_RSPS_CD	)
csv_6Y$X4Y_EXERCI_FREQ_RSPS_CD  	<- as.factor(csv_6Y$X4Y_EXERCI_FREQ_RSPS_CD   )
csv_6Y$X6Y_YKIHO_GUBUN_CD       	<- as.factor(csv_6Y$X6Y_YKIHO_GUBUN_CD    	)
csv_6Y$X6Y_YKIHO_GUBUN_CD    	<-relevel(csv_6Y$X6Y_YKIHO_GUBUN_CD, ref="3")
csv_6Y$X6Y_BMI                  	<- as.factor(csv_6Y$X6Y_BMI               	)
csv_6Y$X6Y_BP                   	<- as.factor(csv_6Y$X6Y_BP                	)
csv_6Y$X6Y_BLDS                 	<- as.factor(csv_6Y$X6Y_BLDS              	)
csv_6Y$X6Y_TOT_CHOLE            	<- as.factor(csv_6Y$X6Y_TOT_CHOLE         	)
csv_6Y$X6Y_HMG                  	<- as.factor(csv_6Y$X6Y_HMG               	)
csv_6Y$X6Y_OLIG_PROTE_CD        	<- as.factor(csv_6Y$X6Y_OLIG_PROTE_CD     	)
csv_6Y$X6Y_SGOT_AST             	<- as.factor(csv_6Y$X6Y_SGOT_AST          	)
csv_6Y$X6Y_SGPT_ALT             	<- as.factor(csv_6Y$X6Y_SGPT_ALT          	)
csv_6Y$X6Y_GAMMA_GTP            	<- as.factor(csv_6Y$X6Y_GAMMA_GTP         	)
csv_6Y$X6Y_SMK_STAT_TYPE_RSPS_CD	<- as.factor(csv_6Y$X6Y_SMK_STAT_TYPE_RSPS_CD )
csv_6Y$X6Y_SMK_TERM_RSPS_CD     	<- as.factor(csv_6Y$X6Y_SMK_TERM_RSPS_CD  	)
csv_6Y$X6Y_DSQTY_RSPS_CD        	<- as.factor(csv_6Y$X6Y_DSQTY_RSPS_CD     	)
csv_6Y$X6Y_DRNK_HABIT_RSPS_CD   	<- as.factor(csv_6Y$X6Y_DRNK_HABIT_RSPS_CD	)
csv_6Y$X6Y_TM1_DRKQTY_RSPS_CD   	<- as.factor(csv_6Y$X6Y_TM1_DRKQTY_RSPS_CD	)
csv_6Y$X6Y_EXERCI_FREQ_RSPS_CD  	<- as.factor(csv_6Y$X6Y_EXERCI_FREQ_RSPS_CD   )

#회귀분석
logr_6Y <- glm(MAIN_SICKS ~
             	PERSON_ID            	+ YEAR                  	+ SEX                   	+
             	AGE_GROUP            	+ SIDO                  	+ IPSN_TYPE_CD          	+ CTRB_PT_TYPE_CD        	+
             	DFAB_GRD_CD          	+ HCHK_APOP_PMH_YN      	+ HCHK_HDISE_PMH_YN      	+
             	HCHK_HPRTS_PMH_YN    	+ HCHK_DIABML_PMH_YN    	+ HCHK_HPLPDM_PMH_YN    	+ HCHK_PHSS_PMH_YN       	+
             	HCHK_ETCDSE_PMH_YN   	+ FMLY_APOP_PATIEN_YN   	+ FMLY_HDISE_PATIEN_YN  	+ FMLY_HPRTS_PATIEN_YN   	+
             	FMLY_DIABML_PATIEN_YN	+ FMLY_CANCER_PATIEN_YN 	+ X2Y_HCHK_YEAR         	+ X2Y_YKIHO_GUBUN_CD     	+
             	X2Y_BMI              	+ X2Y_BP                	+ X2Y_BLDS              	+ X2Y_TOT_CHOLE          	+
             	X2Y_HMG              	+ X2Y_OLIG_PROTE_CD     	+ X2Y_SGOT_AST          	+ X2Y_SGPT_ALT           	+
             	X2Y_GAMMA_GTP        	+ X2Y_SMK_STAT_TYPE_RSPS_CD + X2Y_SMK_TERM_RSPS_CD  	+ X2Y_DSQTY_RSPS_CD      	+
             	X2Y_DRNK_HABIT_RSPS_CD   + X2Y_TM1_DRKQTY_RSPS_CD	+ X2Y_EXERCI_FREQ_RSPS_CD   + X4Y_HCHK_YEAR          	+
             	X4Y_YKIHO_GUBUN_CD   	+ X4Y_BMI               	+ X4Y_BP                	+ X4Y_BLDS               	+
             	X4Y_TOT_CHOLE        	+ X4Y_HMG               	+ X4Y_OLIG_PROTE_CD     	+ X4Y_SGOT_AST           	+
             	X4Y_SGPT_ALT         	+ X4Y_GAMMA_GTP         	+ X4Y_SMK_STAT_TYPE_RSPS_CD + X4Y_SMK_TERM_RSPS_CD   	+
             	X4Y_DSQTY_RSPS_CD    	+ X4Y_DRNK_HABIT_RSPS_CD	+ X4Y_TM1_DRKQTY_RSPS_CD	+ X4Y_EXERCI_FREQ_RSPS_CD	+
             	X6Y_HCHK_YEAR        	+ X6Y_YKIHO_GUBUN_CD    	+ X6Y_BMI               	+ X6Y_BP                 	+
             	X6Y_BLDS             	+ X6Y_TOT_CHOLE         	+ X6Y_HMG               	+ X6Y_OLIG_PROTE_CD      	+
             	X6Y_SGOT_AST         	+ X6Y_SGPT_ALT          	+ X6Y_GAMMA_GTP         	+ X6Y_SMK_STAT_TYPE_RSPS_CD  +
             	X6Y_SMK_TERM_RSPS_CD 	+ X6Y_DSQTY_RSPS_CD     	+ X6Y_DRNK_HABIT_RSPS_CD	+ X6Y_TM1_DRKQTY_RSPS_CD 	+
             	X6Y_EXERCI_FREQ_RSPS_CD
           	, data=csv_6Y, family=binomial)


#OR(Odds Ratio)ㄱㅖ산
sum_logr_6Y<-summary(logr_6Y)
para<-sum_logr_6Y$coefficients
OR<-exp(para[,1])
cbind(OR,para[,c(2,4)])

#회귀분석 결과 출력
capture.output(cbind(OR,para[,c(2,4)]), file = "glm_{illname}_{1}_{3}.txt")

#hoslem.test를/ R^2 통한 유의한 결과값 출력
capture.output(c("GLM analysis"), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                            	yearterm * (yearterm2),illname2)
library(ResourceSelection)
hoslem.test(logr_6Y$y, logr_6Y$fit)
capture.output(hoslem.test(logr_6Y$y, logr_6Y$fit), file = "glm_EXP:{0}_CTR:{4}_{1}_{3}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                            	yearterm * (yearterm2),illname2)
capture.output(hoslem.test(logr_6Y$y, logr_6Y$fit), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                            	yearterm * (yearterm2),illname2))
library(pscl)
capture.output(pR2(logr_6Y), file = "glm_EXP:{0}_CTR:{4}_{1}_{3}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                            	yearterm * (yearterm2),illname2)
capture.output(pR2(logr_6Y), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                            	yearterm * (yearterm2),illname2)

#회귀분석 결과에Stepwise Selection Method를 적용(이하 회귀분석과정과 동일)
Slm <- step(logr_6Y,direction = "both")

para<-summary(Slm)$coefficients
OR<-exp(para[,4])
cbind(OR,para[,c(2,4)])
capture.output(cbind(OR,para[,c(2,4)]), file = "slm_{illname}_2_6Y.txt")

capture.output(c("SLM analysis"), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm,yearterm * (yearterm2 - 1),
                                                                                       	yearterm * (yearterm2),illname2)
library(ResourceSelection)
hoslem.test(Slm$y, Slm$fit)
capture.output(hoslem.test(Slm$y, Slm$fit), file = "slm_EXP:{0}_CTR:{4}_{1}_{3}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                        	yearterm * (yearterm2),illname2)
capture.output(hoslem.test(Slm$y, Slm$fit), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2 - 1),
                                                                                                      	yearterm * (yearterm2), illname2)
library(pscl)
capture.output(pR2(Slm), file = "slm_EXP:{0}_CTR:{4}_{1}_{3}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2-1),
                                                                        	yearterm * (yearterm2),illname2)
capture.output(pR2(Slm), file = "Report_EXP:{0}_CTR:{4}.txt",append=TRUE)'.format(illname, yearterm, yearterm * (yearterm2 - 1),
                                                                                                      	yearterm * (yearterm2), illname2) 
