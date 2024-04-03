data = readmatrix("training\randomized_data.csv");
x = data(:,1:90);
y = data(:,91);
m = length (yt);

xt = x';
yt = y';


num_hidden_layers = 20;
rmse_train = zeros(1,num_hidden_layers);
rmse_val = zeros(1,num_hidden_layers);

for i = 1:num_hidden_layers 
    % defining the architecture of the ANN
    hiddenLayerSize = i;  
    net = fitnet(hiddenLayerSize); 
    net.divideParam.trainRatio = 70/100; 
    net.divideParam.valRatio = 30/100; 
    net.divideParam.testRatio = 0/100; 
    
    % Set activation function to ReLU for all hidden layers
    for j = 1:length(net.layers)-1
        net.layers{j}.transferFcn = 'poslin'; % ReLU activation function
    end
    
    % Set training algorithm to Gradient Descent with backpropagation
    net.trainFcn = 'traingd';

    % training the ANN
    [net,tr] = train(net, xt, yt);  

    % determine the error of the ANN
    yTrain = round(net(xt(:, tr.trainInd))); 
    yVal = round(net(xt(:,tr.valInd)));

    yTrainTrue = round(yt(tr.trainInd)); 
    yValTrue = round(yt(tr.valInd));

    % Calculate RMSE
    rmse_train(i) = sqrt(mean((yTrain - yTrainTrue).^2));  % RMSE of training set
    rmse_val(i) = sqrt(mean((yVal - yValTrue).^2));  % RMSE of validation set
    disp(i)
end


% Plot RMSE for different number of hidden layers
figure;
plot(1:num_hidden_layers, rmse_train, 'b', 'LineWidth', 2);
hold on;
plot(1:num_hidden_layers, rmse_val, 'r', 'LineWidth', 2);
xlabel('Number of Hidden Layers');
ylabel('RMSE');
title('RMSE vs Number of Hidden Layers');
legend('Training Set', 'Validation Set');
grid on;