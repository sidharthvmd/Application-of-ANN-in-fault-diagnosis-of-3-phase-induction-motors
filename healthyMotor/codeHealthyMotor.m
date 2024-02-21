open_system("healthyMotor","loadonly");
sim("healthyMotor.slx");
dataMat = zeros(9,5);
z = [currentPhase1, currentPhase2, currentPhase3];
for phaseNum=1:3
    phaseAmp = z(:,phaseNum);
    [c1,l1] = wavedec(phaseAmp, 5, "db6");
    for level = 1:5
        d1 = detcoef(c1,l1,level);
        m1 = mean(d1);
        s1 = std(d1);
        n1 = norm(d1);
        dataMat(((3*phaseNum)-2),level) = m1;
        dataMat(((3*phaseNum)-2)+1,level) = s1;
        dataMat(((3*phaseNum)-2)+2,level) = n1;
    end
end
disp(dataMat)
