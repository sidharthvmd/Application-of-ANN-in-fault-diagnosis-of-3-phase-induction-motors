% Read the data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

% Ensure class labels start from 1
y = y - min(y) + 1;
yt = categorical(y);  % Convert class labels to categorical array

num_hidden_layers = 50;
precision_train = zeros(1, num_hidden_layers);
recall_train = zeros(1, num_hidden_layers);
precision_val = zeros(1, num_hidden_layers);
recall_val = zeros(1, num_hidden_layers);

% Determine the number of unique classes in your target variable
num_classes = numel(categories(yt));  % Number of unique classes

for i = 1:num_hidden_layers
    % Define the architecture of the ANN
    layers = [
        fullyConnectedLayer(12, 'Name', 'fc1')
        reluLayer('Name', 'relu1')
        fullyConnectedLayer(12, 'Name', 'fc2')
        reluLayer('Name', 'relu2')
        fullyConnectedLayer(num_classes, 'Name', 'output')
        softmaxLayer('Name', 'softmax')
        classificationLayer('Name', 'classOutput')
    ];

  valDataIndices = ~ismember(1:size(x, 2), tr.trainInd);
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 0.001, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', false, ...
    'Plots', 'training-progress', ...
    'ValidationData', {x(:, valDataIndices)', yt(:, valDataIndices)});


    % Train the ANN
    net = trainNetwork(x(:, tr.trainInd)', yt(tr.trainInd), layers, options);

    % Predict using the trained ANN
    yTrainProb = predict(net, x(:, tr.trainInd)');
    yValProb = predict(net, x(:, tr.valInd)');

    % Convert probabilities to class indices
    [~, yTrainIndex] = max(yTrainProb, [], 2);
    [~, yValIndex] = max(yValProb, [], 2);

    % Convert categorical true labels to class indices
    trueTrainIndex = double(yt(tr.trainInd));
    trueValIndex = double(yt(tr.valInd));

    % Calculate confusion matrix for training and validation sets
    confusion_train = confusionmat(trueTrainIndex, yTrainIndex);
    confusion_val = confusionmat(trueValIndex, yValIndex);

    % Calculate precision and recall for each class
    for class = 1:num_classes
        [precision_train(i, class), recall_train(i, class)] = precisionrecall(confusion_train, class);
        [precision_val(i, class), recall_val(i, class)] = precisionrecall(confusion_val, class);
    end

    disp(i)
end

% Plot both training and validation precision and recall for different numbers of hidden layers
figure;
subplot(2, 1, 1);
plot(1:num_hidden_layers, mean(precision_train, 2), 'b', 'LineWidth', 2);
hold on;
plot(1:num_hidden_layers, mean(precision_val, 2), 'r', 'LineWidth', 2);
xlabel('Number of Hidden Layers');
ylabel('Precision');
title('Precision vs Number of Hidden Layers');
legend('Training Set', 'Validation Set');
grid on;

subplot(2, 1, 2);
plot(1:num_hidden_layers, mean(recall_train, 2), 'b', 'LineWidth', 2);
hold on;
plot(1:num_hidden_layers, mean(recall_val, 2), 'r', 'LineWidth', 2);
xlabel('Number of Hidden Layers');
ylabel('Recall');
title('Recall vs Number of Hidden Layers');
legend('Training Set', 'Validation Set');
grid on;

% Define the precisionrecall function
function [precision, recall] = precisionrecall(confusion_matrix, class)
    % Precision: TP / (TP + FP)
    precision = confusion_matrix(class, class) / sum(confusion_matrix(:, class));

    % Recall: TP / (TP + FN)
    recall = confusion_matrix(class, class) / sum(confusion_matrix(class, :));
end
