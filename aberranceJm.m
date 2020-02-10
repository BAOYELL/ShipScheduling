function ChromNew=aberranceJm(Chrom,MUTR,cmin,cmax,L,lenv)

%初始化
[NIND,WNumber]=size(Chrom);
WNumber=WNumber/3;
ChromNew=Chrom;

for i=1:NIND                   
    if MUTR>rand  %%%%%%%%%%%%%%%
        %取一个个体
        S=Chrom(i,:);        
        %交换位置
        pos=randperm(WNumber);
        smaller=min(pos(1:2));
        bigger=max(pos(1:2));
        order=linspace(smaller,bigger,bigger-smaller+1);        
        
        %船舶顺序交换
        S(smaller:bigger)=S(order(randperm(length(order))));
%         temp=S(Pos1);
%         S(Pos1)=S(Pos2);
%         S(Pos2)=temp;
        ship=S(1:WNumber);
        %岸桥和buffer调整
        for j=smaller:bigger 
            id=ship(j);
            S(j+WNumber)=randi([cmin(id),cmax(id)],1,1);
            S(j+2*WNumber)=randi([1,L-lenv(id)+1],1,1);
        end
        %数据放入新群
        ChromNew(i,:)=S;        
    end     
  

end

