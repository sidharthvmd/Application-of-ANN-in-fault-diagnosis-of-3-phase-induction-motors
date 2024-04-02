% Assuming 'normalized_data' contains your normalized dataset

normalized_data = readmatrix('normalized_data.csv');

% Compute minimum and maximum values for each column
min_values = min(normalized_data);
max_values = max(normalized_data);

% Check if all minimum values are >= 0 and all maximum values are <= 1
is_normalized = all(min_values >= 0) && all(max_values <= 1);

if is_normalized
    disp('Data is normalized.');
else
    disp('Data is not normalized.');
end
