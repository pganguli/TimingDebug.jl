tic
Omega=[];
Omega(1).P=[Task(1).p Task(2).p Task(3).p Task(4).p Task(5).p];
Omega(1).U=Task(1).e/Task(1).p + Task(2).e/Task(2).p + Task(3).e/Task(3).p + Task(4).e/Task(4).p + Task(5).e/Task(5).p;
Omega(1).F=0;


if Omega(1).U>1
    flag=0;
else
    flag=1;
end
while (flag==0)
    flag=1;
    Omega1=[];
    for i=1:length(Omega)
        if Omega(i).U<=1
            Omega1=[Omega1 Omega(i)];
        else
            for j=1:5
                Omegastar=Omega(i);
                Omegastar.P(j)=Omegastar.P(j)+0.005;
                [Mphi_a,MGamma_a,MC_a] = augmented_model(Task(j).A,Task(j).B,Task(j).C,Omegastar.P(j),Omegastar.P(j));
                Mpoles=eig(Mphi_a-MGamma_a*Task(j).K);
                Mpoles=sort(Mpoles,'descend');
                if abs(Mpoles(1))<1 && Omegastar.P(j)<=10*Task(j).p
                    Omegastar.U=Task(1).e/Omegastar.P(1) + Task(2).e/Omegastar.P(2) + Task(3).e/Omegastar.P(3) + Task(4).e/Omegastar.P(4) + Task(5).e/Omegastar.P(5);
                    Omegastar.F=calculateF(Task,Omegastar.P);
                    Omega1=[Omega1 Omegastar];
                end
            end
        end
    end
    Omega=[];
    for i=1:length(Omega1)
        flag1=1;
        for j=1:i-1
            if nnz(Omega1(i).P-Omega1(j).P)==0
                flag1=0; 
            end
            if Omega1(j).U<=Omega1(i).U && Omega1(j).F<Omega1(i).F
                flag1=0;
            end
        end
        for j=i+1:length(Omega1)
            if Omega1(j).U<=Omega1(i).U && Omega1(j).F<Omega1(i).F
                flag1=0;
            end
        end
        if flag1==1
            if Omega1(i).U>1
                flag=0;
            end
            Omega=[Omega Omega1(i)];
        end
    end
    length(Omega)
    %flag=1;
end
toc