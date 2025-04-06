function [settling_time,max_input] = simulate_new(A,B,C,d,h,K,F)
    [phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,d);
    r=1;
    sysd=ss(phi_a-Gamma_a*K,Gamma_a*F,C_a,0,h);
    [~,~,x]=step(sysd);
    u=-K*x'+F*r;
    u1=repmat(u,h/0.0001,1);
    u2=reshape(u1,1,[]);
    time1=0:0.0001:size(u2,2)*0.0001-0.0001;
    
    sysc=ss(A,B,C,0,'InputDelay',d);
    [y1,time1,~]=lsim(sysc,u2,time1);
    
    plot(time1,y1);
    
    S = stepinfo(y1,time1,r,'SettlingTimeThreshold',0.01);
    settling_time=1000;
    if S.SettlingTime ~=0
        settling_time=min(S.SettlingTime,1000);
    end
    max_input=max(abs(u));
end