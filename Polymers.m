clc;
clear all;

D1 = xlsread('GCMS_groupeddata.xlsx','G1-polymers'); %Group-1 training data
D2 = xlsread('GCMS_groupeddata.xlsx','G2-polymers'); %Group-2 training data
D3 = xlsread('GCMS_groupeddata.xlsx','G3-polymers'); %Group-3 training data
D4 = xlsread('GCMS_groupeddata.xlsx','G4-polymers'); %Group-4 training data
%D = xlsread('GCMS_groupeddata.xlsx','ceramics'); %All training data for general PLS model

%--------------------------------------------------------------------------
% Separating inputs and outputs of the training sets % 6,7 for NF90 & NFX
x1 = D1(:,2:5); %Group-1
y1 = D1(:,6:8); 
x2 = D2(:,2:5); %Group-2
y2 = D2(:,6:8);
x3 = D3(:,2:5); %Group-3
y3 = D3(:,6:8);
x4 = D4(:,2:5); %Group-4
y4 = D4(:,6:8);
x = [x1;x2;x3;x4]; % Complete training data
y = [y1;y2;y3;y4];
%--------------------------------------------------------------------------
%Testing data
Dte = xlsread('GCMS_groupeddata.xlsx','TestingData'); 
xte1 = Dte(1:3,2:5)
yte1 = Dte(1:3,8:10)
xte2 = Dte(4:5,2:5)
yte2 = Dte(4:5,8:10)
xte3 = Dte(6,2:5)
yte3 = Dte(6,8:10)
xte4 = Dte(7,2:5)
yte4 = Dte(7,8:10)
%-------------------------------------------------------------------------
%Model building subgroups
[RMSEE1,yhattr1, R2_1,yhat1cv,Qsq1,c1,wstar1] = crossvalfunc(x1,y1,2);
[RMSEE2,yhattr2, R2_2,yhat2cv,Qsq2,c2,wstar2] = crossvalfunc(x2,y2,1);
[RMSEE3,yhattr3, R2_3,yhat3cv,Qsq3,c3,wstar3] = crossvalfunc(x3,y3,3);
[RMSEE4,yhattr4, R2_4,yhat4cv,Qsq4,c4,wstar4] = crossvalfunc(x4,y4,2);

%building general PLS model and calculating separate RMSEE for each group
%from this model

%x = [x1;x2]
%y = [y1;y2]
[RMSEE_generalPLS,yhattr, R2,yhatcv,Qsq,c,wstar] = crossvalfunc(x,y,2);

xcs1 = (x1 - mean(x))./std(x)
yhat1 = xcs1*wstar*c'         %general PLS model
yhat1 = yhat1.*std(y)+mean(y);
res1 = yhat1 - y1
RSS = sum(sum(res1.*res1))
TSS = sum(sum((y1-mean(y1)).*(y1-mean(y1))))
RMSEE_gen1 = sqrt(RSS/size(y1,1))

xcs2 = (x2 - mean(x))./std(x)
yhat2 = xcs2*wstar*c'     %general PLS model
yhat2 = yhat2.*std(y)+mean(y)
res2 = yhat2 - y2
RSS = sum(sum(res2.*res2))
TSS = sum(sum((y2-mean(y2)).*(y2-mean(y2))))
RMSEE_gen2 = sqrt(RSS/size(y2,1))

xcs3 = (x3 - mean(x))./std(x)
yhat3 = xcs3*wstar*c'     %general PLS model
yhat3 = yhat3.*std(y)+mean(y)
res3 = yhat3 - y3
RSS = sum(sum(res3.*res3))
TSS = sum(sum((y3-mean(y3)).*(y3-mean(y3))))
RMSEE_gen3 = sqrt(RSS/size(y3,1))

xcs4 = (x4 - mean(x))./std(x)
yhat4 = xcs4*wstar*c'       %general PLS model
yhat4 = yhat4.*std(y)+mean(y)
res4 = yhat4 - y4
RSS = sum(sum(res4.*res4))
TSS = sum(sum((y4-mean(y4)).*(y4-mean(y4))))
RMSEE_gen4 = sqrt(RSS/size(y4,1))

%--------------------------------------------------------------------------
%Testing set calculations (4 models x 4 testsets)

%Model-1, Test set-1
xcste_11 = (xte1 - mean(x1))./std(x1) 
yhatte_11 = xcste_11*wstar1*c1'         
yhatte_11 = yhatte_11.*std(y1)+mean(y1)
reste_11 = yhatte_11 - yte1
RSS_11 = sum(sum(reste_11.*reste_11))
TSS_11 = sum(sum((yte1-mean(yte1)).*(yte1-mean(yte1))))
RMSEP_11 = sqrt(RSS_11/size(yte1,1))

%Model-1, Test set-2
xcste_12 = (xte2 - mean(x1))./std(x1) 
yhatte_12 = xcste_12*wstar1*c1'         
yhatte_12 = yhatte_12.*std(y1)+mean(y1)
reste_12 = yhatte_12 - yte2
RSS_12 = sum(sum(reste_12.*reste_12))
TSS_12 = sum(sum((yte2-mean(yte2)).*(yte2-mean(yte2))))
RMSEP_12 = sqrt(RSS_12/size(yte2,1))

%Model-1, Test set-3
xcste_13 = (xte3 - mean(x1))./std(x1) 
yhatte_13 = xcste_13*wstar1*c1'         
yhatte_13 = yhatte_13.*std(y1)+mean(y1)
reste_13 = yhatte_13 - yte3
RSS_13 = sum(sum(reste_13.*reste_13))
TSS_13 = sum(sum((yte3-mean(yte3)).*(yte3-mean(yte3))))
RMSEP_13 = sqrt(RSS_13/size(yte3,1))

%Model-1, Test set-4
xcste_14 = (xte4 - mean(x1))./std(x1) 
yhatte_14 = xcste_14*wstar1*c1'         
yhatte_14 = yhatte_14.*std(y1)+mean(y1)
reste_14 = yhatte_14 - yte4
RSS_14 = sum(sum(reste_14.*reste_14))
TSS_14 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_14 = sqrt(RSS_14/size(yte4,1))

%Model-2, Test set-1
xcste_21 = (xte1 - mean(x2))./std(x2) 
yhatte_21 = xcste_21*wstar2*c2'         
yhatte_21 = yhatte_21.*std(y2)+mean(y2)
reste_21 = yhatte_21 - yte1
RSS_21 = sum(sum(reste_21.*reste_21))
TSS_21 = sum(sum((yte1-mean(yte1)).*(yte1-mean(yte1))))
RMSEP_21 = sqrt(RSS_21/size(yte1,1))

%Model-2, Test set-2
xcste_22 = (xte2 - mean(x2))./std(x2) 
yhatte_22 = xcste_22*wstar2*c2'         
yhatte_22 = yhatte_22.*std(y2)+mean(y2)
reste_22 = yhatte_22 - yte2
RSS_22 = sum(sum(reste_22.*reste_22))
TSS_22 = sum(sum((yte2-mean(yte2)).*(yte2-mean(yte2))))
RMSEP_22 = sqrt(RSS_22/size(yte2,1))

%Model-2, Test set-3
xcste_23 = (xte3 - mean(x2))./std(x2) 
yhatte_23 = xcste_23*wstar2*c2'         
yhatte_23 = yhatte_23.*std(y2)+mean(y2)
reste_23 = yhatte_23 - yte3
RSS_23 = sum(sum(reste_23.*reste_23))
TSS_23 = sum(sum((yte3-mean(yte3)).*(yte3-mean(yte3))))
RMSEP_23 = sqrt(RSS_23/size(yte3,1))

%Model-2, Test set-4
xcste_24 = (xte4 - mean(x2))./std(x2) 
yhatte_24 = xcste_24*wstar2*c2'         
yhatte_24 = yhatte_24.*std(y2)+mean(y2)
reste_24 = yhatte_24 - yte4
RSS_24 = sum(sum(reste_24.*reste_24))
TSS_24 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_24 = sqrt(RSS_24/size(yte4,1))

%Model-3, Test set-1
xcste_31 = (xte1 - mean(x3))./std(x3) 
yhatte_31 = xcste_31*wstar3*c3'         
yhatte_31 = yhatte_31.*std(y3)+mean(y3)
reste_31 = yhatte_31 - yte1
RSS_31 = sum(sum(reste_31.*reste_31))
TSS_31 = sum(sum((yte1-mean(yte1)).*(yte1-mean(yte1))))
RMSEP_31 = sqrt(RSS_31/size(yte1,1))

%Model-3, Test set-2
xcste_32 = (xte2 - mean(x3))./std(x3) 
yhatte_32 = xcste_32*wstar3*c3'         
yhatte_32 = yhatte_32.*std(y3)+mean(y3)
reste_32 = yhatte_32 - yte2
RSS_32 = sum(sum(reste_32.*reste_32))
TSS_32 = sum(sum((yte2-mean(yte2)).*(yte2-mean(yte2))))
RMSEP_32 = sqrt(RSS_32/size(yte2,1))

%Model-3, Test set-3
xcste_33 = (xte3 - mean(x3))./std(x3) 
yhatte_33 = xcste_33*wstar3*c3'         
yhatte_33 = yhatte_33.*std(y3)+mean(y3)
reste_33 = yhatte_33 - yte3
RSS_33 = sum(sum(reste_33.*reste_33))
TSS_33 = sum(sum((yte3-mean(yte3)).*(yte3-mean(yte3))))
RMSEP_33 = sqrt(RSS_33/size(yte3,1))

%Model-3, Test set-4
xcste_34 = (xte4 - mean(x3))./std(x3) 
yhatte_34 = xcste_34*wstar3*c3'         
yhatte_34 = yhatte_34.*std(y3)+mean(y3)
reste_34 = yhatte_34 - yte4
RSS_34 = sum(sum(reste_34.*reste_34))
TSS_34 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_34 = sqrt(RSS_34/size(yte4,1))

%Model-4, Test set-1
xcste_41 = (xte1 - mean(x4))./std(x4) 
yhatte_41 = xcste_41*wstar4*c4'         
yhatte_41 = yhatte_41.*std(y4)+mean(y4)
reste_41 = yhatte_41 - yte1
RSS_41 = sum(sum(reste_41.*reste_41))
TSS_41 = sum(sum((yte1-mean(yte1)).*(yte1-mean(yte1))))
RMSEP_41 = sqrt(RSS_41/size(yte1,1))

%Model-4, Test set-2
xcste_42 = (xte2 - mean(x4))./std(x4) 
yhatte_42 = xcste_42*wstar4*c4'         
yhatte_42 = yhatte_42.*std(y4)+mean(y4)
reste_42 = yhatte_42 - yte2
RSS_42 = sum(sum(reste_42.*reste_42))
TSS_42 = sum(sum((yte2-mean(yte2)).*(yte2-mean(yte2))))
RMSEP_42 = sqrt(RSS_42/size(yte2,1))

%Model-4, Test set-3
xcste_43 = (xte3 - mean(x4))./std(x4) 
yhatte_43 = xcste_43*wstar4*c4'         
yhatte_43 = yhatte_43.*std(y4)+mean(y4)
reste_43 = yhatte_43 - yte3
RSS_43 = sum(sum(reste_43.*reste_43))
TSS_43 = sum(sum((yte3-mean(yte3)).*(yte3-mean(yte3))))
RMSEP_43 = sqrt(RSS_43/size(yte3,1))

%Model-4, Test set-4
xcste_44 = (xte4 - mean(x4))./std(x4) 
yhatte_44 = xcste_44*wstar4*c4'         
yhatte_44 = yhatte_44.*std(y4)+mean(y4)
reste_44 = yhatte_44 - yte4
RSS_44 = sum(sum(reste_44.*reste_44))
TSS_44 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_44 = sqrt(RSS_44/size(yte4,1))

%Genral PLS model, Test set-1
xcste_1 = (xte1 - mean(x))./std(x) 
yhatte_1 = xcste_1*wstar*c'         
yhatte_1 = yhatte_1.*std(y)+mean(y)
reste_1 = yhatte_1 - yte1
RSS_1 = sum(sum(reste_1.*reste_1))
TSS_1 = sum(sum((yte1-mean(yte1)).*(yte1-mean(yte1))))
RMSEP_1 = sqrt(RSS_1/size(yte1,1))

%Genral PLS model, Test set-2
xcste_2 = (xte2 - mean(x))./std(x) 
yhatte_2 = xcste_2*wstar*c'         
yhatte_2 = yhatte_2.*std(y)+mean(y)
reste_2 = yhatte_2 - yte2
RSS_2 = sum(sum(reste_2.*reste_2))
TSS_2 = sum(sum((yte2-mean(yte2)).*(yte2-mean(yte2))))
RMSEP_2 = sqrt(RSS_2/size(yte2,1))

%Genral PLS model, Test set-3
xcste_3 = (xte3 - mean(x))./std(x) 
yhatte_3 = xcste_3*wstar*c'         
yhatte_3 = yhatte_3.*std(y)+mean(y)
reste_3 = yhatte_3 - yte3
RSS_3 = sum(sum(reste_3.*reste_3))
TSS_3 = sum(sum((yte3-mean(yte3)).*(yte3-mean(yte3))))
RMSEP_3 = sqrt(RSS_3/size(yte3,1))

%Genral PLS model, Test set-4
xcste_4 = (xte4 - mean(x))./std(x) 
yhatte_4 = xcste_4*wstar*c'         
yhatte_4 = yhatte_4.*std(y)+mean(y)
reste_4 = yhatte_4 - yte4
RSS_4 = sum(sum(reste_4.*reste_4))
TSS_4 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_4 = sqrt(RSS_4/size(yte4,1))

%------------------------------------------------------------------------
%calculating RMSEP of grouped and general PLS model over all testing sets

yhatte_generalPLS = [yhatte_1;yhatte_2;yhatte_3;yhatte_4];
yte = [yte1;yte2;yte3;yte4];
reste_generalPLS = yhatte_generalPLS - yte;
RSS = sum(sum(reste_generalPLS.*reste_generalPLS));
TSS = sum(sum((yte-mean(yte)).*(yte-mean(yte))));
RMSEP_generalPLS = sqrt(RSS/size(yte,1))

yhatte_grouped = [yhatte_11;yhatte_22;yhatte_33;;yhatte_44]
reste_grouped = yhatte_grouped - yte
RSS = sum(sum(reste_grouped.*reste_grouped))
TSS = sum(sum((yte-mean(yte)).*(yte-mean(yte))))
RMSEP_grouped = sqrt(RSS/size(yte,1))

reste_grouped_NF90 = reste_grouped(:,1)
yte_NF90 = yte(:,1)
RSS = sum(sum(reste_grouped_NF90.*reste_grouped_NF90))
RMSEP_NF90 = sqrt(RSS/size(yte_NF90,1))

reste_grouped_NFX = reste_grouped(:,2)
yte_NFX = yte(:,2)
RSS = sum(sum(reste_grouped_NFX.*reste_grouped_NFX))
RMSEP_NFX = sqrt(RSS/size(yte_NFX,1))

reste_grouped_NFS = reste_grouped(:,3)
yte_NFS = yte(:,3)
RSS = sum(sum(reste_grouped_NFS.*reste_grouped_NFS))
RMSEP_NFS = sqrt(RSS/size(yte_NFS,1))

%-------------------------------------------------------------------------
%calculation of overall metrics 
yconcat = [y1;y2;y3;y4]
yhatconcat = [yhattr1;yhattr2;yhattr3;yhattr4]
res = yconcat - yhatconcat
RSS = sum(sum(res.*res))
TSS = sum(sum((yconcat-mean(yconcat)).*(yconcat-mean(yconcat))))
RMSEE_groupedmodel = sqrt(RSS/size(yconcat,1))
R2_groupedmodel = 1-RSS/TSS

resNF90 = res(:,1)
yNF90 = yconcat(:,1)
RSS = sum(sum(resNF90.*resNF90))
TSS = sum(sum((yNF90-mean(yNF90)).*(yNF90-mean(yNF90))))
RMSEE_NF90 = sqrt(RSS/size(yNF90,1))
R2_NF90 = 1-RSS/TSS

resNFX = res(:,2)
yNFX = yconcat(:,2)
RSS = sum(sum(resNFX.*resNFX))
TSS = sum(sum((yNFX-mean(yNFX)).*(yNFX-mean(yNFX))))
RMSEE_NFX = sqrt(RSS/size(yNFX,1))
R2_NFX = 1-RSS/TSS

resNFS = res(:,3)
yNFS = yconcat(:,3)
RSS = sum(sum(resNFS.*resNFS))
TSS = sum(sum((yNFS-mean(yNFS)).*(yNFS-mean(yNFS))))
RMSEE_NFS = sqrt(RSS/size(yNFS,1))
R2_NFS = 1-RSS/TSS

yhatconcat = [yhat1cv;yhat2cv;yhat3cv;yhat4cv]
res = yconcat - yhatconcat
RSS = sum(sum(res.*res))
TSS = sum(sum((yconcat-mean(yconcat)).*(yconcat-mean(yconcat))))
RMSEPcv_groupedmodel = sqrt(RSS/size(yconcat,1))
Q2_groupedmodel = 1-RSS/TSS

resNF90 = res(:,1)
yNF90 = yconcat(:,1)
RSS = sum(sum(resNF90.*resNF90))
TSS = sum(sum((yNF90-mean(yNF90)).*(yNF90-mean(yNF90))))
RMSEPcv_NF90 = sqrt(RSS/size(yNF90,1))
Q2_NF90 = 1-RSS/TSS
 
resNFX = res(:,2)
yNFX = yconcat(:,2)
RSS = sum(sum(resNFX.*resNFX))
TSS = sum(sum((yNFX-mean(yNFX)).*(yNFX-mean(yNFX))))
RMSEPcv_NFX = sqrt(RSS/size(yNFX,1))
Q2_NFX = 1-RSS/TSS

resNFS = res(:,3)
yNFS = yconcat(:,3)
RSS = sum(sum(resNFS.*resNFS))
TSS = sum(sum((yNFS-mean(yNFS)).*(yNFS-mean(yNFS))))
RMSEPcv_NFS = sqrt(RSS/size(yNFS,1))
Q2_NFS = 1-RSS/TSS

%-------------------------------------------------------------------------
% finding coeff of model equations
% Model-i [y200Da y450Da] = [MW pKa Kow Sol]Ai + Bi

coeff1 = wstar1*c1';
A1temp = std(x1)'.*coeff1;
A1 = A1temp./std(y1);
B1temp = mean(x1)*coeff1;
B1 = (B1temp - mean(y1))./std(y1);

coeff2 = wstar2*c2';
A2temp = std(x1)'.*coeff1;
A2 = A2temp./std(y2);
B2temp = mean(x2)*coeff2;
B2 = (B2temp - mean(y2))./std(y2);

coeff3 = wstar3*c3';
A3temp = std(x3)'.*coeff3;
A3 = A3temp./std(y3);
B3temp = mean(x3)*coeff3;
B3 = (B3temp - mean(y3))./std(y3);

coeff4 = wstar4*c4';
A4temp = std(x4)'.*coeff4;
A4 = A4temp./std(y4);
B4temp = mean(x4)*coeff4;
B4 = (B4temp - mean(y4))./std(y4);
 
 