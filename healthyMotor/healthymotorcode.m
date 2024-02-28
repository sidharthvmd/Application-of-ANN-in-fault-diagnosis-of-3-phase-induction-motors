
load_system('healthyMotor.slx');


numSamples = 1000;

%initialisation
inputFeatures = zeros(numSamples * 18, 6);  % Assuming 18 rows and 5 columns for statistical features; the additional column for sample number
targetValues = zeros(numSamples*18, 2);  % Multi-class target values: 0 for healthy

initialValue = 220;   %need to reconsider the healthy motor ranges
finalValue = 240;

% Calculate step size
stepSize = (finalValue - initialValue) / (numSamples - 1);

% Loop through samples
for i = 1:numSamples
    % Set parameter values
    voltageValue = initialValue + (i-1) * stepSize;
    set_param(['healthyMotor','/', 'VoltageSource1'], 'Amplitude', num2str(voltageValue));
    set_param(['healthyMotor','/','VoltageSource2'], 'Amplitude', num2str(voltageValue));
    set_param(['healthyMotor','/','VoltageSource3'], 'Amplitude', num2str(voltageValue));

    % Simulate the model
    sim("healthyMotor.slx");

    % Extract and process the data
    dataMat = zeros(18, 5);   % 18 = (3*3) for current and (3*3) for voltage
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

    % Apply z-score normalization to the dataMat
    dataMat(:, 1:5) = zscore(dataMat(:, 1:5));

    % Store statistical features as input features
    inputFeatures((i-1)*18 + 1 : i*18, 2:6) = dataMat;  %data
    inputFeatures((i-1)*18 + 1 : i*18, 1) = i;  % number of sample index

    % Set the target value for healthy motor
    targetValues((i-1)*18 + 1 : i*18, 2) = 0; % data
    targetValues((i-1)*18 + 1 : i*18, 1) = i; % number of sample index

end

% Save input features and target values to a MAT file and csv file
save('ann_dataset_healthy.mat', 'inputFeatures', 'targetValues');
writematrix([inputFeatures, targetValues], 'ann_dataset_healthy.csv');