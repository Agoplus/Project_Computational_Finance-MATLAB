clear;
clc;

% point 3.2

load final_project3.mat;

% in this script we use the sample moments

% we build two portfolios with different constraints, besides the one with 
% the positivity of the weights (case 1): upper bound of the weights (case
% 2) and group constraints (case 3)

%% PORTFOLIO WITH NO SHORT SELLING

p1s=Portfolio;
p1s=p1s.setAssetList(lab);
p1s=p1s.setAssetMoments(MMr,MVr);

p1s=p1s.setDefaultConstraints;

pwgtMSs=estimateMaxSharpeRatio(p1s);
[prskMSs, pretMSs] = estimatePortMoments(p1s,pwgtMSs);
pwgtGMVs=p1s.estimateFrontierLimits('Min');
[prskGMVs, pretGMVs] = estimatePortMoments(p1s,pwgtGMVs);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVs);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with sample moments - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSs);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with sample moments - no short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1s.plotFrontier(nport);
hold on
scatter(prskGMVs,pretGMVs,'filled','y');
scatter(prskMSs,pretMSs,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF without short selling - GMV,TAN and WE portfolios with sample moments');
legend('EF - no short selling','GMV - no short selling', 'TAN - no short selling',...
       'EF','GMV','TAN','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIO WITH UPPER BOUND

p1su=Portfolio(p1s,'UpperBound',0.25);

pwgtMSsu=estimateMaxSharpeRatio(p1su);
[prskMSsu, pretMSsu] = estimatePortMoments(p1su,pwgtMSsu);
pwgtGMVsu=p1su.estimateFrontierLimits('Min');
[prskGMVsu, pretGMVsu] = estimatePortMoments(p1su,pwgtGMVsu);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVsu);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with sample moments - upper bound');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSsu);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with sample moments - upper bound');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1su.plotFrontier(nport);
hold on
scatter(prskGMVsu,pretGMVsu,'filled','y');
scatter(prskMSsu,pretMSsu,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF with upper bound - GMV,TAN and WE portfolios with sample moments');
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

p1sg=setGroups(p1s,GA,0.7,1);
p1sg=addGroups(p1sg,GB,0,0.3);
p1sg=addGroups(p1sg,GC,0,0);

pwgtMSsg=estimateMaxSharpeRatio(p1sg);
[prskMSsg, pretMSsg] = estimatePortMoments(p1sg,pwgtMSsg);
pwgtGMVsg=p1sg.estimateFrontierLimits('Min');
[prskGMVsg, pretGMVsg] = estimatePortMoments(p1sg,pwgtGMVsg);

% weights of the GMV portfolio
figure;
bar(1:11,pwgtGMVsg);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('GMV Portfolio with sample moments - group constrains');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% weights of the MS portfolio
figure;
bar(1:11,pwgtMSsg);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('MS Portfolio with sample moments - group constrains');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% EF with GMV, MS and WE portfolios w.r.t. the unconstrained EF
figure;
p1sg.plotFrontier(nport);
hold on
scatter(prskGMVsg,pretGMVsg,'filled','y');
scatter(prskMSsg,pretMSsg,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF with group constrains- GMV,TAN and WE portfolios with sample moments');
legend('EF - group constrains','GMV - group constrains', 'TAN - group constrains',...
       'EF','GMV','TAN','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

save sample.mat;
