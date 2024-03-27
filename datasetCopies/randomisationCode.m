% Define the filenames and the sheet name
filenames = {'ann_dataset_brokenrotorbar.xlsx', 'ann_dataset_overVoltage.xlsx', 'ann_dataset_underVoltage.xlsx', 'ann_dataset_healthy.xlsx', 'ann_dataset_singlePhasingFault.xlsx'};
sheet = 'Sheet1';

% Iterate over each filename
for fileIndex = 1:length(filenames)
    % Load the data from the current Excel file
    filename = filenames{fileIndex};
    data = readtable(filename, 'Sheet', sheet); 
    % Get the number of rows in the data
    numRows = height(data);

    % Calculate the number of groups (assuming each group has 18 rows)
    numGroups = numRows / 18;

    % Generate shuffled indices for groups
    shuffledGroupIndices = randperm(numGroups);

    % Initialize shuffled indices for all rows
    shuffledIndices = zeros(1, numRows);

    % Assign shuffled indices for each group
    for i = 1:numGroups
        shuffledIndices((i - 1) * 18 + 1:i * 18) = (shuffledGroupIndices(i) - 1) * 18 + (1:18);
    end

    % Rearrange the rows of the data according to shuffled indices
    shuffledData = data(shuffledIndices, :);

   % Write the shuffled data back to a CSV file
    [~, name, ~] = fileparts(filename);
    shuffledFilename = fullfile(pwd, [name '_shuffled.csv']);
    writetable(shuffledData, shuffledFilename); 
    disp(['Shuffled data written to ' shuffledFilename]);

    
    disp(['Shuffled data written to ' shuffledFilename]);
end
