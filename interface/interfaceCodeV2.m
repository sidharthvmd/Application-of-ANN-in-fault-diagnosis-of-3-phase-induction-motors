% load the neural network
loaded_network = load("trained_net.mat");

%provide the stator current and stator voltage waveforms
 z = [statorCurrent1, statorCurrent2, statorCurrent3, statorVoltage1, statorVoltage2, statorVoltage3];
 dataMat = zeros(18,5);
 %perform wavelet transform
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


% flattening the sample input
flattened_input = reshape(dataMat(:, 1:5).', 1, []);

% normalisation
% Load the flattened data
data = readmatrix('flattened_data.csv');
min_val = min(data(:, 1:90), [], 1); % Minimum value for each column
max_val = max(data(:, 1:90), [], 1); % Maximum value for each column
% Normalize the input features using min-max normalization
finalDataSampleInput = (flattened_input - min_val) ./ (max_val - min_val);
trained_net = loaded_network.net;
finalDataSampleInput = finalDataSampleInput';

%prediction
 predicted_labels = trained_net(finalDataSampleInput);
 % Convert the predicted labels to class indices (if needed)
[~, predicted_class] = max(predicted_labels);

% Display the prediction

disp("Predicted output:");
if(predicted_class == 1)
    disp("Healthy")
elseif(predicted_class == 2)
    disp("Overvoltage")
elseif(predicted_class == 3)
    disp("Undervoltage")
elseif(predicted_class == 4)
    disp("Single phasing ")
elseif(predicted_class == 5)
    disp("Interturn SC")
elseif(predicted_class == 6)
    disp("Broken rotor bar")
end
