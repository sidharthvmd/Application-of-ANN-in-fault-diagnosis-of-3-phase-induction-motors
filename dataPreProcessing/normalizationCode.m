% Load the flattened data
data = readmatrix('flattened_data.csv');

% Extract the 91st column without normalization
column_91 = data(:, 91);

% Define the range for normalization
min_val = min(data(:, 1:90), [], 1); % Minimum value for each column
max_val = max(data(:, 1:90), [], 1); % Maximum value for each column

% Min-max normalization
normalized_data = (data(:, 1:90) - min_val) ./ (max_val - min_val);

% Concatenate the normalized data with the 91st column
normalized_data_with_column_91 = [normalized_data, column_91];

% Write the normalized data with the 91st column to a new CSV file
writematrix(normalized_data_with_column_91, 'normalized_data.csv');

