function [K,F,K_acker] = poleplacement(phi_a,Gamma_a,C_a,poles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
gamma=ctrb(phi_a,Gamma_a);
if det(gamma)==0
    K=0;
    F=0;
    disp('system is not controllable');
    return
end
n_states=size(phi_a,1);
H=eye(n_states);
for i=1:size(poles,2)
    H=H*(phi_a-poles(i)*eye(n_states));
end
const=zeros(1,n_states);
const(n_states)=1;
K=const*inv(gamma)*H;
K_acker=K;
%K_acker=acker(phi_a,Gamma_a,poles);

F=1/(C_a*inv(eye(n_states)-phi_a+Gamma_a*K)*Gamma_a);



end

