% Load the CSV file
data = readmatrix('combined.csv');

% Extract the first 5 columns as only the first 5 columns are the input
% features and require normalization
cols_to_normalize = data(:, 1:5);

% Calculate min and max values for each column. min-max normalization used.
% min_vals and max_vals are arrays with minimum and maximum values of each
% column
min_vals = min(cols_to_normalize);
max_vals = max(cols_to_normalize);

% Perform min-max normalization
normalized_data = (cols_to_normalize - min_vals) ./ (max_vals - min_vals);

% Replace the first 5 columns in the original data with the normalized values
data(:, 1:5) = normalized_data;

% Write the normalized data back to a CSV file
writematrix(data, 'normalized_data.csv');
