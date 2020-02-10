function NewChrom=across(Chrom,XOVR)

% Chrom=[1 3 2 3 1 2 1 3 2; 
%     1 1 2 3 3 1 2 3 2;
%     1 3 2 3 2 2 1 3 1;
%     1 3 3 3 1 2 1 2 2;
% ]; 
%   XOVR=0.7;

[NIND,WNumber]=size(Chrom);
WNumber=WNumber/3;
NewChrom=Chrom;%初始化新种群

% [PNumber MNumber]=size(Jm);
% Number=zeros(1,PNumber);
% for i=1:PNumber
%   Number(i)=1;
% end

%随机选择交叉个体(洗牌交叉)
SelNum=randperm(NIND);   

Num=floor(NIND/2);%交叉个体配对数
for i=1:2:Num
    if XOVR>rand %%%%%%%%%%%%%%%
        %交叉位置        
        pos=randperm(WNumber,2);
        smaller=min(pos);
        bigger=max(pos);

        %取两交叉的个体
        S1=Chrom(SelNum(i),:);
        S2=Chrom(SelNum(i+1),:); 
        S11=S2;S22=S1; %初始化新的个体     
        %新个体中间片断的COPY    
        S11(smaller:bigger)=S1(smaller:bigger);
        S11(WNumber+smaller:WNumber+bigger)=S1(WNumber+smaller:WNumber+bigger);  
        S11(WNumber*2+smaller:WNumber*2+bigger)=S1(WNumber*2+smaller:WNumber*2+bigger);
        S22(smaller:bigger)=S2(smaller:bigger);
        S22(WNumber+smaller:WNumber+bigger)=S2(WNumber+smaller:WNumber+bigger);        
        S22(WNumber*2+smaller:WNumber*2+bigger)=S2(WNumber*2+smaller:WNumber*2+bigger);       
        %比较S11相对S1,S22相对S2多余和缺失的基因
        S3=S11(1:WNumber);S4=S1(1:WNumber);
        S5=S22(1:WNumber);S6=S2(1:WNumber);
        for j=1:WNumber         
           Pos1=find(S4==S3(j),1);
           Pos2=find(S6==S5(j),1);
           if Pos1>0
               S3(j)=0;
               S4(Pos1)=0;
           end                         
           if Pos2>0
               S5(j)=0;
               S6(Pos2)=0;
           end
        end
        for j=1:WNumber          
          if S3(j)~=0 %多余的基因          
            Pos1=j;        
            Pos2=find(S4,1);%查找缺失的基因
            S11(Pos1)=S4(Pos2);%用缺失的基因修补多余的基因
            S11(WNumber+Pos1)=S1(WNumber+Pos2);%s4是s1的前一部分
            S11(WNumber*2+Pos1)=S1(WNumber*2+Pos2);%s4是s1的前一部分
            S4(Pos2)=0;       
          end 
          if S5(j)~=0              
            Pos1=j; 
            Pos2=find(S6,1);           
            S22(Pos1)=S6(Pos2);
            S22(WNumber+Pos1)=S2(WNumber+Pos2);
            S22(WNumber*2+Pos1)=S2(WNumber*2+Pos2);
            S6(Pos2)=0;          
          end  
        end  
        %生成新的种群
        NewChrom(SelNum(i),:)=S11; %% 不考虑buffer
        NewChrom(SelNum(i+1),:)=S22;
    end
 end