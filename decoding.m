function [ Qstart,tStart,t ] = decoding( Chrom ,H ,a, w, lenv, N, Q, L  )
%   此处显示有关此函数的摘要 
%   此处显示详细说明
ships=Chrom(1:N);
qcs=Chrom(N+1:2*N);
loc=Chrom(2*N+1:3*N);
w=w(ships);a=a(ships);lenv=lenv(ships);
t=ceil(w./qcs');

%berthPlan
berthPlan=zeros(L,H);QCPlan=zeros(Q,H);
Qstart=zeros(1,N);tStart=zeros(1,N);
for i = 1:N
    berthtime= a(i);
    for j=berthtime:H
        possible1=berthPlan(:,j:j+t(i)-1);
        k=loc(i);
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
            if qc2-qc1-1>=qcs(i)
                possibleB1=berthPlan(k:k+lenv(i)-1,j:j+t(i)-1);
                if  sum(sum(possibleB1))==0
                    berthPlan(k:k+lenv(i)-1,j:j+t(i)-1)=ships(i);
                    QCPlan(qc1+1:qc1+qcs(i),j:j+t(i)-1)=ships(i);
                    Qstart(i)=qc1+1;
                    berthPlan(k:k+lenv(i)-1,j:j+t(i)-1)=ships(i);
                    tStart(i)=j;
                    break
                end
            end
        end
    end
end


end

