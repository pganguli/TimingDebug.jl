[phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,h);
[~,~,K] = poleplacement(phi_a,Gamma_a,C_a,poles);
%[settling_time,max_input] = simulate_new(A,B,C,d,h,K,F);
LUT=zeros(100,7);
i=1;
for h1=0.001:0.001:0.1
    [phi_a,Gamma_a,C_a] = augmented_model( A,B,C,h1,h1);
    poles_h=eig(phi_a-Gamma_a*K);
    [settling_time,max_input] = simulate1_new(A,B,C,h1,h1,K,0);
    LUT(i,:)=[h1, poles_h', settling_time, max_input];
    i=i+1;
end

i=1;
LUT1=zeros(100,11);
for h2=0.001:0.001:0.1
    [phi_a,Gamma_a,C_a] = augmented_model( A,B,C,h2,h2);
    [~,~,K1] = poleplacement(phi_a,Gamma_a,C_a,poles);
    [settling_time,max_input] = simulate1_new(A,B,C,h2,h2,K1,0);
    sysd=ss(phi_a-Gamma_a*K,Gamma_a*0,C_a,0,h2);
    sysc=d2c(sysd,'zoh');
    poles_h2=eig(sysc.A);
    
    LUT1(i,1:3+size(poles_h2,1))=[h2, settling_time, max_input, poles_h2'];    
    i=i+1;
end