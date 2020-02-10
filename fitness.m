function [bestVal ,turnover, bestchrom]=fitness(population ,H ,a, w, lengthv, N, Q, L,cmin ,cmax )

% ����˵����       ���ݻ���Ⱥ,�������Ⱥ��ÿ������ĵ��ȹ���ʱ�䣬
%                 ������Сʱ��ĵ��ȹ���͵��ȹ���ʱ��
% ���������
%       population     Ϊ������Ⱥ  
%       a         �����ʱ�� 
%       w         װж��ҵ��
%       N         ��������
%       Q         ��������
% �������:
%   bestVal       Ϊ��ѵ����ͺ�ʱ�� 
%   bestchrom     Ϊ�������ĵ��ȹ��� 
%    Fitness      ΪȺ��ÿ������ĵ��ȹ���ʱ��

%       PVal      Ϊ��ѵ��ȹ���ʱ�� 
%       P         Ϊ�������ĵ��ȹ��� 
%       ObjV      ΪȺ��ÿ������ĵ��ȹ���ʱ��
%       S         Ϊ�������ĵ��Ȼ���

%��ʼ��
popsize=size(population,1);
turnover=zeros(popsize,1);

for i=1:popsize  
    
    %ȡһ������
    chrom=population(i,:); 
    %���ݵ��ȹ��򣬼����Ŀ�꺯��ֵ
    try [ Qstart,tStart,t ] = decoding( chrom ,H ,a, w, lengthv, N, Q, L );
        turnover(i)=sum(tStart)-sum(a)+sum(t);
    catch
        turnover(i)=999;
    end
end 
 mint= find(turnover==min(turnover),1);%%%%%%%%%
%��ѵ��ȹ���ʱ�� �������ĵ��ȹ��� 
 bestVal=turnover(mint);
 bestchrom=population(mint,:);
 

 
 
 
 