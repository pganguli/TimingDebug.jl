min_st=10^2;
Pmin=zeros(1,5);
for i=1:4
    P(1)=0.015+(i-1)*0.005;
    %st1=(perf(1,i)-perf(1,1))/perf(1,1);
    rss1=perf(1,i);
    for j=1:3
        P(2)=0.01+(j-1)*0.005;
        %st2=(perf(2,j)-perf(2,1))/perf(2,1);
        rss2=perf(2,j);
        for k=1:37
            P(3)=0.02+(k-1)*0.005;
            %st3=(perf(3,k)-perf(3,1))/perf(3,1);
            rss3=perf(3,k);
            for l=1:3
                P(4)=0.03+(l-1)*0.005;
                %st4=(perf(4,l)-perf(4,1))/perf(4,1);
                rss4=perf(4,l);
                for m=1:4
                    P(5)=0.025+(m-1)*0.005;
                    %st5=(perf(5,m)-perf(5,1))/perf(5,1);
                    rss5=perf(5,m);
                    U=Task(1).e/P(1) + Task(2).e/P(2) + Task(3).e/P(3) + Task(4).e/P(4) + Task(5).e/P(5);
                    if U<=1
                        %st_all=(abs(st1)+abs(st2)+abs(st3)+abs(st4)+abs(st5))/5;
                        st_all=rss1+rss2+rss3+rss4+rss5;
                        if st_all<min_st
                            Pmin=P;
                            min_st=st_all;
                        end
                    end
                end
            end
        end
    end
end