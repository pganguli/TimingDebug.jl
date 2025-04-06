function F = calculateF(Task,P)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
D=zeros(1,5);
Dd=zeros(1,5);
Ddsqr=zeros(1,5);
for i=1:length(P)
    [Mphi_a,MGamma_a,~] = augmented_model(Task(i).A,Task(i).B,Task(i).C,P(i),P(i));
    Mpoles=eig(Mphi_a-MGamma_a*Task(i).K);
    Mpoles=sort(Mpoles,'descend');
    D(i)=(sum(abs(Mpoles-Task(i).poles'))/length(Task(i).poles));
    Dd(i)=(abs(abs(Mpoles(1))-abs(Task(i).poles(1))));
    Ddsqr(i)=(abs(abs(Mpoles(1))-abs(Task(i).poles(1)))*Task(i).poles(1))^2;
    %Ddsqr(i)=(abs(abs(Mpoles(1))-abs(Task(i).poles(1))))^2;
end

F=sum(D);