J = 0.01;
b = 0.1;
K = 0.01;
R = 1;
L = 0.5;
A = [-b/J   K/J
    -K/L   -R/L];
B = [0
    1/L];
C = [1   0];

h=0.02;

[phi_a,Gamma_a,C_a] = augmented_model(A,B,C,h,h);

polesS = [0.8 0.8 0.8];

[K_S,~,~] = poleplacement(phi_a,Gamma_a,C_a,polesS);

[settling_time,energy,S,y1] = simulate1_new(A,B,C,h,h,K_S,0);
ST_S=S.SettlingTime;
RT_S=S.RiseTime;
O_S=S.Overshoot;
E_S=energy;

polesF = [0.3 0.3 0.3];

[K_F,~,~] = poleplacement(phi_a,Gamma_a,C_a,polesF);

[~,energy,S,y2] = simulate1_new(A,B,C,h,h,K_F,0);
ST_F=S.SettlingTime;
RT_F=S.RiseTime;
O_F=S.Overshoot;
E_F=energy;

iS=1;
per=h;
dataS=zeros(1000,11);
while 1
    per=per+0.001;
    [Mphi_a,MGamma_a,MC_a] = augmented_model(A,B,C,per,per);
    Mpoles=eig(Mphi_a-MGamma_a*K_S);
    Mpoles=sort(Mpoles,'descend');
    if abs(Mpoles(1))>=1
        break;
    end
    D=(sum(abs(Mpoles-polesS')));
    Dd=(abs(abs(Mpoles(1))-abs(polesS(1))));
    %Ddsqr=(abs(abs(Mpoles(1))-abs(poles(1)))*poles(1))^2;
    [~,Menergy,MS,My] = simulate1_new(A,B,C,per,per,K_S,0);
    if length(My)>length(y1)
        y_comp1=[y1;zeros(length(My)-length(y1),1)];
        y_comp2=My;
    else
        y_comp1=y1;
        y_comp2=[My;zeros(length(y1)-length(My),1)];
    end
    Mrms=sqrt(sum((y_comp2-y_comp1).^2));
    
    dataS(iS,:)=[per,D,Dd,Mpoles',MS.SettlingTime,MS.RiseTime,MS.Overshoot,Menergy,Mrms];
    iS=iS+1;
    if iS>200
        break;
    end
end

iF=1;
per=h;
dataF=zeros(1000,11);
while 1
    per=per+0.001;
    [Mphi_a,MGamma_a,MC_a] = augmented_model(A,B,C,per,per);
    Mpoles=eig(Mphi_a-MGamma_a*K_F);
    Mpoles=sort(Mpoles,'descend');
    if abs(Mpoles(1))>=1
        break;
    end
    D=(sum(abs(Mpoles-polesF')));
    Dd=(abs(abs(Mpoles(1))-abs(polesF(1))));
    
    [~,Menergy,MS,My] = simulate1_new(A,B,C,per,per,K_F,0);
    if length(My)>length(y2)
        y_comp1=[y2;zeros(length(My)-length(y2),1)];
        y_comp2=My;
    else
        y_comp1=y2;
        y_comp2=[My;zeros(length(y2)-length(My),1)];
    end
    Mrms=sqrt(sum((y_comp2-y_comp1).^2));
    dataF(iF,:)=[per,D,Dd,Mpoles',MS.SettlingTime,MS.RiseTime,MS.Overshoot,Menergy,Mrms];
    iF=iF+1;
    if iF>200
        break;
    end
end

%plot(dataS(1:iS-1,1),dataS(1:iS-1,2)


%  dataS_poles=zeros(125000,8);
%  dataF_poles=zeros(125000,8);
%  
%  
%  jS=1;
%  for i=0.01:0.02:0.99
%      for j=i:0.02:0.99
%          for k=j:0.02:0.99
%              
%             pole_real=sort([i,j,k],'descend');
%             [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_real);
%             [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%             D=sum(abs(pole_real-polesS))/3;
%             Dd=sum(abs(pole_real(1)-polesS(1)));
%             dataS_poles(jS,:)=[pole_real,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%             D=sum(abs(pole_real-polesF))/3;
%             Dd=sum(abs(pole_real(1)-polesF(1)));
%             dataF_poles(jS,:)=[pole_real,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%             jS=jS+1;
%         
%             if (abs(complex(i,j))<1)
% 
%                 pole_complex=[k,complex(i,j),complex(i,-j)];
%                 pole_complex=sort(pole_complex,'descend');
%                 [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                 [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                 D=sum(abs(pole_complex-polesS))/3;
%                 Dd=sum(abs(pole_complex(1)-polesS(1)));
%                 dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                 D=sum(abs(pole_complex-polesF))/3;
%                 Dd=sum(abs(pole_complex(1)-polesF(1)));
%                 dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                 jS=jS+1;
% 
% 
%                 if (i~=j)
%                     pole_complex=[k,complex(j,i),complex(j,-i)];
%                     pole_complex=sort(pole_complex,'descend');
%                     [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                     [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                     D=sum(abs(pole_complex-polesS))/3;
%                     Dd=sum(abs(pole_complex(1)-polesS(1)));
%                     dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                     D=sum(abs(pole_complex-polesF))/3;
%                     Dd=sum(abs(pole_complex(1)-polesF(1)));
%                     dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                     jS=jS+1;
%                 end
%             end
%             
%             if (abs(complex(j,k))<1)
% 
%                 pole_complex=[i,complex(j,k),complex(j,-k)];
%                 pole_complex=sort(pole_complex,'descend');
%                 [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                 [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                 D=sum(abs(pole_complex-polesS))/3;
%                 Dd=sum(abs(pole_complex(1)-polesS(1)));
%                 dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                 D=sum(abs(pole_complex-polesF))/3;
%                 Dd=sum(abs(pole_complex(1)-polesF(1)));
%                 dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                 jS=jS+1;
% 
% 
%                 if (j~=k)
%                     pole_complex=[i,complex(k,j),complex(k,-j)];
%                     pole_complex=sort(pole_complex,'descend');
%                     [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                     [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                     D=sum(abs(pole_complex-polesS))/3;
%                     Dd=sum(abs(pole_complex(1)-polesS(1)));
%                     dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                     D=sum(abs(pole_complex-polesF))/3;
%                     Dd=sum(abs(pole_complex(1)-polesF(1)));
%                     dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                     jS=jS+1;
%                 end
%             end
%             
%             if (abs(complex(i,k))<1)
% 
%                 pole_complex=[j,complex(i,k),complex(i,-k)];
%                 pole_complex=sort(pole_complex,'descend');
%                 [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                 [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                 D=sum(abs(pole_complex-polesS))/3;
%                 Dd=sum(abs(pole_complex(1)-polesS(1)));
%                 dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                 D=sum(abs(pole_complex-polesF))/3;
%                 Dd=sum(abs(pole_complex(1)-polesF(1)));
%                 dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                 jS=jS+1;
% 
% 
%                 if (i~=k)
%                     pole_complex=[j,complex(k,i),complex(k,-i)];
%                     pole_complex=sort(pole_complex,'descend');
%                     [K_M,~,~] = poleplacement(phi_a,Gamma_a,C_a,pole_complex);
%                     [~,~,S_M] = simulate1_new(A,B,C,h,h,K_M,0);
%                     D=sum(abs(pole_complex-polesS))/3;
%                     Dd=sum(abs(pole_complex(1)-polesS(1)));
%                     dataS_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_S)*100/ST_S,abs(S_M.RiseTime-RT_S)*100/RT_S,abs(S_M.Overshoot)];
% 
%                     D=sum(abs(pole_complex-polesF))/3;
%                     Dd=sum(abs(pole_complex(1)-polesF(1)));
%                     dataF_poles(jS,:)=[pole_complex,D,Dd,abs(S_M.SettlingTime-ST_F)*100/ST_F,abs(S_M.RiseTime-RT_F)*100/RT_F,abs(S_M.Overshoot)];
% 
%                     jS=jS+1;
%                 end
%             end
%          end
%     end
% end
%         
