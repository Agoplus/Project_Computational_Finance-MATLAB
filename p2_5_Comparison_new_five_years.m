clear;
clc;

% point 2.5

% in this script we consider two 5-years periods 2018-2022 and 2006-2010
% and we compare mean returns, volatility, GMV, MS and WE portfolios and 
% the unconstrained efficient frontier in these two periods

load New_five.mat;

MMr5=MMr;
MVr5=MVr;
wGMV5=wGMV;
wTAN5=wTAN;
rs5=rs;
rr5=rr;
sGMV5=sGMV;
rGMV5=rGMV;
sTAN5=sTAN;
rTAN5=rTAN;

load final_project2.mat;

%% COMPARISON MEAN RETURNS AND VOLATILITY IN THE TWO PERIODS

% mean returns
figure
bar(1:11,[MMr' MMr5']);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'2018-2022','2006-2010'})
title('Mean return - 2018-2022 vs 2006-2010')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% volatility
figure
bar(1:11,[sqrt(diag(MVr)) sqrt(diag(MVr5))]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'2018-2022','2006-2010'})
title('Volatility - 2018-2022 vs 2006-2010')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

%% COMPARISON PORTFOLIO WEIGHTS IN THE TWO PERIODS

% GMV portfolio weights
figure
bar(1:11,[wGMV wGMV5]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'2018-2022','2006-2010'})
title('GMV portfolio - 2018-2022 vs 2006-2010')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% MS portfolio weights
figure
bar(1:11,[wTAN wTAN5]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'2018-2022','2006-2010'})
title('MS portfolio - 2018-2022 vs 2006-2010')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

% Efficient Frontier
figure;
plot(rs,rr,'LineWidth',2);
hold on
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
hold on
plot(rs5,rr5,'LineWidth',2);
hold on
scatter(sGMV5,rGMV5,'filled','r');
scatter(sTAN5,rTAN5,'filled','g');
grid on
xlabel('Volatility');
ylabel('Returns');
title('Comparison EF between 2018-2022 and 2006-2010 - GMV,TAN and WE portfolios');
legend('EF 18-22','GMV 18-22','TAN 18-22','WE','EF 06-10','GMV 06-10',...
       'TAN 06-10','Location','east');
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);
