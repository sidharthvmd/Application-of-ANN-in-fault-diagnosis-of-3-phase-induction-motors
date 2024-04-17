
load_system('Bphase.slx');


numSamples = 333;

%initialisation
inputFeatures = zeros(numSamples * 18, 6);  % Assuming 18 rows and 5 columns for statistical features; the additional column for sample number
targetValues = zeros(numSamples*18, 2);  % Multi-class target values: 0 for healthy

initialValueFaultRatio = 0.01;  
finalValueFaultRatio = 0.1;

initialValueFaultResistance = 100;
finalValueFaultResistance = 315;

% Calculate step size
stepSizeFaultRatio = (finalValueFaultRatio - initialValueFaultRatio) / (numSamples - 1);
stepSizeFaultResistance = (finalValueFaultResistance - initialValueFaultResistance) / (numSamples - 1);

% Loop through samples
for i = 1:numSamples
    disp(i)
    % Set parameter values
    faultRatio = initialValueFaultRatio + (i-1) * stepSizeFaultRatio;
    faultResistance = initialValueFaultResistance + (i-1) * stepSizeFaultResistance;
    set_param(['Bphase','/', 'InductionMachine'], 'Kf', num2str(faultRatio));
    set_param(['Bphase','/','InductionMachine'], 'Rf', num2str(faultResistance));
    

    % Simulate the model
    sim("Bphase.slx");

    % Extract and process the data
    dataMat = zeros(18, 5);   % 18 = (3*3) for current and (3*3) for voltage
    z = [statorCurrent1, statorCurrent2, statorCurrent3, statorVoltage1, statorVoltage2, statorVoltage3];

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
            clc
            disp(i)
        end
    end


    % Store statistical features as input features
    inputFeatures((i-1)*18 + 1 : i*18, 2:6) = dataMat;  %data
    inputFeatures((i-1)*18 + 1 : i*18, 1) = i;  % number of sample index

    % Set the target value for healthy motor
    targetValues((i-1)*18 + 1 : i*18, 2) = 4; % data
    targetValues((i-1)*18 + 1 : i*18, 1) = i; % number of sample index

end

% Save input features and target values to a MAT file and csv file
save('ann_dataset_brokenRotorBarBphase.mat', 'inputFeatures', 'targetValues');
writematrix([inputFeatures, targetValues], 'ann_dataset_brokenRotorBarBphase.csv');