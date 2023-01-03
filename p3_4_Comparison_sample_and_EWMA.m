clear;
clc;

% point 3.4

load sample.mat;
load EWMA_moments.mat;

% in this script we compare the results found in the previous two script
% p3_2 and p3_3 - i.e. we compare the portfolios computed with sample
% moments and EWMA moments

%% COMPARISON MEAN RETURNS AND VOLATILITY WITH SAMPLE AND EWMA MOMENTS

lab={'UTI','TEC','C&S','DIS','STP','ERG','FIN','HEA','IND','MAT','REA'};

figure
bar(1:11,[MMr' EWMean(end,:)']);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('Mean return - sample vs EWMA')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

figure
bar(1:11,[sqrt(diag(MVr)) sqrt(EWVol(end,:)')]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('Volatility - sample vs EWMA')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);

%% COMPARISON PORTFOLIO WEIGHTS WITH SAMPLE AND EWTA MOMENTS

figure
% title('Comparison sample and EWMA moments');
subplot(3,2,1)
bar(1:11,[pwgtGMVs pwgtGMVewma]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('GMV weights with sample and EWMA moments - No short')
subplot(3,2,2)
bar(1:11,[pwgtMSs pwgtMSewma]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('MS weights with sample and EWMA moments - No short')
subplot(3,2,3)
bar(1:11,[pwgtGMVsu pwgtGMVewmau]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('GMV weights with sample and EWMA moments - Upper bound')
subplot(3,2,4)
bar(1:11,[pwgtMSsu pwgtMSewmau]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('MS weights with sample and EWMA moments - Upper bound')
subplot(3,2,5)
bar(1:11,[pwgtGMVsg pwgtGMVewmag]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('GMV weights with sample and EWMA moments - Group constraints')
subplot(3,2,6)
bar(1:11,[pwgtMSsg pwgtMSewmag]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
legend({'SAMPLE','EWMA'})
title('MS weights with sample and EWMA moments - Group constraints')
x0=50;
y0=50;
width=1400;
height=700;
set(gcf,'position',[x0,y0,width,height]);
