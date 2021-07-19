% leave-one-out cross validation function
function [RMSEE,yhattr,R2,yhat,Q2,c,wstar] = crossvalfunc(x,y,A)

n = 1;% n is the number of observations left out per iteration of training, n=1 means N-fold CV 
[N,K] = size(x); % number of observations & variables
V = size(y,2); % number of output variables 

%mean and standard deviations
xmean = mean(x)
xstd = std(x)
ymean = mean(y)
ystd = std(y)

%initializing matrices
xtemp = zeros(N-1,K);
ytemp = zeros(N-1,V);
yhat = zeros(N,V);
yhatr = zeros(N,V);
res = zeros(N,V);
%A=2; 
Q2 = zeros(1,A);

for a=1:A
    for i=1:N
        if i==1
            xtemp = x(2:end,:);
            ytemp = y(2:end,:);
        elseif i==ceil(N/n)
            xtemp = x(1:N-1,:);
            ytemp = y(1:N-1,:);
        else 
            xtemp(1:i-1,:) = x(1:i-1,:);
            xtemp(i:N-1,:) = x(i+1:N,:);
            ytemp(1:i-1,:) = y(1:i-1,:);
            ytemp(i:N-1,:) = y(i+1:N,:);
        end 

        xtest = x(i,:)
        ytest = y(i,:)

        % centering and scaling data
        xtemp = (xtemp - xmean)./xstd;
        ytemp = (ytemp - ymean)./ystd;
        xtest = (xtest - xmean)./xstd

        [t, wstar, c, p, w, u, R2] = nipalspls(xtemp,ytemp,a);   %temp model
        yhat(i,:) = xtest*wstar*c';
        yhat(i,:) = yhat(i,:).*ystd + ymean; 
        res(i,:) = ytest - yhat(i,:);
    end
    Q2(a) = 1-(sum(sum(res.*res)))/(sum(sum((y-mean(y)).*(y-mean(y)))));
end

%final model
xcs = (x - xmean)./xstd;
ycs = (y - ymean)./ystd;
[t, wstar, c, p, w, u, R2] = nipalspls(xcs,ycs,A);
yhattr = xcs*wstar*c'
yhattr = yhattr.*ystd + ymean;
res = y - yhattr;
RSS = sum(sum(res.*res))
TSS = sum(sum((y-ymean).*(y-ymean)))
RMSEE = sqrt(RSS/size(x,1))
% R2 = 1-(sum(sum(res.*res)))/(sum(sum((y-mean(y)).*(y-mean(y)))))
end