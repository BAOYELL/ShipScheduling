%% 清空环境
clc;clear
casenum=30;
% 参数设定
Q=8;L=100;H=168;N=20;%qc length horizon number
popsize=100;        %个体数目
MAXGEN=200;         %最大遗传代数
XOVR=0.7;       %交叉率
MUTR=0.3;       %变异率
% 结果预制
ctime=zeros(casenum,1);%computing time
fitvalue0=zeros(casenum,1);
chrom_record=zeros(casenum,60);
bestgens = zeros(casenum,MAXGEN);
%% 迭代案例
% 案例编号
case_id=zeros(1,casenum);
ii=1;
for i=3:5
    for j=1:10
        case_id(ii)=i*100+j;
        ii=ii+1;
    end
end
% 历史数据
pop_record=xlsread('C:\\Users\\ERIC\\Desktop\\泊位优化模型与版次\\1Compare\\GREEDYSEP\\GREEDYJO\\JoChrom.xls');
% 迭代
for I=1:casenum
    I
    %% 下载数据    
    STR=sprintf('C:\\Users\\ERIC\\Desktop\\泊位优化模型与版次\\0startup\\%d.csv',case_id(I));
    data=csvread(STR);
    a= data(:,1);
    lenv=data(:,2);
    w=data(:,4);
    cmin=2.^(data(:,3)-1);
    cmax=2.*data(:,3);
    %计数器
    gen=0;
    bestgen=0;
    %% 1.2初始化
    % 生成船舶到港计划
    tic
    [Chrom,turnover]=startpop( popsize,H, Q, L, N, data ); 
    %% 1.2计算目标函数值
    %最佳调度工序时间 最佳输出的调度工序
    [MinVal,mint]=min(turnover);%%%%%%%%%  
    MinCh=Chrom(mint,:);
    trace=zeros(2,MAXGEN);    
    %% 循环寻找
    while gen<MAXGEN  
        gen
%         %分配适应度值
%         FitnV=ranking(turnover);
%         %选择操作
%         SelCh=select('rws', Chrom, FitnV, GGAP);
        %交叉操作
        SelCh=across(Chrom,XOVR);
        %变异操作
        SelCh=aberranceJm(Chrom,MUTR,cmin,cmax,L,lenv);
        %计算目标适应度值
        [bestVal ,ObjVSel, bestchrom]=fitness(SelCh ,H ,a, w, lenv, N, Q, L,cmin ,cmax);
        %重新插入新种群
        Chromall=[Chrom;SelCh];ObjAll=[turnover;ObjVSel];
        [Obj,Ind]=sort(ObjAll);
        Chrom=Chromall(Ind(1:popsize),:);turnover=Obj(1:popsize);
        % 记录最佳值
        if MinVal> Obj(1)
            MinVal=Obj(1);
            MinCh=Chrom(1,:);
            bestgen=gen;%出现的代数
        end
        %代计数器增加
        gen=gen+1;
        trace(1,gen)=MinVal;
        trace(2,gen)=mean(turnover);
    end
    
    % 当前最佳值
    fitvalue0(I)=MinVal;             %时间
    ctime(I) = toc;
    bestgens(I,:) = trace(1,gen);
    chrom_record(I,:) = MinCh;
    %----------------------------%
end
STR0=sprintf('%s','GAJOS1'); 
xlswrite(STR0,fitvalue0,1)
xlswrite(STR0,chrom_record,2)
xlswrite(STR0,ctime,3)
xlswrite(STR0,bestgens,4)
for i=1:2
sound(sin(2*pi*25*(1:4000)/100));
pause(1);
end