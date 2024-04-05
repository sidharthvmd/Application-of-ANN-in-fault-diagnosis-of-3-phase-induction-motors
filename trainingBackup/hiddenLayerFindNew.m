data = readmatrix("randomized_data.csv");
x = data(:,1:90);
y = data(:,91);

xt = x';
yt = y';

num_hidden_layers = 450;
accuracy_train = zeros(1,num_hidden_layers);
accuracy_val = zeros(1,num_hidden_layers);

% Determine the number of unique classes in your target variable
num_classes = numel(unique(y'));


for i = 1:num_hidden_layers 
    % defining the architecture of the ANN
    hiddenLayerSize = i;  
    net = patternnet(hiddenLayerSize); % Use patternnet for classification
    net.divideParam.trainRatio = 70/100; 
    net.divideParam.valRatio = 30/100; 
    net.divideParam.testRatio = 0/100; 
    
    % Set activation function to ReLU for all hidden layers
    for j = 1:length(net.layers)-1
        net.layers{j}.transferFcn = 'poslin'; % ReLU activation function
    end
    
    % Set activation function of output layer to softmax
    net.layers{end}.transferFcn = 'softmax';

    % Set the number of output neurons to match the number of classes
    net.layers{end}.size = num_classes;

    % Set training algorithm to Gradient Descent with backpropagation
    net.trainFcn = 'traingd';
    net.performFcn = 'crossentropy'; % Set the performance function to cross-entropy

    %  learning rate
    net.trainParam.lr = 0.000001; % Adjust this value as needed

    % training the ANN
    [net,tr] = train(net, xt, yt);  

    % determine the output of the ANN
    yTrain = round(net(xt(:, tr.trainInd))); 
    yVal = round(net(xt(:,tr.valInd)));

   
    % Calculate training and validation accuracies
    accuracy_train(i) = sum(yTrain == yTrainTrue) / length(yTrainTrue); 
    accuracy_val(i) = sum(yVal == yValTrue) / length(yValTrue); 
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