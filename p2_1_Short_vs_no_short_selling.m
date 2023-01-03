clear;
clc;

% point 2.1

% in this script we compute the sample moments and, with them, we compute
% the EF with the GMV portfolio and the TAN portfolio. We compare these
% portfolios with the equally weighted portfolio. Then we redo this
% analysis adding one constrain: the weights of the portfolio have to be
% positive

%% MEAN AND COVARIANCE MATRIX OF THE RETURNS

% we want to compute the mean and the covariance matrix of monthly returns
% and then plot the mean and the standard deviation in bar charts

% we load the data and the text from the excel file
[data,text]=xlsread('Dati.xlsx');

% we store dates as string
DD1=datenum(text(7:size(text,1),1),'dd/mm/yyyy');
DD=datestr(DD1);

% we store column labels into a string array
lab1=text(4,2:size(text,2));
lab=cell(11,1);
for j=1:11
    lab{j,1}=char(lab1(j));
    lab{j,1}=lab{j,1}(1:(size(lab{j,1},2)-14));
end

% we exclude the dates when there is no price for some indexes
n=sum(isnan(data),2);
p=data(n==0,:);
d=DD(n==0,:);

% we take data and prices of the last 5 years
s=find(DD1==datenum('08-Dec-2017')); %s=find(DD1==737037);
p=p(s:end,:);
d=d(s:end,:);

% we compute the daily returns
r=((p(2:(size(p,1)),:)./p(1:(size(p,1)-1),:))-1)*100;

% we convert daily returns into monthly returns and redo plots and table for returns
pM=[];
dM=[];
% we find the first end of month
d1=d(1,:);
for j=2:size(p,1)
    if month(d1)==month(d(j,:))
    else
        d1=d(j-1,:);
        break;
    end
end

% Then we loop to find the end of each month and the corresponding price
for i=j:size(p,1)
    if month(d1)==month(d(i,:))
    else
        pM=[pM; p(i-1,:)];
        dM=[dM; d(i-1,:)];
        d1=d(i,:);
    end
end
% we compute the monthly returns and the corresponding dates
rM=((pM(2:(size(pM,1)),:)./pM(1:(size(pM,1)-1),:))-1)*100;
dM=dM((end-size(rM,1)+1):end,:);

% we give names for each index
lab={'UTILITIES','TECHNOLOGY','COMM. SERVICES','CONS. DIS.','CONS. STAPLES','ENERGY','FINANCIALS','HEALTH CARE','INDUSTRIES','MATERIALS','REAL ESTATE'};

% we compute and plot the mean returns
MM=mean(rM);
bar(MM(1,1:11));
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Mean returns');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% we compute and plot the volatilities
MV=cov(rM);
figure;
bar(sqrt(diag(MV(1:11,1:11))));
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Volatility');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

%% PORTFOLIO - DIFFERENT POSSIBILITIES

% we want to show the efficient frontier, where there are the optimal
% portfolios, and in particular highlight the Global Minimum Variance, 
% the Maximum Trade-off and the equally weighted portfolio

% we take the mean and the covariance matrix only for the assets
MMr=MM(:,1:11);
MVr=MV(1:11,1:11);

% Global Minimum Variance portfolio: weights, mean, stdev
wGMV=((MVr)\ones(size(MVr,1),1))/sum((MVr)\ones(size(MVr,1),1));
rGMV=sum(MMr*wGMV);
sGMV=sqrt((wGMV')*MVr*wGMV);
figure;
bar(1:11,wGMV);
% ylim([-0.2 0.8]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Global Minimum Variance portfolio');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% Maximum Trade-off portfolio: weights, mean, stdev
wTAN=((MVr)\MMr')/sum((MVr)\MMr');
rTAN=sum(MMr*wTAN);
sTAN=sqrt((wTAN')*MVr*wTAN);
figure;
bar(1:11,wTAN);
% ylim([-0.6 1]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Maximum trade-off portfolio');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% Equally weighted portfolio: weights, mean, stdev
wWE=1/11*ones(11,1);
rWE=sum(MMr*wWE);
sWE=sqrt((wWE')*MVr*wWE);
figure;
bar(1:11,wWE);
ylim([0 0.3]);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Equally weighted portfolio');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% we compute relevant scalars
A=(MMr/MVr)*(MMr');
B=(MMr/MVr)*ones(length(MMr),1);
C=(ones(1,length(MMr))/(MVr))*ones(length(MMr),1);
D=A*C-B*B;

% To compute the EF, we take nport number of points
nport=100;
% we fix rGMV, as the lowest return for the portfolio, and 5 times the rGMW
% as the highest return
rmin=rGMV;
rmax=rGMV*5;
rr=zeros(nport+1,1);
rs=zeros(nport+1,1);
rr(1)=rGMV;
rs(1)=sGMV;
rstep=(rmax-rmin)/nport;
for j=1:nport
    rr(j+1)=rr(j)+rstep;
    rs(j+1)=sqrt((C/D)*(rr(j+1)^2)-(2*B/D)*(rr(j+1))+A/D);
end

% we plot the EF
figure;
plot(rs,rr,'LineWidth',2);
% and add GMV, TAN and WE portfolios
hold on
grid on
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
xlabel('Volatility');
ylabel('Returns');
title('Unconstrained efficient frontier - GMV,TAN and WE portfolios');
legend('EF','GMV','TAN','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);
% If you want to see some admissible portfolio, but not optimal, you can
% uncomment the following line (we can see that they are on the right of
% the EF)
% scatter(sqrt(diag(MV)),MM','filled','k');

%% PORTFOLIO WITHOUT SHORT SELLING

% we create the efficient frontier with the constraint of positive weights
% for the portfolio, that is, we are requiring not to have short selling,
% and in the EF we find the GMV and the TAN portfolio

% we create an empty object
p1=Portfolio;

% we provide the names of the assets, the return and the covariance
p1=p1.setAssetList(lab);
p1=p1.setAssetMoments(MMr,MVr);
% we use default constraints to have positivity of the weights
p1=p1.setDefaultConstraints;

% we compute the Max-Sharp Portfolio
pwgtMS = estimateMaxSharpeRatio(p1);
[prskMS, pretMS] = estimatePortMoments(p1,pwgtMS);
% we compute the Global Minimum Variance Portfolio
pwgtGMV=p1.estimateFrontierLimits('Min');
[prskGMV, pretGMV] = estimatePortMoments(p1,pwgtGMV);

% we plot the weights of the Max-Sharp portfolio and the Global Minimum
% Variance portfolio
figure;
bar(1:11,pwgtMS);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Maximum Trade-off Portfolio without short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

figure;
bar(1:11,pwgtGMV);
set(gca,'Xtick',1:11,'XTickLabel',lab);
title('Global Minimum Variance Portfolio without short selling');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

% we plot the EF without any constrains and the EF with the constrain of no
% short selling, and in each of them we show the GMV and the TAN portfolio.
% we add also the EW portfolio
nport=100;
figure;
p1.plotFrontier(nport);
hold on
scatter(prskGMV,pretGMV,'filled','y');
scatter(prskMS,pretMS,'filled','k');
plot(rs,rr,'LineWidth',2);
hold on
xlim([2.5 10]);
scatter(sGMV,rGMV,'filled','r');
scatter(sTAN,rTAN,'filled','g');
scatter(sWE,rWE,'filled','b');
% xlabel('Volatility');
% ylabel('Returns');
title('Unconstrained EF vs EF without short selling - GMV,TAN and WE portfolios');
legend('EF - no short','GMV - no short', 'TAN - no short',...
       'EF - with short','GMV - with short',...
       'TAN - with short','WE','Location','east');
x0=300;
y0=150;
width=920;
height=540;
set(gcf,'position',[x0,y0,width,height]);

save final_project2.mat;