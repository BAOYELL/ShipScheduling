function [ population,result ] = startpop( popsize,H, Q, L, N, data )
%STARTPOP ��ʼ����Ⱥ
%   popsize ��Ⱥ��ģ
%   N       ��������
%   L       ��λ����


% ����2�㣬��һ�㴬��˳�򣬵ڶ����е
population=zeros(popsize,3*N );
result = zeros(popsize,1 );
for i=1:popsize
    ships=randperm(N);          %
    [chori,turnover] = greedySearch(ships,data,Q,L,H);
    population(i,:)=chori;        
    result(i,:)=turnover;
end
  

