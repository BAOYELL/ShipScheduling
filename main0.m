%% ��ջ���
clc;clear
casenum=30;
% �����趨
Q=8;L=100;H=168;N=20;%qc length horizon number
popsize=100;        %������Ŀ
MAXGEN=200;         %����Ŵ�����
XOVR=0.7;       %������
MUTR=0.3;       %������
% ���Ԥ��
ctime=zeros(casenum,1);%computing time
fitvalue0=zeros(casenum,1);
chrom_record=zeros(casenum,60);
bestgens = zeros(casenum,MAXGEN);
%% ��������
% �������
case_id=zeros(1,casenum);
ii=1;
for i=3:5
    for j=1:10
        case_id(ii)=i*100+j;
        ii=ii+1;
    end
end
% ��ʷ����
pop_record=xlsread('C:\\Users\\ERIC\\Desktop\\��λ�Ż�ģ������\\1Compare\\GREEDYSEP\\GREEDYJO\\JoChrom.xls');
% ����
for I=1:casenum
    I
    %% ��������    
    STR=sprintf('C:\\Users\\ERIC\\Desktop\\��λ�Ż�ģ������\\0startup\\%d.csv',case_id(I));
    data=csvread(STR);
    a= data(:,1);
    lenv=data(:,2);
    w=data(:,4);
    cmin=2.^(data(:,3)-1);
    cmax=2.*data(:,3);
    %������
    gen=0;
    bestgen=0;
    %% 1.2��ʼ��
    % ���ɴ������ۼƻ�
    tic
    [Chrom,turnover]=startpop( popsize,H, Q, L, N, data ); 
    %% 1.2����Ŀ�꺯��ֵ
    %��ѵ��ȹ���ʱ�� �������ĵ��ȹ���
    [MinVal,mint]=min(turnover);%%%%%%%%%  
    MinCh=Chrom(mint,:);
    trace=zeros(2,MAXGEN);    
    %% ѭ��Ѱ��
    while gen<MAXGEN  
        gen
%         %������Ӧ��ֵ
%         FitnV=ranking(turnover);
%         %ѡ�����
%         SelCh=select('rws', Chrom, FitnV, GGAP);
        %�������
        SelCh=across(Chrom,XOVR);
        %�������
        SelCh=aberranceJm(Chrom,MUTR,cmin,cmax,L,lenv);
        %����Ŀ����Ӧ��ֵ
        [bestVal ,ObjVSel, bestchrom]=fitness(SelCh ,H ,a, w, lenv, N, Q, L,cmin ,cmax);
        %���²�������Ⱥ
        Chromall=[Chrom;SelCh];ObjAll=[turnover;ObjVSel];
        [Obj,Ind]=sort(ObjAll);
        Chrom=Chromall(Ind(1:popsize),:);turnover=Obj(1:popsize);
        % ��¼���ֵ
        if MinVal> Obj(1)
            MinVal=Obj(1);
            MinCh=Chrom(1,:);
            bestgen=gen;%���ֵĴ���
        end
        %������������
        gen=gen+1;
        trace(1,gen)=MinVal;
        trace(2,gen)=mean(turnover);
    end
    
    % ��ǰ���ֵ
    fitvalue0(I)=MinVal;             %ʱ��
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