% Load the Simulink model
load_system('underVoltage.slx');

% Set the number of samples
numSamples = 1000;

% Initialize arrays to store input features and target values
inputFeatures = zeros(numSamples * 18, 6);  % Assuming 18 rows and 5 columns for statistical features the additional column for samplenumber
targetValues = zeros(numSamples*18, 2);  % Multi-class target values: 0 for healthy

% Set initial parameter values
initialValue = 75;
finalValue = 215;

% Calculate step size
stepSize = (finalValue - initialValue) / (numSamples - 1);

% Loop through samples
for i = 1:numSamples
    % Set parameter values
    voltageValue = initialValue + (i-1) * stepSize;
    set_param(['underVoltage','/', 'VoltageSource1'], 'Amplitude', num2str(voltageValue));
    set_param(['underVoltage','/','VoltageSource2'], 'Amplitude', num2str(voltageValue));
    set_param(['underVoltage','/','VoltageSource3'], 'Amplitude', num2str(voltageValue));

    % Simulate the model
    sim("underVoltage.slx");

    % Extract and process the data
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

    % Store statistical features as input features
    inputFeatures((i-1)*18 + 1 : i*18, 2:6) = dataMat;  %data
    inputFeatures((i-1)*18 + 1 : i*18, 1) = i;  % number of sample index

    % Set the target value for healthy motor
    targetValues((i-1)*18 + 1 : i*18, 2) = 0; % data
    targetValues((i-1)*18 + 1 : i*18, 1) = i; % number of sample index

end

% Save input features and target values to a MAT file
save('ann_dataset_underVoltage.mat', 'inputFeatures', 'targetValues');