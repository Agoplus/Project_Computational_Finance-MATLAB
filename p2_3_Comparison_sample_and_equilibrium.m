clear;
clc;

% point 2.3

load final_project3.mat;

% in this script, we first compare the mean returns and the volatility,
% then we compare the weights of GMV and MS portfolios with sample and 
% equilibrium moments - in the case of without constraints and with the 
% constraint of positivity of the weights

%% COMPARISON MEAN RETURNS AND VOLATILITY WITH SAMPLE AND EQUILIBRIUM MOMENTS

lab={'UTI','TEC','C&S','DIS','STP','ERG','FIN','HEA','IND','MAT','REA'};

figure
bar(1:11,[MMr' MMe']);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('Mean return - sample vs equilibrium')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

figure
bar(1:11,[sqrt(diag(MVr)) sqrt(diag(MVe))]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('Volatility - sample vs equilibrium')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

%% COMPARISON PORTFOLIO WEIGHTS WITH SAMPLE AND EQUILIBRIUM MOMENTS

figure
% title('Comparison sample and equilibrium moments');
subplot(2,2,1)
bar(1:11,[wGMV wGMVe]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('GMV weights with sample and equilibrium moments - Short')
subplot(2,2,2)
bar(1:11,[wTAN wTANe]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('MS weights with sample and equilibrium moments - Short')
subplot(2,2,3)
bar(1:11,[pwgtGMV pwgtGMVe]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('GMV weights with sample and equilibrium moments - No short')
subplot(2,2,4)
bar(1:11,[pwgtMS pwgtMSe]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EQUILIBRIUM'})
title('MS weights with sample and equilibrium moments - No short')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);
