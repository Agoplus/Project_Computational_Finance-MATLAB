clear;
clc;

% point 3.1

load final_project.mat;

% we take the returns and the dates over 20 years, like in the file p1
rMEWMA=rM;
dMEWMA=dM;

% and then we load the following file
load final_project3.mat;

%% EWMA METHOD - COMPUTING MEAN RETURNS AND VOLATILITY

% we chose the smoothing factor lambda and w
lambda=0.95;
w=30;

% we pre-allocate for mean returns and covariance matrix
EWMean=zeros(size(rMEWMA,1)-w,size(rMEWMA,2)-1); 
EWVar=zeros(size(rMEWMA,1)-w,size(rMEWMA,2)-1,size(rMEWMA,2)-1);
    
% we do the initialization with the sample moments of the first rolling 
% sample
EWMean(1,:)=mean(rMEWMA(1:w,1:size(rMEWMA,2)-1));
EWVar(1,:,:)=cov(rMEWMA(1:w,1:size(rMEWMA,2)-1));
for j=(w+1):(size(rMEWMA,1)) % tolto il -1
    EWMean(j-w+1,:)=lambda*EWMean(j-w,:)+(1-lambda)*rMEWMA(j,1:size(rMEWMA,2)-1);
    EWVar(j-w+1,:,:)=lambda*squeeze(EWVar(j-w,:,:))+(1-lambda)*(rMEWMA(j,1:size(rMEWMA,2)-1)'*rMEWMA(j,1:size(rMEWMA,2)-1));
end

%% EWMA METHOD - PLOT OF THE RETURNS AND the VOLATILITY

% we plot the returns and the volatility to see their behaviour, in
% particular we see a peak in the volatility in the periods of high
% instability, since the EWMA method gives more importance to recent data.
% Similarly there is a fall in the plot of the returns in the period of 
% instability

% returns
dd1b=datetime(dMEWMA((w+1):end,:));
ts1b=timetable(EWMean,'RowTimes',dd1b);

figure
plot(dd1b,table2array(ts1b(:,1)));
datetick('x','mmm-yy');
xlim([min(dd1b) max(dd1b)]);
legend(lab,'Location','south');
title('Returns with EWMA method');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);
grid on

% volatility
EWVol=zeros(222,11);
for i=1:222
    for j=1:11
        EWVol(i,j)=EWVar(i,j,j);
    end
end

figure;
plot(dd1b,sqrt(EWVol));
datetick('x','mmm-yy');
xlim([min(dd1b) max(dd1b)]);
legend(lab,'Location','north');
title('Volatilities with EWMA method');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);
grid on

save EWMA.mat;