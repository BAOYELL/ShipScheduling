function [ population,result ] = startpop( popsize,H, Q, L, N, data )
%STARTPOP 初始化种群
%   popsize 种群规模
%   N       船舶数量
%   L       泊位长度


% 代码2层，第一层船舶顺序，第二层机械
population=zeros(popsize,3*N );
result = zeros(popsize,1 );
for i=1:popsize
    ships=randperm(N);          %
    [chori,turnover] = greedySearch(ships,data,Q,L,H);
    population(i,:)=chori;        
    result(i,:)=turnover;
end
  

