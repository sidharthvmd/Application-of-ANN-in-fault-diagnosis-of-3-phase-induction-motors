% Load data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

% Set random seed
rng(1); 

% Ensure class labels start from 1
y = y - min(y) + 1;

% Convert class labels to one-hot encoded matrix
yt = ind2vec(y');

% Split the dataset into training, testing, and validation sets
[trainInd, valInd, testInd] = dividerand(size(x, 1), 0.6, 0.2, 0.2); % 60% train, 20% validation, 20% test

x_train = x(trainInd, :);
y_train = yt(:, trainInd);

x_val = x(valInd, :);
y_val = yt(:, valInd);

x_test = x(testInd, :);
y_test = yt(:, testInd);

% Define the grid of hyperparameters
hidden_layer_sizes = [1,2, 3, 4];
activation_functions = {'logsig', 'tansig', 'purelin'};
training_algorithm = 'trainscg'; % Corrected algorithm
learning_rate = 0.00001; % Fixed learning rate

% Initialize arrays for storing accuracies and other metrics
training_accuracies = zeros(length(activation_functions), length(hidden_layer_sizes));
validation_accuracies = zeros(length(activation_functions), length(hidden_layer_sizes));
testing_accuracies = zeros(length(activation_functions), length(hidden_layer_sizes));
training_precision = zeros(length(activation_functions), length(hidden_layer_sizes));
validation_precision = zeros(length(activation_functions), length(hidden_layer_sizes));
testing_precision = zeros(length(activation_functions), length(hidden_layer_sizes));
training_recall = zeros(length(activation_functions), length(hidden_layer_sizes));
validation_recall = zeros(length(activation_functions), length(hidden_layer_sizes));
testing_recall = zeros(length(activation_functions), length(hidden_layer_sizes));
training_f1 = zeros(length(activation_functions), length(hidden_layer_sizes));
validation_f1 = zeros(length(activation_functions), length(hidden_layer_sizes));
testing_f1 = zeros(length(activation_functions), length(hidden_layer_sizes));
confusion_matrices = cell(length(activation_functions), length(hidden_layer_sizes));

% Iterate over all combinations of hyperparameters
for i = 1:length(activation_functions)
    for k = 1:length(hidden_layer_sizes)
        % Create and train the neural network with current hyperparameters
        net = patternnet(hidden_layer_sizes(k));
        net.layers{1}.transferFcn = activation_functions{i};
        net.trainFcn = training_algorithm;
        % Set learning rate
        net.trainParam.lr = learning_rate;
        % Train the network
        net = train(net, x_train', y_train);

        % Evaluate performance on the training set
        predicted_labels_train = net(x_train');
        [~, predicted_classes_train] = max(predicted_labels_train);
        [~, true_classes_train] = max(y_train); 
        % Compute training metrics
        training_accuracies(i, k) = sum(predicted_classes_train == true_classes_train) / length(predicted_classes_train);
        [training_precision(i, k), training_recall(i, k), training_f1(i, k)] = calculate_metrics(predicted_classes_train, true_classes_train);
        
        % Evaluate performance on the validation set
        predicted_labels_val = net(x_val');
        [~, predicted_classes_val] = max(predicted_labels_val);
        [~, true_classes_val] = max(y_val); 
        % Compute validation metrics
        validation_accuracies(i, k) = sum(predicted_classes_val == true_classes_val) / length(predicted_classes_val);
        [validation_precision(i, k), validation_recall(i, k), validation_f1(i, k)] = calculate_metrics(predicted_classes_val, true_classes_val);
        
        % Evaluate performance on the testing set
        predicted_labels_test = net(x_test');
        [~, predicted_classes_test] = max(predicted_labels_test);
        [~, true_classes_test] = max(y_test); 
        % Compute testing metrics
        testing_accuracies(i, k) = sum(predicted_classes_test == true_classes_test) / length(predicted_classes_test);
        [testing_precision(i, k), testing_recall(i, k), testing_f1(i, k)] = calculate_metrics(predicted_classes_test, true_classes_test);
        
        % Compute confusion matrix for testing set
        if testing_accuracies(i, k) < 1
            confusion_matrices{i, k} = confusionmat(true_classes_test, predicted_classes_test);
        end
    end
end

% Plot the accuracy, precision, recall, and F1-score
figure;
for i = 1:length(activation_functions)
    subplot(4, length(activation_functions), i);
    plot(hidden_layer_sizes, training_accuracies(i, :), '-o', 'DisplayName', 'Training');
    hold on;
    plot(hidden_layer_sizes, validation_accuracies(i, :), '-s', 'DisplayName', 'Validation');
    plot(hidden_layer_sizes, testing_accuracies(i, :), '-^', 'DisplayName', 'Testing');
    xlabel('Hidden Layer Size');
    ylabel('Accuracy');
    title(['Activation: ' activation_functions{i}]);
    legend('Training', 'Validation', 'Testing', 'Location', 'best');
    grid on;

    subplot(4, length(activation_functions), length(activation_functions) + i);
    plot(hidden_layer_sizes, training_precision(i, :), '-o', 'DisplayName', 'Training');
    hold on;
    plot(hidden_layer_sizes, validation_precision(i, :), '-s', 'DisplayName', 'Validation');
    plot(hidden_layer_sizes, testing_precision(i, :), '-^', 'DisplayName', 'Testing');
    xlabel('Hidden Layer Size');
    ylabel('Precision');
    title(['Activation: ' activation_functions{i}]);
    legend('Training', 'Validation', 'Testing', 'Location', 'best');
    grid on;

    subplot(4, length(activation_functions), 2*length(activation_functions) + i);
    plot(hidden_layer_sizes, training_recall(i, :), '-o', 'DisplayName', 'Training');
    hold on;
    plot(hidden_layer_sizes, validation_recall(i, :), '-s', 'DisplayName', 'Validation');
    plot(hidden_layer_sizes, testing_recall(i, :), '-^', 'DisplayName', 'Testing');
    xlabel('Hidden Layer Size');
    ylabel('Recall');
    title(['Activation: ' activation_functions{i}]);
    legend('Training', 'Validation', 'Testing', 'Location', 'best');
    grid on;

    subplot(4, length(activation_functions), 3*length(activation_functions) + i);
    plot(hidden_layer_sizes, training_f1(i, :), '-o', 'DisplayName', 'Training');
    hold on;
    plot(hidden_layer_sizes, validation_f1(i, :), '-s', 'DisplayName', 'Validation');
    plot(hidden_layer_sizes, testing_f1(i, :), '-^', 'DisplayName', 'Testing');
    xlabel('Hidden Layer Size');
    ylabel('F1-score');
    title(['Activation: ' activation_functions{i}]);
    legend('Training', 'Validation', 'Testing', 'Location', 'best');
    grid on;
end

% Display confusion matrix for the best model with accuracy less than 1
best_accuracy = max(max(testing_accuracies));
[best_row, best_col] = find(testing_accuracies == best_accuracy, 1);
if best_accuracy < 1
    fprintf('Best Confusion Matrix (Activation: %s, Hidden Layers: %d, Accuracy: %.4f)\n', ...
        activation_functions{best_row}, hidden_layer_sizes(best_col), best_accuracy);
    disp(confusion_matrices{best_row, best_col});
end

function [precision, recall, f1_score] = calculate_metrics(predicted_classes, true_classes)
    cm = confusionmat(true_classes, predicted_classes);
    num_classes = size(cm, 1);
    precision = zeros(num_classes, 1);
    recall = zeros(num_classes, 1);
    f1_score = zeros(num_classes, 1);
    for i = 1:num_classes
        true_positive = cm(i, i);
        false_positive = sum(cm(:, i)) - true_positive;
        false_negative = sum(cm(i, :)) - true_positive;
        precision(i) = true_positive / (true_positive + false_positive);
        recall(i) = true_positive / (true_positive + false_negative);
        f1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
    end
    % Average precision, recall, and F1-score across all classes
    precision = mean(precision);
    recall = mean(recall);
    f1_score = mean(f1_score);
end
