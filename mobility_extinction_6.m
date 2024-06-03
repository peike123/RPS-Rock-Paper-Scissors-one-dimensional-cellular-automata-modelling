function mobility_extinction_6
global p q y  L T
p = 0.001;  % predation rate
q = 1;  % reproduction rate
yy = [0.0001 0.001 0.01 0.1 1 5 10];  % mobility rate

L = 500;
T = 100000;
 
N1=zeros(1,T+1);
N2=zeros(1,T+1);
N3=zeros(1,T+1);

G = 100; % Number of simulations ģ�����
a = zeros(1,length(yy)); % Three species coexist �����ֹ���
b = zeros(1,length(yy)); % Two species extinct, one species surviving �����������һ���ִ��
E = zeros(1,length(yy)); % extinction probability �������
    
for i = 1:length(yy)
    for j = 1:G
        y = yy(1,i);
        B = liudonghanshu();       
        
        N1=sum(B(1,:)==1); % Number of species in the final moment ����ʱ����������
        N2=sum(B(1,:)==2);
        N3=sum(B(1,:)==3); 
        
        p1=N1/L;  % Species density at the final moment ����ʱ�������ܶ�
        p2=N2/L;
        p3=N3/L;       
        
        if p1==1 || p2==1 || p3==1
            b(1,i) = b(1,i)+1;
        else
            a(1,i) = a(1,i)+1;
        end
    end 
    
end
E = b/G;

figure(1)
x = [1:length(yy)];
plot(x,E,'k-*','LineWidth',2);
ylim([0 1]);
set(gca,'Xtick',x);
set(gca,'xticklabel',{'0.0001','0.001','0.01','0.1','1','10','100'});
ylabel({'Extinction probability, P_{ext}'},'FontWeight','bold','FontSize',14);  %Y�����Ƽ�����ʹ�С
xlabel({'Mobility, y'},'FontWeight','bold','FontSize',14);  %X�����Ƽ�����ʹ�С 
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',1.5);  %�����������ʹ�С
 for i=1:length(yy)
     text(x(i),E(i),[num2str(E(i))],'FontWeight','bold','FontSize',14);
 end
end


function spacetime = liudonghanshu(~)
%% ��ʼ��

global p q y L T

p_total = 0.75;    % total density
p_R = p_total/3;    
p_S = p_total/3;
p_P = p_total/3;
N_R = p_R*L;        % Number of each species
N_S = p_S*L;
N_P = p_P*L;

A = randperm(L);   % random distribution     
A(find(A<=N_R)) = 1;       % 1 denotes species R (rock)      
A(find(N_R+1<=A & A<=N_R+N_S)) = 2;        % 2 denotes species S (scissors)
A(find(N_R+N_S+1<=A & A<=N_R+N_S+N_P)) = 3;  % 3 denotes species P (paper)   1 eats 2, 2 eats 3, 3 eats 1.
A(find(A>N_R+N_S+N_P+1)) = 0;        % 0 indicates a space

spacetime = zeros(T+1,L);     %��¼
spacetime(T+1,:) = A;

alpha = p./(p+q+y); % predation probability
beta = q./(p+q+y); % reproduction probability
omega = y./(p+q+y); % mobility probability

%% ѭ��
for t=0:1:T-1
   for i=1:1:L
       if i<=L-1
           if A(1,i)==1
               if A(1,i+1)==0 
                   a=randsrc(1,1,[1 11 0;beta omega 1-beta-omega]);     %x0 ��ֳ������������ 
                   if a==1
                       A(1,i+1)=1;
                   elseif a==11
                       A(1,i:i+1)=[0 1];
                   else 
                       A(1,i+1)=0;
                   end
               elseif A(1,i+1)==1
                   A(1,i+1)=1;
               elseif A(1,i+1)==2     
                   a=randsrc(1,1,[0 1 2;alpha omega 1-alpha-omega]); %xy ��ʳ������������
                   if a==1   %����
                       A(1,i:i+1)=[2 1];
                   else
                       A(1,i+1)=a;  
                   end
               else  %A(1,i+1)==3
                   a=randsrc(1,1,[1 3;omega 1-omega]); %xy ����������
                   if a==1   %����
                       A(1,i:i+1)=[3 1];
                   else
                       A(1,i+1)=a;
                   end         
               end
           elseif A(1,i)==2
               if A(1,i+1)==0 
                   a=randsrc(1,1,[2 22 0;beta omega 1-beta-omega]);     %20 ��ֳ������������ 
                   if a==2
                       A(1,i+1)=2;
                   elseif a==22
                       A(1,i:i+1)=[0 2];
                   else 
                       A(1,i+1)=0;
                   end
               elseif A(1,i+1)==1
                   a=randsrc(1,1,[2 1;omega 1-omega]); %21 ����������
                   if a==2   %����
                       A(1,i:i+1)=[1 2];
                   else
                       A(1,i+1)=a;
                   end  
               elseif A(1,i+1)==2     
                   A(1,i+1)=2;
               else %A(1,i+1)==3
                   a=randsrc(1,1,[0 2 3;alpha omega 1-alpha-omega]);  %xy ��ʳ������������
                   if a==2 %����
                       A(1,i:i+1)=[3 2];
                   else 
                       A(1,i+1)=a;
                   end         
               end
           elseif A(1,i)==3
               if A(1,i+1)==0 
                   a=randsrc(1,1,[3 33 0;beta omega 1-beta-omega]);     %30 ��ֳ������������ 
                   if a==3
                       A(1,i+1)=3;
                   elseif a==33
                       A(1,i:i+1)=[0 3];
                   else 
                       A(1,i+1)=0;
                   end
               elseif A(1,i+1)==1
                   a=randsrc(1,1,[0 3 1;alpha omega 1-alpha-omega]); %31 ��ʳ������������
                   if a==3   %����
                       A(1,i:i+1)=[1 3];
                   else
                       A(1,i+1)=a;
                   end  
               elseif A(1,i+1)==2     
                   a=randsrc(1,1,[3 2;omega 1-omega]); %32 ����������
                   if a==3   %����
                       A(1,i:i+1)=[2 3];
                   else
                       A(1,i+1)=a;
                   end
               else %A(1,i+1)==3
                   A(1,i+1)=3;        
               end    
           else %A(1,i)==0
               A(1,i)=0;
           end
           
   
       else  %i=Lʱ
           if A(1,i)==1
               if A(1,1)==0 
                   a=randsrc(1,1,[1 11 0;beta omega 1-beta-omega]);     %x0 ��ֳ������������ 
                   if a==1
                       A(1,1)=1;
                   elseif a==11
                       A(1,i)=0;   
                       A(1,1)=1;
                   else 
                       A(1,1)=0;
                   end
               elseif A(1,1)==1
                   A(1,1)=1;
               elseif A(1,1)==2     
                   a=randsrc(1,1,[0 1 2;alpha omega 1-alpha-omega]); %xy ��ʳ������������
                   if a==1   %����
                       A(1,i)=2;   
                       A(1,1)=1;
                   else
                       A(1,1)=a;  
                   end
               else  %A(1,1)==3
                   a=randsrc(1,1,[1 3;omega 1-omega]); %xy ����������
                   if a==1   %����
                       A(1,i)=3;   
                       A(1,1)=1;
                   else
                       A(1,1)=a;
                   end         
               end
           elseif A(1,i)==2
               if A(1,1)==0 
                   a=randsrc(1,1,[2 22 0;beta omega 1-beta-omega]);     %20 ��ֳ������������ 
                   if a==2
                       A(1,1)=2;
                   elseif a==22
                       A(1,i)=0;   
                       A(1,1)=2;
                   else 
                       A(1,1)=0;
                   end
               elseif A(1,1)==1
                   a=randsrc(1,1,[2 1;omega 1-omega]); %21 ����������
                   if a==2   %����
                       A(1,i)=1;   
                       A(1,1)=2;
                   else
                       A(1,1)=a;
                   end  
               elseif A(1,1)==2     
                   A(1,1)=2;
               else %A(1,1)==3
                   a=randsrc(1,1,[0 2 3;alpha omega 1-alpha-omega]);  %xy ��ʳ������������
                   if a==2 %����
                       A(1,i)=3;   
                       A(1,1)=2;
                   else 
                       A(1,1)=a;
                   end         
               end
           elseif A(1,i)==3
               if A(1,1)==0 
                   a=randsrc(1,1,[3 33 0;beta omega 1-beta-omega]);     %30 ��ֳ������������ 
                   if a==3
                       A(1,1)=3;
                   elseif a==33
                       A(1,i)=0;   
                       A(1,1)=3;
                   else 
                       A(1,1)=0;
                   end
               elseif A(1,1)==1
                   a=randsrc(1,1,[0 3 1;alpha omega 1-alpha-omega]); %31 ��ʳ������������
                   if a==3   %����
                       A(1,i)=1;   
                       A(1,1)=3;
                   else
                       A(1,1)=a;
                   end  
               elseif A(1,1)==2     
                   a=randsrc(1,1,[3 2;omega 1-omega]); %32 ����������
                   if a==3   %����
                       A(1,i)=2;   
                       A(1,1)=3;
                   else
                       A(1,1)=a;
                   end
               else %A(1,1)==3
                   A(1,1)=3;        
               end    
           else %A(1,i)==0
                A(1,i)=0;
           end
       end
              
   end
   spacetime(T-t,:) = A;
end

end
