%Load the normalized data 
data_matrix = readmatrix('normalized_data.csv');  

% Shuffle the rows
data_matrix_shuffled = data_matrix(randperm(size(data_matrix, 1)), :); 
writematrix(data_matrix_shuffled, 'randomized_data.csv');


