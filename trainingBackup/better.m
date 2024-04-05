% Read the data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

% Ensure class labels start from 1
y = y - min(y) + 1;
xt = x';
yt = ind2vec(y');  % Convert class labels to one-hot encoded matrix


num_hidden_layers = 50;
precision_train = zeros(1, num_hidden_layers);
recall_train = zeros(1, num_hidden_layers);
precision_val = zeros(1, num_hidden_layers);
recall_val = zeros(1, num_hidden_layers);

% Determine the number of unique classes in your target variable
num_classes = size(yt, 1);  % Number of unique classes is the number of rows in yt

for i = 1:num_hidden_layers 
    % defining the architecture of the ANN
    hiddenLayerSize = i;  
    net = patternnet(hiddenLayerSize); % Use patternnet for classification
    net.divideParam.trainRatio = 70/100; 
    net.divideParam.valRatio = 15/100; 
    net.divideParam.testRatio = 15/100; 

    % Set the learning rate
    net.trainParam.lr = 0.00000001; % Set the learning rate to 0.001 (adjust as needed)

    % Set activation function to ReLU for all hidden layers
    for j = 1:length(net.layers)-1
        net.layers{j}.transferFcn = 'poslin'; % ReLU activation function
    end
    
    % Set activation function of output layer to softmax
    net.layers{end}.transferFcn = 'softmax';

    % Set the number of output neurons to match the number of classes
    net.layers{end}.size = num_classes;

    % Set training algorithm to SCG
    net.trainFcn = 'trainscg'; % Change to 'scg'
    net.performFcn = 'crossentropy'; % Set the performance function to cross-entropy

    % Training the ANN
    [net, tr] = train(net, xt, yt);  

    % Determine the output of the ANN
    yTrainProb = net(xt(:, tr.trainInd)); 
    yValProb = net(xt(:, tr.valInd));

    % Convert probabilities to class indices
    [~, yTrainIndex] = max(yTrainProb);
    [~, yValIndex] = max(yValProb); 

    % Convert one-hot encoded true labels to class indices
    trueTrainIndex = vec2ind(yt(:, tr.trainInd));
    trueValIndex = vec2ind(yt(:, tr.valInd));

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

% Plot both training and validation precision and recall for different number of hidden layers
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

