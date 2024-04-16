load_system('singlePhasingFault.slx');

normalVoltage = 230;

% Set initial parameter values
initialValue = 0;
finalValue = 150;
% Set parameter values
voltageValue = initialValue + ( finalValue - initialValue)*rand();

% Determine the phase to apply fault randomly
faultPhase = randi([1, 3]);

% Set parameter values for each phase
for k = 1:3
    if k == faultPhase
        % Apply fault to this phase
        set_param(['singlePhasingFault', '/VoltageSource', num2str(k)], 'Amplitude', num2str(voltageValue));
    else
        % Keep normal voltage in the other two phases
        set_param(['singlePhasingFault', '/VoltageSource', num2str(k)], 'Amplitude', num2str(normalVoltage));
    end
end

% Simulate the model
sim('singlePhasingFault.slx');

% Extract and process the data
dataMat = zeros(18, 5);
z = [currentPhase1, currentPhase2, currentPhase3, statorVoltage1, statorVoltage2, statorVoltage3];

for phaseNum = 1:6
    phaseAmp = z(:, phaseNum);
    [c1, l1] = wavedec(phaseAmp, 5, 'db6');
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


inputFeatures = dataMat;  % Data



targetValues = 3;



% Store the data in a cell array
datasample = {inputFeatures, targetValues};

