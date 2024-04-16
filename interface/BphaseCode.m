load_system('Bphase.slx');

initialValueFaultRatio = 0.01;  
finalValueFaultRatio = 0.1;

initialValueFaultResistance = 100;
finalValueFaultResistance = 315;


    % Generate random fault ratio and fault resistance within the specified range
    faultRatio = initialValueFaultRatio + (finalValueFaultRatio - initialValueFaultRatio) * rand();
    faultResistance = initialValueFaultResistance + (finalValueFaultResistance - initialValueFaultResistance) * rand();
    
    set_param(['Bphase','/', 'InductionMachine'], 'Kf', num2str(faultRatio));
    set_param(['Bphase','/','InductionMachine'], 'Rf', num2str(faultResistance));
    

    % Simulate the model
    sim("Bphase.slx");

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
            clc
        end
    end


    % Store statistical features as input features
    inputFeatures = dataMat;  %data
   

    % Set the target value for healthy motor
    targetValues = 4; % data


% Store the data in a cell array
datasample = {inputFeatures, targetValues};

