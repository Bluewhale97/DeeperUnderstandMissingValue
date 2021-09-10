#1. resources of getting study of missing data

#classic text: Little and Rubin(2002)
#excellent, accessible reviews, Allison(2001)
#Schafer and Graham(2002)
#Schlomer, Bauman, and Card(2010)

#a compprehensive appraoch usually includes the following steps

#a. identify the missing data
#b. examine the causes of the missing data
#c. delete the cases containing missing data, or replace(impute) the missing values with reasonable alternative data values


#2. a classification system for missing data

#missing completely at random: if the presence of missing data on a variable is unrelated to any other observed r unobserved variable, then the data are missing completelt at random(MCAR)
#if we consider every variable with missing data is MCAR, we can consider the complete cases to be a sinple random sample from the larger dataset

#missing at random- if the presence of missing data on a variable is related to other observed variables but not to its own unobserved value. The data are missing at random(MAR)

#not missing at random: if the missing data for a varaible are neither MCAR nor MAR, the data are not missing at random(NMAR)

#most approaches to missing data assume that the data are either MCAR or MAR

#data that are NMAR can be difficult to anallyze properly. When data are NMAR, we have to model the mechanisms that produced the missing values, as well as the relationships of interest
#current approaches to analyzing NMAR data include the use of selection models and pattern mixtures.


#3. general steps of hackling with missing values

#a. step1: identify missing values: is.na(), !complete.cases(), VIM package
#b. step2: 
#method 1: delete missing value: Casewise(Listwise): omit.na() or Available Case(Pairwise):Option available for some functions
#method 2: maximum likelihood estimation: mvmle package
#method 3: impute missing values: single(simple) imputation:Hmisc Package or Multiple imputation:mi package, mice package, amelia package and mitools package

#4. identifying missing values

#represents missing values using the symbol NA(not available) and impossible values using the symbol NaN(not a number)

#the symbols Inf and -Inf represent positive infinity and negative infinity

#the functions is.na(), is.nan() and is.infinite() can be used to identify missing, impossible and infinite values.
#each returns either TRUE or FALSE

#5. examples of return values for the is.na(), is.nan(), and is.infinite() functions

# x            is.na(x)         is.nan(x)              is.infinite(x)

#x<-NA           T                F                            F
#x<-0/0          T                T                            F
#x<-1/0          F                F                            T

#these functions return an object that is the same size as its argument, with each element relaced by TRUE if the element is of the type being tested or FALSE otherwise

#the function complete.cases() can be used to identify the rows in a matrix or data frame that dont contain missing data. It returns a logical vector with TRUE for every row that contains complete cases and FALSE for every row that has one or more missing values

data(sleep, package="VIM")

#list the rows that do not have missing values
sleep[complete.cases(sleep),]

#list the rows that have one or more missing values
sleep[!complete.cases(sleep),]

#42 cases have complete data and 20 cases have one or more missing values

#since the logical values TRUE and FALSE are equivalent to the numeric values 1 and 0, the sum() and mean() functions can be used to obtain useful information about missing data
sum(is.na(sleep$Dream))
mean(is.na(sleep$Dream))
mean(!complete.cases(sleep))

complete.cases(sleep)
#complete.cases() only identifies NA and NaN as missing
#infinite values(Inf and -Inf) are treated as valid values
#second, we mus tuse missing0values functions to identify the missing values, the logical comparisons such as myvar == NA are never true


#6. exploring missing values patterns

#tabulating missing values
library(mice)
data(sleep, package="VIM")
md.pattern(sleep)

#last column indicates the number of missing values
#the columns within the table except the first and last column indicate the detailed missing situations
#the first column is the number of observations that have missing values 
#the last row of last column 38 indicates the total missing values


#7. exploring missing data visually

#VIM package provides numerous functions for visualizing missing values in datasets, including aggr(), matrixpot(), and scattMiss()

library("VIM")
aggr(sleep, prop=F, numbers=T)
#the VIM opens a GUI interface, we can close it

#we can see the variable NonD has the largest number of missing values(14) and that two mammals are missing NonD, Dream and Sleep scores, forty two mammals have no missing data

#matrixplot() function produces a plot displaying the data for each case
matrixplot(sleep)
#here, the numeric data are rescaled to the interval[0,1] anre represented by grayscale colors, with lighter colors representing lower values and darker colors representing larger values
#by default, missing values are rpresented in red

#here we can see that there are no missing values on sleep variables(Dream, NonD, Sleep) for low values of body or brain weight

marginplot(sleep[c("Gest","Dream")], pch=c(20),
           col=c("darkgray","red","blue"))
#marginplot() produces a scatterplot between two variables with information about missing values hown in the plot's margins
#this graph considers the relationship between the amount of dream sleep and the length of a mammal's gestation
#pch and col are optional and provide control over the plotting symbols and colors used

#the body of the graph displays the scatter plot between Gest and Dream
#in the left margin, box plots display the distribution of Deam for mammals with(dark gray) and without(red) Gest values
#in the bottom margin, the roles of Gest and Dream are reversed

#we can see that a negative relationship existes between length of gestation and dream sleep and that dream sleep tends to be higher for mamals that are missing a gestation score

#8. using correlations to explore missing values

#we can replace the data in a dataset with indicator variables, coded 1 for missing and 0 for present
#the resulting matrix is sometimes called a shadow matrix

x<-as.data.frame(abs(is.na(sleep)))
head(sleep,n=5)
head(x,n=5)

y<-x[which(apply(x,2,sum)>0)]
#extracts the variables that have some(but not all) missing values, and 
cor(y)
#provides the coorelations among these indicator variables

#here we can see that Dream and NonD tend to be missing together(r=0.91), to a lesser extent, sleep and NonD tend to be missing together(r=.49)and sleep and dream tend to be missing together(r=.2)

#finally, we can look at the relationship between missing values in a varibale and the observed values on other variables
cor(sleep, y, use="pairwise.complete.obs")

#the rows are observed variables and the columns are indicator variables representing missingness
#we can ignore the warning message and NA values in the correlation matrix; thet're artifacts of our approach

#for the first colum we can see that nondreaming sleep scores are more likely to be missing for mammals with higher body weight(r=.227)
#none of the correlations in this table are particularly large or striking, which suggests that the data deviate minimally from MCAR and may be MAR


#9. understanding the sources and impact of missing data

#answering several questions
#a. what percentage of the data is missing?
#b. are the missing data concentrated in a few variables or widely distributed?
#c. do the missing values appear to be random?
#d. does the covariation of missing data with each other or with observed data syggest a possible mechanism that is producing the missing values?

#if the missing data are concentrated in a few relatively unimportant variables, we may be able to delete these variables and continue the analyses normally
#if a small amount of data(say, less than 10%)is randomly distributed throughout the dataset(MCAR), we may be able to limit the analyses to cases with complete data and still get reliable and valid results
#if we can assume that the data are either MCAR or MAR, we may be able to apply multiple imputation methods to arrive at valid conclusions
#if the data are NMAR. we can trun to specialized methods, collect new data or go into an easier and more rewarding profession


#10. rational approaches for dealing with incomplete data

#in a rational approach, we use mathematical or logical relationships among variables to attempt to fill in or recover missing values

#in the sleep dataset, the variable Sleep is the sum of Dream and NonD variables. If we know a mamaml's scores on any two, we can derive the third. Thus if some observations were missing only one of the three variables, we could recover the missing information through addition or subtraction

#if we know a relationship between variables, and the missing value of that vairable can be computed through the relationship

#logical relationship also can help solve the missing values problems, if for example we know that someone had one or more direct reports, it would be reasonable to infer he were a manager

#a rational approach typcally requires creativity and thoughtfulness, along with a degree of data-management skill
#data recovery may be exact or approximate

#11. complete-case analysis(listwise deletion)

newdata<-mydata[complete.cases(mydata),]
#complete.cases() can be used to save the cases(rows) of a matrix or data frame without missing data
newdata<-na.omit(mydata)
#same result can be accomplished with the na.omit function

options(digits=1)
cor(na.omit(sleep))
#the correlations in this table are based solely on the 42 mammals that have complete data on all variables
#if we wanted to study the impact of the life span and length of gestation on the amount of dream sleep, we could employ linear regression with listwise deletion
fit<-lm(Dream~Span+Gest, data=na.omit(sleep))
summary(fit)
#we see that the mammals with shorter gestation periods have more dream sleep(controlling for life span)and that lifespan is unrelated to dream sleep when controlling for gestation period

#what would happen if we repalce data=na.omit(sleep) with data=sleep? lm() uses a limited efinition of listwise deleion. Cases with any missing data on the variables fitted by the function would have been deleted

#listwise deletion assumes that the data are MCAR
#if the MCAR assumption is violated, the resulting regression parameters will be biased.
#deleting all observations with missing data can also reduce statistical power by reducing the available sample szie


#12. multiple imputation
#provides an approach to missing values that is based on repeated simulations
#is freqyently the method of choice for complex missing-values problems
#Monte Carlo methods are used to fill in the missing data in each of the simulated datasets

#missing vlaues are imputed by Gibbs sampling in mice() function, by defualt each variable with missing values is predicted from all other variables in the dataset
#the process iterates untial convergence over the missing values is achieved
#for each variable, we can choose the form of the prediction model(called an elementary imputation method) and the variables entered into into

#by default, predictive mean matching is used to replace missing data on continuous variables, whereas logistic or polytomous logistic regression is used for target varibales that are dichotomous or polytomous
#other elementary imputation methods include Bayesian linear regression, discriminant function analysis, twolevel normal imputation and random sampling from observed values
library(mice)
imp<-mice(data)#data is a matrix or data frame containing missing values, imp is a list object containing the m imputed datasets, along with information on how the imputations were accomplished, by default m=5
fit<-with(imp, analysis)#analysis is a formula object specifying the statistical analysis to be applied to each of the m imputed datasets
#lm() for linear regression, glm() for generalized linear models, gam() for generalized additive models and nbrm() for negative binomial models
#fit is a list object containing the results of the m separate statistical analyses

pooled<-pool(fit)#containing the averagedresults of the m separate statistical analyses
summary(pooled)


library(mice)
data(sleep,package="VIM")
imp<-mice(sleep,seed=1234)
fit<-with(imp, lm(Dream~Span+Gest))
pooled<-pool(fit)
summary(pooled)

#here we see that the regression coefficient for Span isnt siginificant(p=.08) and the coefficient for Gest is significant at the p<.01 level 

#fmi column reports the fraction of missing information(that is, the proportion of variability that is attributable to the uncertainty introduced by the missing data)
imp
#from the resulting output, we can see that five synthetic datsets were created and that the predictive mean matching (pmm) method was used for each variable with missing data
#No imputation("") was needed for BodyWgt, BrainWgt, Pred, Exp, or Danger, because they had no missing values

#visitSequence tells that variables were imputed from right to left, starting with NonD and ending with Gest

#we can view the imputations by looking at subcomponents of imp object
imp$imp$Dream
#displays the 5 imputed values for each of the 12 mammals with missing data on the Dream varibale

complete(imp,action=#)
#where # specifies one of the m synthetically complete datasets

dataset3 <-complete(imp, action=3)
dataset3
#displays the thrid out of five complete dataset created by the multiple imputation process


#mi and Amelia packages also contain valuable approaches for MI
#multiple imputation FAQ page(www.stat.psu.edu/~jls/mifaq.html)
#articales by Vam=n Buuren and Groothuis-Oudshoorn(2010) and Yu-Sung, Gelman,Hill, and Yajima(2010)
#Amelia II: A Program for Missing Data(http"//gking.havard.edu/amelia)

#13. other approaches to missing data

#mvnmle   maximum-likelihood estimation for multivariate normal data with missing vlaues
#cat: analysis of categorical variable datasets with missing values
#arrayImpute, arrayMissPattern, and SeqKnn： useful functions for dealing with missing microarray data
#LongitudinalData: utility functions, including interpolation routines for imputing missing time series values
#kmi: kaplan-Meier multiple imputation for survival analysis with missing data
#mix: multiple imputation for mixed categorical and continuous data
#pan: multiple imputation for multivariate panel or clustered data

#14. pairwise deletion
cor(sleep, use="pairwise.complete.obs")

#is condered an alternative to listwise deletion when working with datasets that are missing values
#correlations between any two variables use all available observations for those two variables
#although pairwise deletion appears to use all available data, in fact each calculation is based on a different subset of the data. this can lead to distorted and difficult to interpret results

#15. simple(nonstochastic) imputation
#missing values in a variable are replaced with a single value(for example, mean, median or mode)
#using mean substitution, we could replace missing values on Kaplan-Meier multiple with value 1.97 and missing values on kaplan meier multiple with the vlaue 8.67
#note that the substitution is nonstochastic, meaning that random error isnt introduced(unlike with multipole imputation)

#an advantage of simple imputation is that it sovles the missing values probelm without reducing the sample size 
#but it produces biased results for data that isnt MCAR. If moderate to large amount of data are missing, simple imputation is likely to underestimate standard errors, distort correlations among variables and produce incorrect p values in statistical test
