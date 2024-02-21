load_system('healthyMotor.slx');

% Use model mask in simulink to get parameter name (ctrl+M)
% Use double quotes for block names and parameters with spaces
set_param(['healthyMotor','/', 'VoltageSource1'], 'Amplitude', '230');
set_param(['healthyMotor','/','VoltageSource2'], 'Amplitude','230');
set_param(['healthyMotor','/','VoltageSource3'], 'Amplitude','230');

sim("healthyMotor.slx");%filename


dataMat = zeros(18, 5);
z = [currentPhase1, currentPhase2, currentPhase3, statorVoltage1, statorVoltage2, statorVoltage3];
for phaseNum = 1:6
    phaseAmp = z(:, phaseNum);
    [c1, l1] = wavedec(phaseAmp, 5, "db6");
    for level = 1:5
        d1 = detcoef(c1, l1, level);
        m1 = mean(d1);
        s1 = std(d1);
        n1 = norm(d1);
        dataMat(((3 * phaseNum) - 2), level) = m1;
        dataMat(((3 * phaseNum) - 2) + 1, level) = s1;
        dataMat(((3 * phaseNum) - 2) + 2, level) = n1;
    end
end

% Display the result
disp(dataMat);