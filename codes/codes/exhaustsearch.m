minF=10^4;
Pmin=zeros(1,5);
for i=1:5
    P(1)=0.015+(i-1)*0.005;
    for j=1:5
        P(2)=0.01+(j-1)*0.005;
        for k=1:37
            k
            P(3)=0.02+(k-1)*0.005;
            for l=1:12
                P(4)=0.03+(l-1)*0.005;
                for m=1:11
                    P(5)=0.025+(m-1)*0.005;
                    U=Task(1).e/P(1) + Task(2).e/P(2) + Task(3).e/P(3) + Task(4).e/P(4) + Task(5).e/P(5);
                    if U<=1
                        F=calculateF(Task,P);
                        if F<minF
                            Pmin=P;
                            minF=F;
                        end
                    end
                end
            end
        end
    end
end
                    