% Load the CSV file
data = readmatrix('combined.csv'); % Replace 'your_file.csv' with the actual filename

[num_samples, num_columns] = size(data); % Get the number of samples and columns

% Calculate the number of samples (assuming each sample has 18 rows)
num_samples = num_samples / 18;

% Initialize a matrix to store flattened samples
flattened_data = zeros(num_samples, 18*5+1);

% Iterate over each sample
for i = 1:num_samples
    % Get the start and end indices of the current sample
    start_index = (i-1)*18 + 1;
    end_index = i*18;
    
    % Extract the data for the current sample
    sample_data = data(start_index:end_index, :);
    
    % Reshape the sample data into a 1D array
    flattened_input = reshape(sample_data(:, 1:5).', 1, []);
    
    % Store the flattened sample along with the output value
    flattened_data(i, :) = [flattened_input, sample_data(1, 6)]; % Assuming the output value is in the 6th column
end

% Write the flattened data to a new CSV file
writematrix(flattened_data, 'flattened_data.csv');
