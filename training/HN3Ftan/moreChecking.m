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
hiddenLayerSize = [3,5,3]; % Two hidden layers, each containing three neurons 
net = patternnet(hiddenLayerSize);

% Set activation function to hyperbolic tangent for hidden layers
for j = 1:length(hiddenLayerSize)
    net.layers{j}.transferFcn = 'poslin'; % Hyperbolic tangent activation function
end

% net.performParam.regularization = 0.01;
% Set activation function of output layer to softmax
net.layers{end}.transferFcn = 'softmax';

% Set training algorithm 
net.trainFcn = 'trainscg';

% Adjust learning rate
net.trainParam.lr = 0.00001; % Learning rate

% Set performance function to cross-entropy
net.performFcn = 'crossentropy';

% Split the dataset into training, validation, and testing sets
[trainInd, valInd, testInd] = dividerand(size(x, 1), 0.6, 0.2, 0.2); % 60% train, 20% validation, 20% test

x_train = x(trainInd, :);
y_train = yt(:, trainInd);

x_val = x(valInd, :);
y_val = yt(:, valInd);

x_test = x(testInd, :);
y_test = yt(:, testInd);

% Train the neural network model using the training set
[net,tr] = train(net, x_train', y_train);

% Test the trained model using the training set
predicted_labels_train = net(x_train');
[~, predicted_classes_train] = max(predicted_labels_train);
[~, true_classes_train] = max(y_train);

% Calculate training accuracy
accuracy_train = sum(predicted_classes_train == true_classes_train) / length(true_classes_train);
disp('Training Accuracy:');
disp(accuracy_train);

% Calculate confusion matrix for training data
confusion_matrix_train = confusionmat(true_classes_train, predicted_classes_train);
disp('Training Confusion Matrix:');
disp(confusion_matrix_train);

% Calculate precision, recall, and F1-score for each class for training data
num_classes = size(y_train, 1);
precision_train = zeros(num_classes, 1);
recall_train = zeros(num_classes, 1);
f1_score_train = zeros(num_classes, 1);

for i = 1:num_classes
    tp = confusion_matrix_train(i, i);
    fp = sum(confusion_matrix_train(:, i)) - tp;
    fn = sum(confusion_matrix_train(i, :)) - tp;
    
    % Handle division by zero
    if tp + fp == 0
        precision_train(i) = 0;
    else
        precision_train(i) = tp / (tp + fp);
    end
    
    if tp + fn == 0
        recall_train(i) = 0;
    else
        recall_train(i) = tp / (tp + fn);
    end
    
    % Handle F1-score calculation
    if precision_train(i) + recall_train(i) == 0
        f1_score_train(i) = 0;
    else
        f1_score_train(i) = 2 * (precision_train(i) * recall_train(i)) / (precision_train(i) + recall_train(i));
    end
end

disp('Precision (Training):');
disp(precision_train);
disp('Recall (Training):');
disp(recall_train);
disp('F1-score (Training):');
disp(f1_score_train);

% Test the trained model using the validation set
predicted_labels_val = net(x_val');
[~, predicted_classes_val] = max(predicted_labels_val);
[~, true_classes_val] = max(y_val);

% Calculate validation accuracy
accuracy_val = sum(predicted_classes_val == true_classes_val) / length(true_classes_val);
disp('Validation Accuracy:');
disp(accuracy_val);

% Calculate confusion matrix for validation data
confusion_matrix_val = confusionmat(true_classes_val, predicted_classes_val);
disp('Validation Confusion Matrix:');
disp(confusion_matrix_val);

% Calculate precision, recall, and F1-score for each class for validation data
precision_val = zeros(num_classes, 1);
recall_val = zeros(num_classes, 1);
f1_score_val = zeros(num_classes, 1);

for i = 1:num_classes
    tp = confusion_matrix_val(i, i);
    fp = sum(confusion_matrix_val(:, i)) - tp;
    fn = sum(confusion_matrix_val(i, :)) - tp;
    
    % Handle division by zero
    if tp + fp == 0
        precision_val(i) = 0;
    else
        precision_val(i) = tp / (tp + fp);
    end
    
    if tp + fn == 0
        recall_val(i) = 0;
    else
        recall_val(i) = tp / (tp + fn);
    end
    
    % Handle F1-score calculation
    if precision_val(i) + recall_val(i) == 0
        f1_score_val(i) = 0;
    else
        f1_score_val(i) = 2 * (precision_val(i) * recall_val(i)) / (precision_val(i) + recall_val(i));
    end
end

disp('Precision (Validation):');
disp(precision_val);
disp('Recall (Validation):');
disp(recall_val);
disp('F1-score (Validation):');
disp(f1_score_val);

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

% Calculate precision, recall, and F1-score for each class for testing data
precision_test = zeros(num_classes, 1);
recall_test = zeros(num_classes, 1);
f1_score_test = zeros(num_classes, 1);

for i = 1:num_classes
    tp = confusion_matrix_test(i, i);
    fp = sum(confusion_matrix_test(:, i)) - tp;
    fn = sum(confusion_matrix_test(i, :)) - tp;
    
    % Handle division by zero
    if tp + fp == 0
        precision_test(i) = 0;
    else
        precision_test(i) = tp / (tp + fp);
    end
    
    if tp + fn == 0
        recall_test(i) = 0;
    else
        recall_test(i) = tp / (tp + fn);
    end
    
    % Handle F1-score calculation
    if precision_test(i) + recall_test(i) == 0
        f1_score_test(i) = 0;
    else
        f1_score_test(i) = 2 * (precision_test(i) * recall_test(i)) / (precision_test(i) + recall_test(i));
    end
end

disp('Precision (Testing):');
disp(precision_test);
disp('Recall (Testing):');
disp(recall_test);
disp('F1-score (Testing):');
disp(f1_score_test);
