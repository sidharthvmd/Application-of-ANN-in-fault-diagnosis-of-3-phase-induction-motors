% load the neural network
loaded_network = load("trained_net.mat");

% choose a fault to simulate
% fault codes : H (healthy), O (overvoltage), U (undervoltage), S(single
% phasing), B ( broken rotor bar) , I (interturn SC fault )
fault = input("Please enter the fault code : ", 's');
fileName = '';
if( fault == "H")
    fileName = "healthymotorcode.m";
elseif( fault == "O")
    fileName = "overVoltagecode.m";
elseif( fault == "U")
    fileName = "underVoltagecode.m";
elseif( fault == "S")
    fileName = "singlePhasingcode.m";
elseif( fault == "B")
    fileName = "brokenrotorbarcode.m";
elseif( fault == "I")
    choices = {"BphaseCode.m", "RPhaseCode.m", "YphaseCode.m"};
    randomIndex = randi(numel(choices));
    fileName = choices{randomIndex};
else
    disp('Please enter a correct fault code.');
    return; % Return from the program
end

% Use the selected fileName for further processing
disp(['Selected fault code: ', fileName]);

% run the selected file
run(fileName);

% flattening the sample input
flattenedDataSample = {reshape(inputFeatures, 1, []), targetValues};

% normalisation
% Load the flattened data
data = readmatrix('flattened_data.csv');

min_val = min(data(:, 1:90), [], 1); % Minimum value for each column
max_val = max(data(:, 1:90), [], 1); % Maximum value for each column

% Extract input features from flattenedDataSample
inputFeatures = flattenedDataSample{1};

% Normalize the input features using min-max normalization
finalDataSampleInput = (inputFeatures - min_val) ./ (max_val - min_val);
finalDataSample = [finalDataSampleInput, targetValues];

trained_net = loaded_network.net;
view(trained_net);
finalDataSampleInput = finalDataSampleInput';

%debugging
% Check if the input data dimensions match the model
% Check the architecture of the loaded model
disp(['Number of input neurons in the loaded model: ', num2str(size(trained_net.inputs{1}.size, 1))]);
disp(['Number of output neurons in the loaded model: ', num2str(size(trained_net.outputs{end}.size, 1))]);

disp(['Size of input data: ', num2str(size(finalDataSampleInput))]);
disp(['Number of input neurons in the model: ', num2str(size(trained_net.inputs{1}.size, 1))]);

% Ensure that the number of input neurons matches the size of the input data
if size(finalDataSampleInput, 1) == size(trained_net.inputs{1}.size, 1)
    % Proceed with prediction
    prediction = predict(trained_net, finalDataSampleInput);
    disp("Predicted output:");
    disp(prediction);
else
    disp('Number of input neurons in the model does not match the size of the input data.');
end


% feed the finalDataSample to the ANN model for prediction
prediction = predict(trained_net, finalDataSampleInput);

% Display the prediction

disp("Predicted output:");
disp(prediction);
