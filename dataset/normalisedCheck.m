% Load the original data
original_data = readmatrix('combined.csv');

% Load the normalized data
normalized_data = readmatrix('normalized_data.csv');

% Extract the first 5 columns from both original and normalized data
original_cols = original_data(:, 1:5);
normalized_cols = normalized_data(:, 1:5);

% Calculate min and max values for each column in normalized data
min_vals_normalized = min(normalized_cols);
max_vals_normalized = max(normalized_cols);

% Check if min and max values are within the expected range [0, 1]
is_normalized = all(min_vals_normalized >= 0 & max_vals_normalized <= 1);

if is_normalized
    disp('Data has been properly normalized.');
else
    disp('Data normalization might have issues.');
end
