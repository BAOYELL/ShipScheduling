function [ berthPlan1,QCPlan,Bstart,Qstart,Qstop,tStart,tEnd,lenv,w ] = SeperateSchedule( data,shippara )
%SEPERATESCHEDULE 此处显示有关此函数的摘要
%   此处显示详细说明

a= data(:,1);
lenv=data(:,2);
w=data(:,4);
cmin=2.^(data(:,3)-1);
cmax=2.*data(:,3);
N=shippara.N;Q=shippara.Q;L=shippara.L;H=shippara.H;

t=ceil(w./cmax);

berthPlan0=zeros(L,H);berthPlan1=zeros(L,H);
Bstart=zeros(1,N);
QCPlan=zeros(Q,H);
Qstart=zeros(1,N);
Qstop=zeros(1,N);
tStart=zeros(1,N);
tEnd=zeros(1,N);
%berthPlan
for i = 1:N
    berthtime= a(i);
    flag = 0;
    for j=berthtime:H
        possible1=berthPlan0(:,j:j+t(i)-1);
        for k = 1:L-lenv(i)+1
            if sum(sum(possible1(k:k+lenv(i)-1,:)))==0
               berthPlan0(k:k+lenv(i)-1,j:j+t(i)-1)=i;
               Bstart(i)=k;
               flag = 1;
               break
            end
        end
        if flag ==1
            a(i)=j;
            break
        end        
    end    
end
%QCPlan
for i = 1:N
    berthtime= a(i);
    for j=berthtime:H
        possibleB=berthPlan1(:,j:j+t(i)-1);
        possibleQC=QCPlan(:,j:j+t(i)-1);
        %左右作业船舶
        workingleft=possibleB(1:Bstart(i)-1,:);
        leftship=setdiff(unique(workingleft),0);
        workingright= possibleB(Bstart(i)+lenv(i):end,:);
        rightship=setdiff(unique(workingright),0);
        %最小岸桥
        qc1=0;
        for i1=1:length(leftship)
            try 
                [qc,~]=find(possibleQC==leftship(i1),1,'last');
                if qc>qc1
                    qc1=qc;
                end
            catch
            end
        end
        %最大岸桥
        qc2=Q+1;
        for j1=1:length(rightship)
            try
                [qc,~]=find(possibleQC==rightship(j1),1);
                if qc<qc2
                    qc2=qc;
                end
            catch
            end
        end
        %部署岸桥        
        if qc2-qc1-1>=cmin(i)     
            number=min(cmax(i),qc2-qc1-1);
            loadingtime=ceil(w(i)/number);
            possibleB1=berthPlan1(Bstart(i):Bstart(i)+lenv(i)-1,j:j+loadingtime-1);
            if  sum(sum(possibleB1))==0
                QCPlan(qc1+1:qc1+number,j:j+loadingtime-1)=i;
                Qstart(i)=qc1+1;
                Qstop(i)=qc1+number;
                berthPlan1(Bstart(i):Bstart(i)+lenv(i)-1,j:j+loadingtime-1)=i;
                tStart(i)=j;
                tEnd(i)=j+loadingtime-1;
                break
            end
        else
        end          
    end 
end

end

