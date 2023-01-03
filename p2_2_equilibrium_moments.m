clear;
clc;

% point 2.2

load final_project2.mat;

% in this script we compute the equilibrium moments with the CAPM model 
% and, with them, we compute the EF with the GMV portfolio and the TAN 
% portfolio. We compare these portfolios with the equally weighted 
% portfolio. Then we redo this analysis adding one constrain: the weights 
% of the portfolio have to be positive

%% EQUILIBRIUM MOMENTS

% we take the asset returns of the last five years
r_asset=rM(:,1:11);

% and the market return of the last five years
r_market=rM(:,12);

% we estimate the CAPM and store relevant quantities

alpha=zeros(size(r_asset,2),1);                     % alpha
beta=zeros(size(r_asset,2),1);                      % beta
r2=zeros(size(r_asset,2),1);                        % r-squared
eqret=zeros(size(r_asset,2),1);                     % equilibrium return
resid=zeros(size(r_asset,1),size(r_asset,2));       % residuals

% we take the market equilibrium return, by computing the average yearly 
% return of the S&P500 index between 1965 and 2022

rmeq=7.87;

% we compute the market variance
vmeq=var(r_market);

% we compute the mean returns and the volatility with equilibrium moments
for i=1:size(r_asset,2)
    out=regstats(r_asset(:,i),r_market,'linear',{'beta','r','rsquare','tstat'});
    alpha(i,1)=out.beta(1);
    beta(i,1)=out.beta(2);
    r2(i,1)=out.rsquare;
    resid(:,i)=out.r;
    eqret(i,1)=out.beta(2)*(rmeq/12);
end

MMe=eqret';
MVe=beta*(beta')*vmeq+diag(diag(cov(resid)));

% we plot the mean returns and the volatilities
figure;
bar(MMe);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Mean returns - equilibrium moments');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

figure;
bar(sqrt(diag(MVe)));
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Volatility - equilibrium moments');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIOS AND EFFICIENT FRONTIER - UNCONSTRAINED

% Global Minimum Variance portfolio: weights, mean, stdev
wGMVe=((MVe)\ones(size(MVe,1),1))/sum((MVe)\ones(size(MVe,1),1));
rGMVe=sum(MMe*wGMVe);
sGMVe=sqrt((wGMVe')*MVe*wGMVe);
figure;
bar(1:11,wGMVe);
ylim([-0.2 0.8]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with equilibrium moments');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% Maximum trade-off portfolio: weights, mean, stdev
wTANe=((MVe)\MMe')/sum((MVe)\MMe');
rTANe=sum(MMe*wTANe);
sTANe=sqrt((wTANe')*MVe*wTANe);
figure;
bar(1:11,wTANe);
% ylim([-0.6 1]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with equilibrium moments');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% Equally weighted portfolio: weights, mean, stdev
wWEe=1/11*ones(11,1);
rWEe=sum(MMe*wWEe);
sWEe=sqrt((wWEe')*MVe*wWEe);
figure;
bar(1:11,wWEe);
ylim([0 0.3]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Equally weighted portfolio with equilibrium moments');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% we compute relevant scalars
A=(MMe/MVe)*(MMe');
B=(MMe/MVe)*ones(length(MMe),1);
C=(ones(1,length(MMe))/(MVe))*ones(length(MMe),1);
D=A*C-B*B;

% To compute the EF, we take nport number of points
nport=100;
% we fix rGMV, as the lowest return for the portfolio, and 5 times the rGMW
% as the highest return
rmine=rGMVe;
rmaxe=rGMVe*5;
rre=zeros(nport+1,1);
rse=zeros(nport+1,1);
rre(1)=rGMVe;
rse(1)=sGMVe;
rstepe=(rmaxe-rmine)/nport;
for j=1:nport
    rre(j+1)=rre(j)+rstepe;
    rse(j+1)=sqrt((C/D)*(rre(j+1)^2)-(2*B/D)*(rre(j+1))+A/D);
end

% we plot the EF
figure;
plot(rse,rre,'LineWidth',2);
% and add GMV, TAN and WE portfolios
hold on
grid on
scatter(sGMVe,rGMVe,'filled','r');
scatter(sTANe,rTANe,'filled','g');
scatter(sWEe,rWEe,'filled','b');
xlabel('Volatility');
ylabel('Returns');
title('Unconstrained EF with equilibrium moments - GMV,TAN and WE portfolios');
legend('EF','GMV','TAN','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIOS AND EFFICIENT FRONTIER - UNCONSTRAINED

% we impose the positivity of the weights

p1e=Portfolio;

% we provide names, the asset returns and covariance
p1e=p1e.setAssetList(lab);
p1e=p1e.setAssetMoments(MMe,MVe);

% we set default constraints, i.e. positivity of the weights
p1e=p1e.setDefaultConstraints;

% we compute the Max Sharpe
pwgtMSe = estimateMaxSharpeRatio(p1e);
[prskMSe, pretMSe] = estimatePortMoments(p1e,pwgtMSe);
% we compute the Minimum Variance Portfolio
pwgtGMVe=p1e.estimateFrontierLimits('Min');
[prskGMVe, pretGMVe] = estimatePortMoments(p1e,pwgtGMVe);

figure;
bar(1:11,pwgtGMVe);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with equilibrium moments - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

figure;
bar(1:11,pwgtMSe);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with equilibrium moments - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% we plot the efficient frontier
nport=100;
figure;
p1e.plotFrontier(nport);
hold on
scatter(prskGMVe,pretGMVe,'filled','y');
scatter(prskMSe,pretMSe,'filled','k');
plot(rse,rre,'LineWidth',2);
hold on
% xlim([2.5 10]);
scatter(sGMVe,rGMVe,'filled','r');
scatter(sTANe,rTANe,'filled','g');
scatter(sWEe,rWEe,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF without short selling - GMV,TAN and WE portfolios with equilibrium moments');
legend('EF - no short','GMV - no short', 'TAN - no short',...
       'EF - with short','GMV - with short',...
       'TAN - with short','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

save final_project3.mat;