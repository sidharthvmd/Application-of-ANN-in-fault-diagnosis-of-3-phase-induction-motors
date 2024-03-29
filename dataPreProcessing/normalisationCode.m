% Load the flattened data
flattened_data = readmatrix('flattened_data.csv');

% Get the number of samples and features
[num_samples, num_features] = size(flattened_data);

% Define the indices of input features (first 90 columns)
input_indices = 1:90;

% Calculate the minimum and maximum values for each input feature
min_values = min(flattened_data(:, input_indices));
max_values = max(flattened_data(:, input_indices));

% Apply min-max normalization to input features only
normalized_data = flattened_data;
for i = input_indices
    min_val = min_values(i);
    max_val = max_values(i);
    range = max_val - min_val;
    % Apply min-max normalization to each input feature
    normalized_data(:, i) = (flattened_data(:, i) - min_val) / range;
end

% Write the normalized data to a new CSV file
writematrix(normalized_data, 'normalized_data.csv');
