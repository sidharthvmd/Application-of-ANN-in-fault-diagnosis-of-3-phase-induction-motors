% Load the flattened data
data = readmatrix('flattened_data.csv');


% Define the range for normalization
min_val = min(data(:, 1:90), [], 1); % Minimum value for each column
max_val = max(data(:, 1:90), [], 1); % Maximum value for each column

% Min-max normalization
normalized_data = (data(:, 1:90) - min_val) ./ (max_val - min_val);


% Write the normalized data to a new CSV file
writematrix(normalized_data, 'normalized_data.csv');
