# QSAR (Quality Structure Activity Relationship) model for ceramic and polymer nanofiltration

## Introduction

IWW may contain up to 100 different organic compounds in a single batch of wastewater. Every batch of wastewater received by Aevitas has a different composition of compounds present in it, mostly due to working with numerous clients and changes in client’s day-to-day activities in generating wastewater. Nanofiltration treatment of such a WW is able to reject every organic to a certain degree which ranges from anywhere between 0 to 100 % depending on physical and chemical properties of that compound, interaction with the membrane and interaction with other compounds in the wastewater matrix. This % rejection value for each component in the wastewater can be measured using Gas chromatography-Mass spectroscopy (GC-MS) of the feed and permeate (treated wastewater) samples from lab scale testing. A dataset of % rejection of all the compounds identified and all the membranes tested can then be used to build regression models for prediction on unseen compounds. A good model can eliminate the need for lab scale testing and help in decision making for eg. choosing membranes, deciding future treatment steps etc. This section shows such a predictive model building approach and testing results for compounds identified in 6 real IWW samples when tested with 5 nanofiltration membranes.  

A large peak rejection dataset was collected as shown in Tables 12, 13 and Tables A3-8 in Appendix. In this section, we attempt to build model(s) for predicting % peak area rejections for each membrane. Rejection results were combined into a single table (Table A2) by only keeping the peaks that were matched with library compounds. Rejections for compounds that occurred in multiple wastewaters were averaged and the error values show the standard deviation in rejection observed for that compound. Note that the magnitude of error values shows the variation in rejection of a compound across different wastewaters. Interestingly, most of the compounds that occurred in multiple wastewaters had low error values and therefore similar rejection values were observed except for a few compounds which are highlighted in Table A2 (see Appendix). Based on this observation, the following modeling exercise assumes that compound rejection is only affected by the physical/chemical properties of the compound and membrane and does not depend on interaction with other compounds in the wastewater matrix.

Separation of organic compounds during nanofiltration depends on numerous factors and their contributions to the degree of rejection cannot be captured in a first principles model easily. However, it is known that for any class of compounds for e.g. polyethylene glycols (PEGs), % rejection by a membrane is related to the molecular weight (MW) of the compound through characteristic rejection curve which is typically used to determine a membrane’s molecular weight cut off (MWCO). Other chemical properties like acid dissociation constant (pKa) in conjunction with solution pH describes the extent to which a compound is dissociated and present in its ionic form. This affects rejection depending on the attractive/repulsive electrostatic force experienced due to surface charges present on the membrane. 4 such chemical properties are selected to describe the properties of the compounds in our dataset :

1.	Molecular weight (MW)
2.	Acid dissociation constant (pKa)
3.	Octanol-water partition (Kow)
4.	Solubility in pure water at 20 oC (Sol)

A compound-property dataset was collected using online NCBI (National Center for Biotechnology Information) database and concatenated with the membrane rejections from lab scale testing to get a final dataset shown in Table 14. Input matrix (MW, pKa, Kow, Sol) will be referred as ‘X’ and output matrix containing rejections (200-Da, 450-Da, 750-Da, 8500-Da, NF90, NFX, NFS) will be referred as ‘Y’ from here on in the report. The dataset is segregated into training and testing sets for the purpose of demonstrating prediction of the final trained model on unseen observations. 7 out of 41 observations were randomly selected and removed from the original dataset to make a testing set with 7 observations and a training set with 34 observations. The testing set observations are highlighted in Table below.

<img width="900" alt="Screen Shot 2021-07-19 at 9 02 02 PM" src="https://user-images.githubusercontent.com/18342812/126246817-e1223476-55d5-4162-bb0d-02c632eaee7e.png">

## Grouped PCA-PLS predictive modeling approach

Combined PCA-PLS modeling approach flowchart is shown below (More details about why this framework was chosen can be found here [here](https://mcmasteru365-my.sharepoint.com/:b:/g/personal/agnihs1_mcmaster_ca/EW-7-QgXVMFGjn-Kq5tITusBsbW8HtjsUZ_pM3mTwMP8sg)). First a PCA model will be trained on the inputs (MW, pKa, Kow, Sol) of the training data and subsets of compounds will be recognized using the score plot, this can be done manually or using a clustering algorithm. Observations within each group/subset will then be used to train multiple PLS models. So, if 4 groups were identified by PCA, a total of 4 PLS models will be trained. Note that for a new testing observation, the PCA model will classify the observation into one of the groups, and hence the PCA model decides which PLS model will be used to predict the output for that observation.

<img width="861" alt="Screen Shot 2021-07-19 at 9 20 54 PM" src="https://user-images.githubusercontent.com/18342812/126247902-79c14a22-2ece-41f8-a213-832eefe8d87d.png">




## Grouped PCA-PLS models training 

First, a PCA model was built on X and corresponding score plot is shown in Figure 28. Note the different regions on the plot where observations are clustered. The 4 groups of compounds were manually identified using score plot which are listed in Table 15. Note that the clustering is very similar to the clustering observed in the PLS score plot earlier. Group-1 compounds consist of monocarboxylic and dicarboxylic acids, most of Group-2 compounds are alcohols, Group-3 consist of short chain (C2-C5) alcohols/acids, and Group-4 consist of long chain (C16-C20) monocarboxylic acids.

<img width="633" alt="image" src="https://user-images.githubusercontent.com/18342812/126247717-4d1920c0-b931-4170-8728-0c365f07b41e.png">

<img width="633" alt="image" src="https://user-images.githubusercontent.com/18342812/126248076-080180d6-a517-42a5-b7fc-d86179e1b74a.png">

## Model training and testing results 

PLS models were trained using NIPALS algorithm with leave-one-out cross validation strategy coded in Matlab. All the following results were generated using the same customized functions and verified using Aspen ProMV. Results were not generated directly using Aspen ProMV due to its inability to perform leave-one-out cross validation which is required when working with small datasets such as ours. For both ceramic and polymeric membranes, a General PLS model was also trained which is trained on all observations. This model is only shown for comparison purposes with the Grouped PCA-PLS modeling approach.

<img width="771" alt="image" src="https://user-images.githubusercontent.com/18342812/126249676-7130ab57-1eea-4f21-afb5-002981307451.png">

Note that each of the outputs y_i  shown in equations 7 to 10 is a vector (2 dimensional for ceramic models and 3 dimensional for polymeric) so all subtraction and squaring operations are done element wise. R2 describes how well the model performs on the training set, Q2 describes the predictive power of the model, RMSEE stands for root mean square error in estimation which is calculated on the training set, similarly RMSEP stands for root mean square error in prediction which is calculated on the corresponding testing set.

Before calculating RMSEP, testing set observations need to be classified into one of the predefined groups using the PCA model. All 7 testing observations were plotted on the PCA score plot shown in Figure 29. Based on regions defined for the 4 groups earlier, three of the compounds were estimated to be from Group-1, two from Group-2 and one each from Group-3 & 4. Table 17 lists down the testing observations and their estimated groups. Notice how the three testing observations estimated to be from Group-1 were all acids which was our generalized idea of compounds belonging to Group-1. Similarly, the two testing observations estimated to be from Group-2 were alcohols. This shows that PCA is a great tool to automate grouping of similar compounds.

<img width="467" alt="image" src="https://user-images.githubusercontent.com/18342812/126248735-13b4f421-ceb9-483d-b5c9-d3235847c0cd.png">

<img width="433" alt="image" src="https://user-images.githubusercontent.com/18342812/126248771-6786c1cd-1567-48c3-a73a-cdc1ada94b53.png">



Results from model training and testing are summarized in Table 18. Low R2 and Q2 values are observed for General PLS models (Ceramic: R2 = 0.40, Q2 = 0.12 ; Polymeric: R2 = 0.34, Q2 = 0.09) which is why these models are not used for final predictions. On the other hand, a Grouped PCA-PLS model for ceramic membranes had an R2 = 0.71 and Q2 = 0.46. Note that this Grouped PCA-PLS model consist of three PLS models (‘C-Model-1’, ‘C-Model-2’ and ‘C-Model-4’). Metrics for each individual PLS model are also shown in the same table. Compounds from Group-2 which are modeled using ‘C-Model-2’ are not well predicted due to low Q2 (0.05) value, but the average predictive performance over all groups of compounds is fair with a Q2 = 0.46. Similarly, the Grouped PCA-PLS model for polymeric membranes had an R2 = 0.89 and Q2 = 0.67 showing good predictive performance. Looking into the individual models that are within this grouped model, we find that compounds from Group-2 (model ‘P-Model-2’) were the most difficult to predict due to least Q2 (0.33) among the four PLS models.

<img width="612" alt="image" src="https://user-images.githubusercontent.com/18342812/126249112-f6a37753-2106-4d37-b04e-2ca1d812d441.png">

<img width="617" alt="image" src="https://user-images.githubusercontent.com/18342812/126249150-d9df20fb-2ebd-4c0f-9e21-34f1514424ed.png">


Improved RMSEE was observed for Grouped PCA-PLS model (RMSEE = 19.1) when compared with General PLS model (RMSEE = 27.5) for ceramic membranes. However, only a marginal improvement in testing performance was observed (RMSEP = 22.5, 23.3 for Grouped PCA-PLS and General PLS model respectively). The Grouped PCA-PLS model for ceramic membranes is chosen over the General PLS model due to higher Q2. For polymeric membranes, Grouped PCA-PLS model achieved good results with significantly improved metrics when compared to its corresponding General PLS model. More than 50% improvement in both RMSEE and RMSEP was observed for Grouped PCA-PLS model. It should be noted that the absolute values of RMSEE and RMSEP for each of the Grouped PCA-PLS models shown in Table 18 are a combination of errors in % rejection for multiple membranes, 2 membranes for ceramic membrane models and 3 membranes for polymeric membrane models. Equation 11 is the general equation relating the RMSE for individual membranes to the overall model RMSE. Individual membrane RMSE values are important in understanding how far off our model predictions lie from the actual ‘% rejection’ values. For e.g. RMSEP200-Da = 10 would mean that the model has a RMSE of 10% for 200-Da membrane while testing. This would imply that 68% of our testing observations have predictions within 10% of the actual membrane rejection, assuming data points are coming from a gaussian distribution. Individual membrane RMSE values are reported in Table 19 along with individual membrane R2 and Q2 values to quantify prediction performance for each membrane. Based on predictions from the Grouped PCA-PLS models, RMSEE & RMSEP for all polymer membranes was observed to be low (< 10) as shown in Table 19. Slightly higher RMSE values were observed for 200-Da membrane with an RMSEP of 13.6. Worst training and testing performance were observed for 450-Da membrane with an RMSEP equal to 18.0, which means that on an average the error in prediction for 450-Da membrane could be as high as 18%. For all practical purposes of decision making at any industry like Aevitas, an acceptable error in performance prediction could be around 15%. Based on this assumption, it is reasonable to say that all membranes except 450-Da showed good predictability while error in prediction for 450-Da membrane were slightly above the 15% margin.

<img width="1055" alt="image" src="https://user-images.githubusercontent.com/18342812/126249221-ebfba891-2881-4056-b3e0-3a2dd7221917.png">

<img width="1055" alt="image" src="https://user-images.githubusercontent.com/18342812/126249268-536a86ba-2afb-4843-a39b-360380a073ae.png">

