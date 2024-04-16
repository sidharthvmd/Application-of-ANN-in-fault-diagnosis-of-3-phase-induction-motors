
load_system('healthyMotor.slx');


initialValue = 220;   
finalValue = 240;




    % Set parameter values
    voltageValue = initialValue + (finalValue - initialValue)*rand();
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

    % Store statistical features as input features
    inputFeatures = dataMat;  %data


    % Set the target value for healthy motor
    targetValues = 0; % data

% Store the data in a cell array
datasample = {inputFeatures, targetValues};