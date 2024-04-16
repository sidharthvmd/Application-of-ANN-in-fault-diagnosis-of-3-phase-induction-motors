% Load the Simulink model
load_system('rotorbroken_gamma.slx');


% Set initial parameter values
initialValue = 1.2;
finalValue = 314;  


   % Set parameter values
    resistanceValue = initialValue + (finalValue - initialValue)*rand();
    set_param(['rotorbroken_gamma','/', 'statorResistor'], 'Resistance', num2str(resistanceValue));
    
    % Simulate the model
    sim("rotorbroken_gamma.slx");

    % Extract and process the data
    dataMat = zeros(18, 5);
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
        end
    end

    % Store statistical features as input features
    inputFeatures = dataMat;  %data

    % Set the target value 
    targetValues = 5; % data
   
% Store the data in a cell array
datasample = {inputFeatures, targetValues};
