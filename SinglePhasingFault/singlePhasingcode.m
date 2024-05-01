load_system('singlePhasingFault.slx');

numSamples = 999;
normalVoltage = 230;

% Set initial parameter values
initialValue = 0;
finalValue = 150;

% Initialize arrays to store input features and target values for each phase
inputFeaturesAll = zeros(numSamples * 18, 6);
targetValuesAll = zeros(numSamples * 18, 2);

for voltageSourceIndex = 1:3
    % Preallocate phase-specific matrices
    inputFeatures = zeros((numSamples / 3) * 18, 6);
    targetValues = zeros((numSamples / 3) * 18, 2);

    % Loop through samples
    for i = 1:(numSamples / 3)
        % Set parameter values
        voltageValue = initialValue + (i-1) * (finalValue - initialValue) / (numSamples / 3 - 1);

        % Set parameter values for each phase
        for k = 1:3
            if k == voltageSourceIndex
                set_param(['singlePhasingFault', '/VoltageSource', num2str(k)], 'Amplitude', num2str(voltageValue));
            else
                set_param(['singlePhasingFault', '/VoltageSource', num2str(k)], 'Amplitude', num2str(normalVoltage));
            end
        end

        % Simulate the model
        sim('singlePhasingFault.slx');

        % Extract and process the data
        dataMat = zeros(18, 5);
        z = [statorCurrent1, statorCurrent2, statorCurrent3, statorVoltage1, statorVoltage2, statorVoltage3];

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
        
        % Store statistical features as input features
        inputFeatures((i-1)*18 + 1 : i*18, 2:6) = dataMat;  % data
        inputFeatures((i-1)*18 + 1 : i*18, 1) = i;  % number of sample index

        % Set the target value 
        targetValues((i-1)*18 + 1 : i*18, 2) = 3; % data
        targetValues((i-1)*18 + 1 : i*18, 1) = i; % number of sample index
    end

    % Concatenate phase-specific data to overall arrays
    startIdx = (voltageSourceIndex - 1) * (numSamples / 3) * 18 + 1;
    endIdx = voltageSourceIndex * (numSamples / 3) * 18;
    inputFeaturesAll(startIdx:endIdx, :) = inputFeatures;
    targetValuesAll(startIdx:endIdx, :) = targetValues;
end

% Save input features and target values to a MAT file
save('ann_dataset_singlePhasingFault.mat', 'inputFeaturesAll', 'targetValuesAll');
writematrix([inputFeaturesAll, targetValuesAll], 'ann_dataset_singlePhasingFault.csv');

