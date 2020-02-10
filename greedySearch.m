function [chori,turnover] = greedySearch(ships,data,Q,L,H)
%GREEDYSEARCH 此处显示有关此函数的摘要
%   此处显示详细说明
%berthPlan
data=data(ships,:);
a= data(:,1);
N=size(a,1);
loc=zeros(1,N);
qcs=zeros(1,N);
lenv=data(:,2);
w=data(:,4);
cmin=2.^(data(:,3)-1);
cmax=2.*data(:,3);
t=ceil(w./cmax);

%贪婪算法
berthPlan=zeros(L,H);QCPlan=zeros(Q,H);
Qstart=zeros(1,N);tStart=zeros(1,N);
for i = 1:N
    berthtime= a(i);
    flag = 0;
    for j=berthtime:H
        possible1=berthPlan(:,j:j+t(i)-1);
        for k = 1:L-lenv(i)+1
            if sum(sum(possible1(k:k+lenv(i)-1,:)))==0
                possibleB=berthPlan(:,j:j+t(i)-1);
                possibleQC=QCPlan(:,j:j+t(i)-1);
                %左右作业船舶
                workingleft=possibleB(1:k-1,:);
                leftship=setdiff(unique(workingleft),0);
                workingright= possibleB(k+lenv(i):end,:);
                rightship=setdiff(unique(workingright),0);
                %最小岸桥编号
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
                %最大岸桥编号
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
                    qcs(i)=min(cmax(i),qc2-qc1-1);
                    loadingtime=ceil(w(i)/qcs(i));
                    berthPlan(k:k+lenv(i)-1,j:j+loadingtime-1)=i;
                    loc(i)=k;
                    QCPlan(qc1+1:qc1+qcs(i),j:j+loadingtime-1)=ships(i);
                    Qstart(i)=qc1+1;
                    berthPlan(k:k+lenv(i)-1,j:j+loadingtime-1)=ships(i);
                    tStart(i)=j;
                    t(i)=loadingtime;
                    flag = 1;
                    break                    
                end                
            end
        end
        if flag ==1
            break
        end        
    end    
end

chori=zeros(1,3*N);
chori(1:N)=ships;
chori(1+N:N*2)=qcs;
chori(1+N*2:N*3)=loc;
turnover=sum(tStart)-sum(a)+sum(t);


end

