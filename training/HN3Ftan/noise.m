% Load data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

rng(1); % Set random seed for reproducibility

% Ensure class labels start from 1
y = y - min(y) + 1;

% Convert class labels to one-hot encoded matrix
yt = ind2vec(y');

% Define the neural network architecture
hiddenLayerSize = [2,1,3]; % Two hidden layers, each containing three neurons
net = patternnet(hiddenLayerSize);

% Set activation function to hyperbolic tangent for hidden layers
for j = 1:length(hiddenLayerSize)
    net.layers{j}.transferFcn = 'tansig'; % Hyperbolic tangent activation function
end

% Set activation function of output layer to softmax
net.layers{end}.transferFcn = 'softmax';

% Set training algorithm
net.trainFcn = 'trainscg';

% Adjust learning rate
net.trainParam.lr = 0.00001; % Learning rate

% Set performance function to cross-entropy
net.performFcn = 'crossentropy';

% Split the dataset into training, testing, and validation sets
[trainInd, valInd, testInd] = dividerand(size(x, 1), 0.6, 0.2, 0.2); % 60% train, 20% validation, 20% test

x_train = x(trainInd, :);
y_train = yt(:, trainInd);

x_val = x(valInd, :);
y_val = yt(:, valInd);

x_test = x(testInd, :);
y_test = yt(:, testInd);

% Train the neural network model using the training set
[net,tr] = train(net, x_train', y_train);

% Test the trained model using the testing set
predicted_labels_test = net(x_test');
[~, predicted_classes_test] = max(predicted_labels_test);
[~, true_classes_test] = max(y_test);

% Calculate testing accuracy
accuracy_test = sum(predicted_classes_test == true_classes_test) / length(true_classes_test);
disp('Testing Accuracy:');
disp(accuracy_test);

% Calculate confusion matrix for testing data
confusion_matrix_test = confusionmat(true_classes_test, predicted_classes_test);
disp('Testing Confusion Matrix:');
disp(confusion_matrix_test);

% Calculate precision, recall, and F1-score for each class
num_classes = size(y_test, 1);
precision = zeros(num_classes, 1);
recall = zeros(num_classes, 1);
f1_score = zeros(num_classes, 1);

for i = 1:num_classes
    tp = confusion_matrix_test(i, i);
    fp = sum(confusion_matrix_test(:, i)) - tp;
    fn = sum(confusion_matrix_test(i, :)) - tp;
    
    % Handle division by zero
    if tp + fp == 0
        precision(i) = 0;
    else
        precision(i) = tp / (tp + fp);
    end
    
    if tp + fn == 0
        recall(i) = 0;
    else
        recall(i) = tp / (tp + fn);
    end
    
    % Handle F1-score calculation
    if precision(i) + recall(i) == 0
        f1_score(i) = 0;
    else
        f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
    end
end

disp('Precision:');
disp(precision);
disp('Recall:');
disp(recall);
disp('F1-score:');
disp(f1_score);

% Generate perturbed data by adding Gaussian noise to the original input data
noise_level = 0.04; % Adjust the noise level as needed
perturbed_x_test = x_test + noise_level * randn(size(x_test));

% Test the trained model using the perturbed data
predicted_labels_perturbed = net(perturbed_x_test');
[~, predicted_classes_perturbed] = max(predicted_labels_perturbed);

% Calculate testing accuracy on perturbed data
accuracy_perturbed = sum(predicted_classes_perturbed == true_classes_test) / length(true_classes_test);
disp('Perturbed Testing Accuracy:');
disp(accuracy_perturbed);

% Calculate confusion matrix for perturbed testing data
confusion_matrix_perturbed = confusionmat(true_classes_test, predicted_classes_perturbed);
disp('Perturbed Testing Confusion Matrix:');
disp(confusion_matrix_perturbed);
