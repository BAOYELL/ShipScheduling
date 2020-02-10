function [bestVal ,turnover, bestchrom]=fitness(population ,H ,a, w, lengthv, N, Q, L,cmin ,cmax )

% 功能说明：       根据基因群,计算出个群中每个个体的调度工序时间，
%                 保存最小时间的调度工序和调度工序时间
% 输入参数：
%       population     为基因种群  
%       a         到达的时间 
%       w         装卸作业量
%       N         船舶数量
%       Q         岸桥数量
% 输出参数:
%   bestVal       为最佳调度滞后时间 
%   bestchrom     为最佳输出的调度工序 
%    Fitness      为群中每个个体的调度工序时间

%       PVal      为最佳调度工序时间 
%       P         为最佳输出的调度工序 
%       ObjV      为群中每个个体的调度工序时间
%       S         为最佳输出的调度基因

%初始化
popsize=size(population,1);
turnover=zeros(popsize,1);

for i=1:popsize  
    
    %取一个个体
    chrom=population(i,:); 
    %根据调度工序，计算出目标函数值
    try [ Qstart,tStart,t ] = decoding( chrom ,H ,a, w, lengthv, N, Q, L );
        turnover(i)=sum(tStart)-sum(a)+sum(t);
    catch
        turnover(i)=999;
    end
end 
 mint= find(turnover==min(turnover),1);%%%%%%%%%
%最佳调度工序时间 最佳输出的调度工序 
 bestVal=turnover(mint);
 bestchrom=population(mint,:);
 

 
 
 
 