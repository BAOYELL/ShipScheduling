function NewChrom=across(Chrom,XOVR)

% Chrom=[1 3 2 3 1 2 1 3 2; 
%     1 1 2 3 3 1 2 3 2;
%     1 3 2 3 2 2 1 3 1;
%     1 3 3 3 1 2 1 2 2;
% ]; 
%   XOVR=0.7;

[NIND,WNumber]=size(Chrom);
WNumber=WNumber/3;
NewChrom=Chrom;%��ʼ������Ⱥ

% [PNumber MNumber]=size(Jm);
% Number=zeros(1,PNumber);
% for i=1:PNumber
%   Number(i)=1;
% end

%���ѡ�񽻲����(ϴ�ƽ���)
SelNum=randperm(NIND);   

Num=floor(NIND/2);%������������
for i=1:2:Num
    if XOVR>rand %%%%%%%%%%%%%%%
        %����λ��        
        pos=randperm(WNumber,2);
        smaller=min(pos);
        bigger=max(pos);

        %ȡ������ĸ���
        S1=Chrom(SelNum(i),:);
        S2=Chrom(SelNum(i+1),:); 
        S11=S2;S22=S1; %��ʼ���µĸ���     
        %�¸����м�Ƭ�ϵ�COPY    
        S11(smaller:bigger)=S1(smaller:bigger);
        S11(WNumber+smaller:WNumber+bigger)=S1(WNumber+smaller:WNumber+bigger);  
        S11(WNumber*2+smaller:WNumber*2+bigger)=S1(WNumber*2+smaller:WNumber*2+bigger);
        S22(smaller:bigger)=S2(smaller:bigger);
        S22(WNumber+smaller:WNumber+bigger)=S2(WNumber+smaller:WNumber+bigger);        
        S22(WNumber*2+smaller:WNumber*2+bigger)=S2(WNumber*2+smaller:WNumber*2+bigger);       
        %�Ƚ�S11���S1,S22���S2�����ȱʧ�Ļ���
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
          if S3(j)~=0 %����Ļ���          
            Pos1=j;        
            Pos2=find(S4,1);%����ȱʧ�Ļ���
            S11(Pos1)=S4(Pos2);%��ȱʧ�Ļ����޲�����Ļ���
            S11(WNumber+Pos1)=S1(WNumber+Pos2);%s4��s1��ǰһ����
            S11(WNumber*2+Pos1)=S1(WNumber*2+Pos2);%s4��s1��ǰһ����
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
        %�����µ���Ⱥ
        NewChrom(SelNum(i),:)=S11; %% ������buffer
        NewChrom(SelNum(i+1),:)=S22;
    end
 end