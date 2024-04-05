data = readmatrix("randomized_data.csv");
x = data(:,1:90);
y = data(:,91);
% Ensure class labels start from 1
y = y - min(y) + 1;
xt = x';
yt = ind2vec(y');  % Convert class labels to one-hot encoded matrix

num_hidden_layers = 50;
accuracy_train = zeros(1,num_hidden_layers);
accuracy_val = zeros(1,num_hidden_layers);

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
    [net,tr] = train(net, xt, yt);  

    % Determine the output of the ANN
    yTrainProb = net(xt(:, tr.trainInd)); 
    yValProb = net(xt(:,tr.valInd));

   % Convert probabilities to class indices
    [~, yTrainIndex] = max(yTrainProb);
    [~, yValIndex] = max(yValProb); 

    % Convert one-hot encoded true labels to class indices
    trueTrainIndex = vec2ind(yt(:, tr.trainInd));
    trueValIndex = vec2ind(yt(:,tr.valInd));

    % Calculate training and validation accuracies
    accuracy_train(i) = sum(yTrainIndex == trueTrainIndex) / length(tr.trainInd); 
    accuracy_val(i) = sum(yValIndex == trueValIndex) / length(tr.valInd); 

    disp(i)
end

% Plot both training and validation accuracies for different number of hidden layers
figure;
plot(1:num_hidden_layers, accuracy_train, 'b', 'LineWidth', 2);
hold on;
plot(1:num_hidden_layers, accuracy_val, 'r', 'LineWidth', 2);
xlabel('Number of Hidden Layers');
ylabel('Accuracy');
title('Accuracy vs Number of Hidden Layers');
legend('Training Set', 'Validation Set');
grid on;
