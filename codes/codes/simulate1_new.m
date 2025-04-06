function [settling_time,energy,S,y1] = simulate1_new(A,B,C,d,h,K,F)
    [phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,d);
    r=0;
    sysd=ss(phi_a-Gamma_a*K,Gamma_a*F,C_a,0,h);
    x_init=zeros(size(phi_a,1),1);
    x_init(1)=1;
    [~,~,x]=initial(sysd,x_init);
    %plot(time,y)
    %hold on
    u=-K*x'+F*r;
    energy=sum(abs(u))*h;
    u1=repmat(u,uint32(h/0.0001),1);
    u2=reshape(u1,1,[]);
    time1=0:0.0001:size(u2,2)*0.0001-0.0001;
    
    sysc=ss(A,B,C,0,'InputDelay',d);
    [y1,time1,~]=lsim(sysc,u2,time1,x_init(1:end-1,1));
    
    plot(time1,y1);
    hold on
    
    
    y2=ones(size(y1,1),size(y1,2))-y1;
    %plot(time1,y2)
    
    
    
    S = stepinfo(y2,time1,1,'SettlingTimeThreshold',0.01);
    S.Overshoot=abs((S.Peak-1)*100);
    settling_time=1000;
    if S.SettlingTime ~=0
        settling_time=min(S.SettlingTime,1000);
        if settling_time<1000
            settling_time=time1(find(abs(y1)>0.01,1,'last'));
        end
    end
    %max_input=max(abs(u));
end