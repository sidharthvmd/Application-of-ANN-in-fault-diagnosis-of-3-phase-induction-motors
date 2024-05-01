% Load data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

rng(1); % Set random seed for reproducibility

% Ensure class labels start from 1
y = y - min(y) + 1;

% Convert class labels to one-hot encoded matrix
yt = ind2vec(y');

% Define the number of folds
k = 5;

% Initialize arrays to store evaluation metrics
accuracy_vals = zeros(k, 1);
precision_vals = zeros(k, size(yt, 1));
recall_vals = zeros(k, size(yt, 1));
f1_score_vals = zeros(k, size(yt, 1));

% Perform k-fold cross-validation
cv = cvpartition(size(x, 1), 'KFold', k);

for fold = 1:k
    trainIdx = cv.training(fold);
    testIdx = cv.test(fold);
    
    x_train = x(trainIdx, :);
    y_train = yt(:, trainIdx);
    
    x_test = x(testIdx, :);
    y_test = yt(:, testIdx);

    % Train the neural network model using the training set
    [net,tr] = train(net, x_train', y_train);

    % Test the trained model using the testing set
    predicted_labels_test = net(x_test');
    [~, predicted_classes_test] = max(predicted_labels_test);
    [~, true_classes_test] = max(y_test);

    % Calculate testing accuracy
    accuracy_vals(fold) = sum(predicted_classes_test == true_classes_test) / length(true_classes_test);

    % Calculate confusion matrix for testing data
    confusion_matrix_test = confusionmat(true_classes_test, predicted_classes_test);

    % Calculate precision, recall, and F1-score for each class
    num_classes = size(y_test, 1);

    for i = 1:num_classes
        tp = confusion_matrix_test(i, i);
        fp = sum(confusion_matrix_test(:, i)) - tp;
        fn = sum(confusion_matrix_test(i, :)) - tp;

        % Handle division by zero
        if tp + fp == 0
            precision_vals(fold, i) = 0;
        else
            precision_vals(fold, i) = tp / (tp + fp);
        end

        if tp + fn == 0
            recall_vals(fold, i) = 0;
        else
            recall_vals(fold, i) = tp / (tp + fn);
        end

        % Handle F1-score calculation
        if precision_vals(fold, i) + recall_vals(fold, i) == 0
            f1_score_vals(fold, i) = 0;
        else
            f1_score_vals(fold, i) = 2 * (precision_vals(fold, i) * recall_vals(fold, i)) / (precision_vals(fold, i) + recall_vals(fold, i));
        end
    end
end

% Calculate average evaluation metrics across all folds
avg_accuracy = mean(accuracy_vals);
avg_precision = mean(precision_vals);
avg_recall = mean(recall_vals);
avg_f1_score = mean(f1_score_vals);

disp('Average Accuracy:');
disp(avg_accuracy);
disp('Average Precision:');
disp(avg_precision);
disp('Average Recall:');
disp(avg_recall);
disp('Average F1-score:');
disp(avg_f1_score);
