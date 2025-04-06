function [settling_time,max_input,S] = simulate1_new(A,B,C,h,d,K,F)
    [phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,d);
    r=0;
    sysd=ss(phi_a-Gamma_a*K,Gamma_a*F,C_a,0,h);
    % Create initial conditions of the form [1;0;...;0] for both the
    % continuous- and discrete-time systems.
    x_0 = cat(1, [1], zeros(size(A,2)-1, 1));
    x_0a = cat(1, [1], zeros(size(phi_a,2)-1, 1));
    [~,~,x]=initial(sysd,x_0a);
    %plot(time,y)
    %hold on
    u=-K*x'+F*r;
    timestep=0.0001;
    u1=repmat(u,uint32(h/timestep),1);
    u2=reshape(u1,1,[]);
    time1=0:timestep:size(u2,2)*timestep-timestep;
    
    sysc=ss(A,B,C,0,'InputDelay',d);
    [y1,time1,~]=lsim(sysc,u2,time1,x_0);  % We might want to force a zero-order hold here
    %plot(time1,y1);
    %hold on
    
    
    %y2=ones(size(y1,1),size(y1,2))-y1;  % Simplified below
    y2 = 1 - y1;
    %plot(time1,y2)
    
    
    
    S = stepinfo(y2,time1,1,'SettlingTimeThreshold',0.01);
    settling_time=1000;
    if S.SettlingTime ~=0
        settling_time=min(S.SettlingTime,1000);
        if settling_time<1000
            settling_time=time1(find(abs(y1)>0.01,1,'last'));
        end
    end
    max_input=max(abs(u));
end