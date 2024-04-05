data = readmatrix("randomized_data.csv");
x = data(:,1:90);
y = data(:,91);
% Ensure class labels start from 1
y = y - min(y) + 1;
xt = x';
yt = ind2vec(y');  % Convert class labels to one-hot encoded matrix

% Determine the number of unique classes in your target variable
num_classes = size(yt, 1);  % Number of unique classes is the number of rows in yt

hiddenLayerSize = [8, 8]; % Two hidden layers with 8 nodes each

% Define the neural network architecture
net = patternnet(hiddenLayerSize);

% Set activation function to ReLU for all hidden layers
for j = 1:length(hiddenLayerSize)
    net.layers{j}.transferFcn = 'poslin'; % ReLU activation function
end

% Set activation function of output layer to softmax
net.layers{end}.transferFcn = 'softmax';

% Set training algorithm to Gradient Descent with backpropagation
net.trainFcn = 'traingd';
net.performFcn = 'crossentropy'; % Set the performance function to cross-entropy

% Set learning rate
net.trainParam.lr = 0.01; % Adjust this value as needed

% Training the ANN
[net,tr] = train(net, xt, yt);  

% Predict labels for the training data
predicted_labels = net(xt);

% Convert predicted labels to class indices
[~, predicted_classes] = max(predicted_labels);

% Convert true labels to class indices
[~, true_classes] = max(yt);

% Calculate accuracy
accuracy = sum(predicted_classes == true_classes) / length(true_classes);
disp(accuracy)

% Display confusion matrix
confusion_matrix = confusionmat(true_classes, predicted_classes);
disp('Confusion Matrix:');
disp(confusion_matrix);