clear;
clc;

% point 3.3

load EWMA.mat;

% in this script we use the EWMA moments

% we build two portfolios with different constraints, besides the one with 
% the positivity of the weights (case 1): upper bound of the weights (case
% 2) and group constraints (case 3)

%% PORTFOLIO WITH NO SHORT SELLING


p1ewma=Portfolio;
p1ewma=p1ewma.setAssetList(lab);

% we take the covariance matrix
var=zeros(11,11);
for i=1:11
    for j=1:11
        var(i,j)=EWVar(end,i,j);
    end
end

p1ewma=p1ewma.setAssetMoments(EWMean(end,:),var);

p1ewma=p1ewma.setDefaultConstraints;

pwgtMSewma=estimateMaxSharpeRatio(p1ewma);
[prskMSewma, pretMSewma] = estimatePortMoments(p1ewma,pwgtMSewma);
pwgtGMVewma=p1ewma.estimateFrontierLimits('Min');
[prskGMVewma, pretGMVewma] = estimatePortMoments(p1ewma,pwgtGMVewma);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVewma);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with EWMA - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSewma);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with EWMA - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1ewma.plotFrontier(nport);
hold on
scatter(prskGMVewma,pretGMVewma,'filled','y');
scatter(prskMSewma,pretMSewma,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF without short selling - GMV,TAN and WE portfolios with EWMA');
legend('EF - no short selling','GMV - no short selling', 'TAN - no short selling',...
       'EF','GMV','TAN','WE','Location','northeast');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIO WITH UPPER BOUND

p1ewmau=Portfolio(p1ewma,'UpperBound',0.25);

pwgtMSewmau=estimateMaxSharpeRatio(p1ewmau);
[prskMSewmau, pretMSewmau] = estimatePortMoments(p1ewmau,pwgtMSewmau);
pwgtGMVewmau=p1ewmau.estimateFrontierLimits('Min');
[prskGMVewmau, pretGMVewmau] = estimatePortMoments(p1ewmau,pwgtGMVewmau);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVewmau);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with EWMA - upper bound');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSewmau);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with EWMA - upper bound');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1ewmau.plotFrontier(nport);
hold on
scatter(prskGMVewmau,pretGMVewmau,'filled','y');
scatter(prskMSewmau,pretMSewmau,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF with upper bound - GMV,TAN and WE portfolios with EWMA');
legend('EF - upper bound','GMV - upper bound', 'TAN - upper bound',...
       'EF','GMV','TAN','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIO WITH GROUP CONSTRAINTS

GA=[0 0 1 0 0 1 0 0 0 0 1];     % Most uncorrelated assets between each other - C&S, ERG, REA
GB=[1 1 0 1 1 0 0 1 0 0 0];     % Others
GC=[0 0 0 0 0 0 1 0 1 1 0];     % Most correlated assets between each other - MAT, IND, FIN

p1ewmag=setGroups(p1ewma,GA,0.8,0.8);
p1ewmag=addGroups(p1ewmag,GB,0.2,0.2);
p1ewmag=addGroups(p1ewmag,GC,0,0);

pwgtMSewmag=estimateMaxSharpeRatio(p1ewmag);
[prskMSewmag, pretMSewmag] = estimatePortMoments(p1ewmag,pwgtMSewmag);
pwgtGMVewmag=p1ewmag.estimateFrontierLimits('Min');
[prskGMVewmag, pretGMVewmag] = estimatePortMoments(p1ewmag,pwgtGMVewmag);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVewmag);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with EWMA - group constraints');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSewmag);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with EWMA - group constraints');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1ewmag.plotFrontier(nport);
hold on
scatter(prskGMVewmag,pretGMVewmag,'filled','y');
scatter(prskMSewmag,pretMSewmag,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF with group constraints- GMV,TAN and WE portfolios with EWMA');
legend('EF - group constrains','GMV - group constrains', 'TAN - group constrains',...
       'EF','GMV','TAN','WE','Location','northwest')
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

save EWMA_moments.mat;
