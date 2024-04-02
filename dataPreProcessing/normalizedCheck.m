% Assuming 'normalized_data' contains your normalized dataset
normalized_data = readmatrix('normalized_data.csv');

% Define the range of columns to consider (e.g., first 90 columns)
num_columns_to_check = 90;
columns_to_check = 1:num_columns_to_check;

% Extract data for the specified columns
data_to_check = normalized_data(:, columns_to_check);

% Compute minimum and maximum values for each column
min_values = min(data_to_check);
max_values = max(data_to_check);

% Check if all minimum values are >= 0 and all maximum values are <= 1
is_normalized = all(min_values >= 0) && all(max_values <= 1);

if is_normalized
    disp('Data is normalized within the first 90 columns.');
else
    disp('Data is not normalized within the first 90 columns.');
end
