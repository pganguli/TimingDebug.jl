A=[-10,1;-0.02,-2];
B=[0;2];
C=[1 0];
h=0.015;
poles=[0.5,0.5,0.5];
[phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,h);
[K,~,~] = poleplacement(phi_a,Gamma_a,C_a,poles);

[~,energy_i,S,y_i] = simulate1_new(A,B,C,h,h,K,0);
ST_i=S.SettlingTime;
RT_i=S.RiseTime;
O_i=S.Overshoot;


result=zeros(11,12);
result(1,:)=[h,poles,RT_i,ST_i,O_i,energy_i,0,0,0,0];
count=2;
for per=0.02:0.005:0.15
    [Mphi_a,MGamma_a,MC_a] = augmented_model(A,B,C,per,per);
    Mpoles=eig(Mphi_a-MGamma_a*K);
    Mpoles=sort(Mpoles,'descend');
    if abs(Mpoles(1))>=1
        break;
    end
    D=(sum(abs(Mpoles-poles'))/3);
    Dd=(abs(abs(Mpoles(1))-abs(poles(1))));
    Ddsqr=(abs(abs(Mpoles(1))-abs(poles(1)))*poles(1))^2;
    [~,Menergy,MS,My] = simulate1_new(A,B,C,per,per,K,0);
    if length(My)>length(y_i)
        y_comp1=[y_i;zeros(length(My)-length(y_i),1)];
        y_comp2=My;
    else
        y_comp1=y_i;
        y_comp2=[My;zeros(length(y_i)-length(My),1)];
    end
    Mrms=sqrt(sum((y_comp2-y_comp1).^2));
    result(count,:)=[per,Mpoles',MS.RiseTime,MS.SettlingTime,MS.Overshoot,Menergy,Mrms,D,Dd,Ddsqr];
    count=count+1;    
end