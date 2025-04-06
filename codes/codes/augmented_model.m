function [phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,d)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
phi=expm(A*h);
f_phi = @(s)expm(A*s);
Gamma0=integral(f_phi,0,h-d, 'ArrayValued', true)*B;
Gamma1=integral(f_phi,h-d,h, 'ArrayValued', true)*B;
phi_a=[phi Gamma1; zeros(size(B,2),(size(A,2)+size(B,2)))];
Gamma_a=[Gamma0;eye(size(B,2))];
C_a=[C zeros(size(C,1),size(B,2))];
end

