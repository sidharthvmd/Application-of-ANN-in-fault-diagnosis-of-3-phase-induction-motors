% Load data
data = readmatrix("randomized_data.csv");
x = data(:, 1:90);
y = data(:, 91);

% Ensure class labels start from 1
y = y - min(y) + 1;

% Convert class labels to one-hot encoded matrix
yt = ind2vec(y');

% Define the neural network architecture
hiddenLayerSize = [2,2]; % Two hidden layers, each containing two neurons 
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
net.trainParam.lr = 0.0001; % Learning rate

% Training the ANN
[net,tr] = train(net, x', yt);

% Predict labels for the training data
predicted_labels = net(x');
[~, predicted_classes] = max(predicted_labels);
[~, true_classes] = max(yt);

% Calculate accuracy
accuracy = sum(predicted_classes == true_classes) / length(true_classes);
disp('Accuracy:');
disp(accuracy);

% Display confusion matrix
confusion_matrix = confusionmat(true_classes, predicted_classes);
disp('Confusion Matrix:');
disp(confusion_matrix);
