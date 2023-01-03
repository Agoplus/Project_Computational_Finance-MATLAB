clear;
clc;

% point 2.4

% in this script we take a different 5-year-period to analyze. We compute
% mean returns, volatility, GMV, MS and WE portfolios and the unconstrained
% efficient frontier

%% MEAN AND COVARIANCE MATRIX OF THE RETURNS

[data,text]=xlsread('Dati.xlsx');

DD1=datenum(text(7:size(text,1),1),'dd/mm/yyyy');
DD=datestr(DD1);

lab1=text(4,2:size(text,2));
lab=cell(11,1);
for j=1:11
    lab{j,1}=char(lab1(j));
    lab{j,1}=lab{j,1}(1:(size(lab{j,1},2)-14));
end

n=sum(isnan(data),2);
p=data(n==0,:);
d=DD(n==0,:);

% we take data and prices of the 5-years-period 2006-2010
s=find(DD1==datenum('02-Jan-2006'));
sf=find(DD1==datenum('31-Dec-2010'));

p=p(s:sf,:);
d=d(s:sf,:);

% we compute the daily returns
r=((p(2:(size(p,1)),:)./p(1:(size(p,1)-1),:))-1)*100;

% we convert daily returns into monthly returns
pM=[];
dM=[];
d1=d(1,:);
for j=2:size(p,1)
    if month(d1)==month(d(j,:))
    else
        d1=d(j-1,:);
        break;
    end
end

for i=j:size(p,1)
    if month(d1)==month(d(i,:))
    else
        pM=[pM; p(i-1,:)];
        dM=[dM; d(i-1,:)];
        d1=d(i,:);
    end
end

% we compute the monthly returns and dates
rM=((pM(2:(size(pM,1)),:)./pM(1:(size(pM,1)-1),:))-1)*100;
dM=dM((end-size(rM,1)+1):end,:);

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
% the Maximal Trade-off and the equally weighted portfolio

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

% Maximum trade-off portfolio: weights, mean, stdev
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

% we compute the EF
nport=100;
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

save New_five.mat
