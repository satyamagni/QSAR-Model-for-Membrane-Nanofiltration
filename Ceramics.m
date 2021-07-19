clc;
clear all;

D1 = xlsread('GCMS_groupeddata.xlsx','G1-ceramics'); %Group-1 training data
D2 = xlsread('GCMS_groupeddata.xlsx','G2-ceramics'); %Group-2 training data
D4 = xlsread('GCMS_groupeddata.xlsx','G4-ceramics'); %Group-4 training data
D = xlsread('GCMS_groupeddata.xlsx','ceramics'); %All training data for general PLS model

%--------------------------------------------------------------------------
% Separating inputs and outputs of the training sets % 6,7 for 200Da & 450Da
x1 = D1(:,2:5); %Group-1
y1 = D1(:,6:7); 
x2 = D2(:,2:5); %Group-2
y2 = D2(:,6:7);
x4 = D4(:,2:5); %Group-4
y4 = D4(:,6:7);
x = D(:,2:5); % Complete training data
y = D(:,6:7);

x = [x1;x2;x4]
y = [y1;y2;y4]

% x1 = [x1;x2];
% y1 = [y1;y2];
%--------------------------------------------------------------------------
%Testing data
Dte = xlsread('GCMS_groupeddata.xlsx','TestingData'); 
xte1 = Dte(1:3,2:5)
yte1 = Dte(1:3,6:7)
xte2 = Dte(4:5,2:5)
yte2 = Dte(4:5,6:7)
xte4 = Dte(7,2:5)
yte4 = Dte(7,6:7)
%-------------------------------------------------------------------------
%Model building subgroups
[RMSEE1,yhattr1, R2_1,yhat1cv,Qsq1,c1,wstar1] = crossvalfunc(x1,y1,1);
[RMSEE2,yhattr2, R2_2,yhat2cv,Qsq2,c2,wstar2] = crossvalfunc(x2,y2,3);
[RMSEE4,yhattr4, R2_4,yhat4cv,Qsq4,c4,wstar4] = crossvalfunc(x4,y4,2);

%building general PLS model and calculating separate RMSEE for each group
%from this model

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

xcs4 = (x4 - mean(x))./std(x)
yhat4 = xcs4*wstar*c'       %general PLS model
yhat4 = yhat4.*std(y)+mean(y)
res4 = yhat4 - y4
RSS = sum(sum(res4.*res4))
TSS = sum(sum((y4-mean(y4)).*(y4-mean(y4))))
RMSEE_gen4 = sqrt(RSS/size(y4,1))

%--------------------------------------------------------------------------
%Testing set calculations (3 models x 3 testsets)

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

%Model-2, Test set-4
xcste_24 = (xte4 - mean(x2))./std(x2) 
yhatte_24 = xcste_24*wstar2*c2'         
yhatte_24 = yhatte_24.*std(y2)+mean(y2)
reste_24 = yhatte_24 - yte4
RSS_24 = sum(sum(reste_24.*reste_24))
TSS_24 = sum(sum((yte4-mean(yte4)).*(yte4-mean(yte4))))
RMSEP_24 = sqrt(RSS_24/size(yte4,1))

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

yhatte_generalPLS = [yhatte_1;yhatte_2;yhatte_4];
yte = [yte1;yte2;yte4];
reste_generalPLS = yhatte_generalPLS - yte;
RSS = sum(sum(reste_generalPLS.*reste_generalPLS));
TSS = sum(sum((yte-mean(yte)).*(yte-mean(yte))));
RMSEP_generalPLS = sqrt(RSS/size(yte,1))

yhatte_grouped = [yhatte_11;yhatte_22;yhatte_44]         %changed for PLS grouped-2
reste_grouped = yhatte_grouped - yte
RSS = sum(sum(reste_grouped.*reste_grouped))
TSS = sum(sum((yte-mean(yte)).*(yte-mean(yte))))
RMSEP_grouped = sqrt(RSS/size(yte,1))

reste_grouped_200Da = reste_grouped(:,1)
yte_200Da = yte(:,1)
RSS = sum(sum(reste_grouped_200Da.*reste_grouped_200Da))
%TSS = sum(sum((yte_200Da-mean(yte_200Da)).*(yte_200Da-mean(yte_200Da))))
RMSEP_200Da = sqrt(RSS/size(yte_200Da,1))

reste_grouped_450Da = reste_grouped(:,2)
yte_450Da = yte(:,2)
RSS = sum(sum(reste_grouped_450Da.*reste_grouped_450Da))
%TSS = 
RMSEP_450Da = sqrt(RSS/size(yte_450Da,1))


%-------------------------------------------------------------------------
%calculation of overall metrics 
yconcat = [y1;y2;y4]                    % changed fpr Grouped PLS-2
yhatconcat = [yhattr1;yhattr2;yhattr4]              % changed fpr Grouped PLS-2
res = yconcat - yhatconcat
RSS = sum(sum(res.*res))
TSS = sum(sum((yconcat-mean(yconcat)).*(yconcat-mean(yconcat))))
RMSEE_groupedmodel = sqrt(RSS/size(yconcat,1))
R2_groupedmodel = 1-RSS/TSS

res200Da = res(:,1)
y200Da = yconcat(:,1)
RSS = sum(sum(res200Da.*res200Da))
TSS = sum(sum((y200Da-mean(y200Da)).*(y200Da-mean(y200Da))))
RMSEE_200Da = sqrt(RSS/size(y200Da,1))
R2_200Da = 1-RSS/TSS

res450Da = res(:,2)
y450Da = yconcat(:,2)
RSS = sum(sum(res450Da.*res450Da))
TSS = sum(sum((y450Da-mean(y450Da)).*(y450Da-mean(y450Da))))
RMSEE_450Da = sqrt(RSS/size(y450Da,1))
R2_450Da = 1-RSS/TSS

yhatconcat = [yhat1cv;yhat2cv;yhat4cv]      %changed for PLS grouped-2
res = yconcat - yhatconcat
RSS = sum(sum(res.*res))
TSS = sum(sum((yconcat-mean(yconcat)).*(yconcat-mean(yconcat))))
RMSEPcv_groupedmodel = sqrt(RSS/size(yconcat,1))
Q2_groupedmodel = 1-RSS/TSS

res200Da = res(:,1)
y200Da = yconcat(:,1)
RSS = sum(sum(res200Da.*res200Da))
TSS = sum(sum((y200Da-mean(y200Da)).*(y200Da-mean(y200Da))))
RMSEPcv_200Da = sqrt(RSS/size(y200Da,1))
Q2_200Da = 1-RSS/TSS
 
res450Da = res(:,2)
y450Da = yconcat(:,2)
RSS = sum(sum(res450Da.*res450Da))
TSS = sum(sum((y450Da-mean(y450Da)).*(y450Da-mean(y450Da))))
RMSEPcv_450Da = sqrt(RSS/size(y450Da,1))
Q2_450Da = 1-RSS/TSS

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

coeff4 = wstar4*c4';
A4temp = std(x4)'.*coeff4;
A4 = A4temp./std(y4);
B4temp = mean(x4)*coeff4;
B4 = (B4temp - mean(y4))./std(y4);
 