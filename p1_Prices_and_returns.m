clear;
clc;

% point 1

% In this script, we make an analysis of prices and returns of the indexes
% at daily and monthly frequence with some plots

%% PRICES AND RETURNS

% we load the data
[data,text]=xlsread('Dati.xlsx');

% we store the dates as string
D=datenum(text(7:size(text,1),1),'dd/mm/yyyy');
D=datestr(D);

% and store column labels into a string array
lab1=text(4,2:size(text,2)-1);
lab=cell(11,1);
for j=1:11
    lab{j,1}=char(lab1(j));
    lab{j,1}=lab{j,1}(1:(size(lab{j,1},2)-14));
end

% we check if in some dates indexes have no market and in that case we 
% exclude those dates
n=sum(isnan(data),2);
p=data(n==0,:);
d=D(n==0,:);

% we plot the prices of the 11 indixes (figure 3x4)
% we use a set of more syntetic labels
lab2={'UTILITIES','INFORMATION TECHNOLOGY','COMMUNICATION SERVICES','CONSUMER DISCRETIONARY','CONSUMER STAPLES','ENERGY','FINANCIALS','HEALTH CARE','INDUSTRIALS','MATERIALS','REAL ESTATE'};

%% DAILY PRICES

% we plot the daily prices

% PRICES OF INDEXES from 2002 to 2022
figure;
for j=1:11
    subplot(3,4,j);
    plot(datenum(d),p(:,j));
    datetick('x','mmm-yy');
    title(lab2{j});
    % ylim([0 3000]);
    xlim([datenum(d(1,:)) datenum(d(end,:))]);
    set(gca,'XTick',[datenum('01-Jan-2008') datenum('01-Jan-2020')]);
    set(gca,'XTickLabel',['Jan-08';'Jan-20'] );
end
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

%% DAILY RETURNS

% we find daily returns and plot them. Then we compute the table for the
% descriptive analysis

% DAILY RETURNS OF INDEXES from 2002 to 2022
r=((p(2:(size(p,1)),:)./p(1:(size(p,1)-1),:))-1)*100;

% we plot the daily returns
figure;
for j=1:11
    subplot(3,4,j);
    plot(datenum(d(2:size(d,1),:)),r(:,j));
    datetick('x','mmm-yy');
    title(lab2{j});
    ylim([-20 25]);
    xlim([datenum(d(1,:)) datenum(d(end,:))]);
    set(gca,'XTick',[datenum('01-Jan-2008') datenum('01-Jan-2020')]);
    set(gca,'XTickLabel',['Jan-08';'Jan-20'] );
end
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

% we compare some particular indexes to analyze periods with more
% fluctuations and variability

% REAL ESTATES AND ENERGY - plot of returns
figure;
i=1;
for j=6:5:11
    subplot(2,1,i);
    plot(datenum(d(2:size(d,1),:)),r(:,j));
    datetick('x','mmm-yy');
    title(lab2{j});
    ylim([-20 25]);
    xlim([datenum(d(1,:)) datenum(d(end,:))]);
    i=i+1;
end
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

% CONSUMER STAPLES AND HEALTH CARE - plot of returns
figure;
ii=1;
for j=5:3:8
    subplot(2,1,ii);
    plot(datenum(d(2:size(d,1),:)),r(:,j));
    datetick('x','mmm-yy');
    title(lab2{j});
    ylim([-20 25]);
    xlim([datenum(d(1,:)) datenum(d(end,:))]);
    ii=ii+1;
end
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

% we compute some interesting parameters of the time series of each index
% and analyze them in a table
Mean=mean(r(:,1:11))';
Median=median(r(:,1:11))';
StDev=sqrt(var(r(:,1:11)))';
Min=min(r(:,1:11))';
Max=max(r(:,1:11))';
Skew=skewness(r(:,1:11))';
Kurt=kurtosis(r(:,1:11))';
T=table(Mean,Median,StDev,Min,Max,Skew,Kurt,'RowNames',lab); %it wants as imout columns
format bank
T

%% MONTHLY RETURNS

% we find monthly returns and plot them. Then we compute the table for the
% descriptive analysis

pM=[];
dM=[];
% we find the first end of month
d1=d(1,:);
for j=2:size(p,1)
    if month(d1)==month(d(j,:))
    else
        pM=p(j-1,:);
        dM=d(j-1,:);
        break;
    end
end
d1=dM;

% we find the last day of each month and its corresponding price
for i=j:size(p,1)
    if month(d1)==month(d(i,:))
    else
        pM=[pM; p(i-1,:)];
        dM=[dM; d(i-1,:)];
        d1=d(i,:);
    end
end

% we compute the monthly returns

% MONTHLY RETURNS OF INDEXES from 2002 to 2022
rM=((pM(2:(size(pM,1)),:)./pM(1:(size(pM,1)-1),:))-1)*100;


% we plot the monthly returns
figure;
for j=1:11
    subplot(3,4,j);
    plot(datenum(dM(2:size(dM,1),:)),rM(:,j));
    datetick('x','mmm-yy');
    title(lab2{j});
    ylim([-40 40]);
    xlim([datenum(d(1,:)) datenum(d(end,:))]);
    set(gca,'XTick',[datenum('01-Jan-2008') datenum('01-Jan-2020')]);
    set(gca,'XTickLabel',['Jan-08';'Jan-20'] );
end
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

% we compute the parameters in a table for descriptive analysis
Mean=mean(rM(:,1:11))';
Median=median(rM(:,1:11))';
StDev=sqrt(var(rM(:,1:11)))';
Min=min(rM(:,1:11))';
Max=max(rM(:,1:11))';
Skew=skewness(rM(:,1:11))';
Kurt=kurtosis(rM(:,1:11))';
TM=table(Mean,Median,StDev,Min,Max,Skew,Kurt,'RowNames',lab);
TM


%% CORRELATION MATRIX

% we compute the correlation matrix, to see what are the most uncorrelated
% assets, and we can propose a portfolio with most of the capital put in
% these one

label={'UTI','TEC','C&S','DIS','STP','ERG','FIN','HEA','IND','MAT','REA'};
Corr=corr(rM(:,1:11));
% If you want to see only the lower triangular matrix, uncomment the
% following two lines
% isupper = logical(triu(ones(size(Corr)),1));
% Corr(isupper) = NaN;
figure;
h = heatmap(Corr,'MissingDataColor','w');
labels=label;
h.XDisplayLabels = labels;
h.YDisplayLabels = labels;
title('Correlation matrix')
x0=200;
y0=80;
width=1120;
height=640;
set(gcf,'position',[x0,y0,width,height]);

save final_project.mat