A=-0.05;
B=0.001;
C=1;
h=0.02;

[phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,h);

polesS = [0.8 0.5];

[K_S,~,~] = poleplacement(phi_a,Gamma_a,C_a,polesS);

[~,~,S] = simulate1_new(A,B,C,h,h,K_S,0);
ST_S=S.SettlingTime;
RT_S=S.RiseTime;
O_S=S.Overshoot;

polesF = [0.4 0.1];

[K_F,~,~] = poleplacement(phi_a,Gamma_a,C_a,polesF);

[~,~,S] = simulate1_new(A,B,C,h,h,K_F,0);
ST_F=S.SettlingTime;
RT_F=S.RiseTime;
O_F=S.Overshoot;

iS=1;
per=h;
dataS=zeros(1000,5);
while 1
    per=per+0.001;
    [Mphi_a,MGamma_a,MC_a] = augmented_model(A,B,C,per,per);
    Mpoles=eig(Mphi_a-MGamma_a*K_S);
    if abs(Mpoles(1))<abs(Mpoles(2))
        Mpoles=flip(Mpoles);
    end
    if abs(Mpoles(1))>=1
        break;
    end
    D=sum(abs(Mpoles-polesS'))/2;
    Dd=abs(Mpoles(1)-polesS(1));
    dataS(iS,:)=[per,D,Dd,Mpoles'];
    iS=iS+1;
end

iF=1;
per=h;
dataF=zeros(1000,3);
while 1
    per=per+0.001;
    [Mphi_a,MGamma_a,MC_a] = augmented_model(A,B,C,per,per);
    Mpoles=eig(Mphi_a-MGamma_a*K_F);
    if abs(Mpoles(1))<abs(Mpoles(2))
        Mpoles=flip(Mpoles);
    end
    if abs(Mpoles(1))>=1
        break;
    end
    D=sum(abs(Mpoles-polesF'))/2;
    Dd=sum(abs(Mpoles(1)-polesF(1)));
    dataF(iF,:)=[per,D,Dd];
    iF=iF+1;
end

%plot(dataS(1:iS-1,1),dataS(1:iS-1,2)


dataS_poles=zeros(10000,7);
dataF_poles=zeros(10000,7);


jS=1;
for i=0.01:0.02:0.99
    for j=i:0.02:0.99
        pole_real=[max(i,j),min(i,j)];
        [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_real);
        [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
        D=sum(abs(pole_real-polesS))/2;
        Dd=sum(abs(pole_real(1)-polesS(1)));
        dataS_poles(jS,:)=[pole_real,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
        
        D=sum(abs(pole_real-polesF))/2;
        Dd=sum(abs(pole_real(1)-polesF(1)));
        dataF_poles(jS,:)=[pole_real,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
        
        jS=jS+1;
        
        if (abs(complex(i,j))<1)
            
            pole_complex=[complex(i,j),complex(i,-j)];
            [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
            [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
            D=sum(abs(pole_complex-polesS))/2;
            Dd=sum(abs(pole_complex(1)-polesS(1)));
            dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
            
            D=sum(abs(pole_complex-polesF))/2;
            Dd=sum(abs(pole_complex(1)-polesF(1)));
            dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
            
            jS=jS+1;
            
            
            if (i~=j)
                pole_complex=[complex(j,i),complex(j,-i)];
                [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
                [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
                D=sum(abs(pole_complex-polesS))/2;
                Dd=sum(abs(pole_complex(1)-polesS(1)));
                dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
                
                D=sum(abs(pole_complex-polesF))/2;
                Dd=sum(abs(pole_complex(1)-polesF(1)));
                dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
                
                jS=jS+1;

            
            end
        end
    end
end
        
