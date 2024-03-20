filenames = {'ann_dataset_brokenrotorbar.xlsx', 'ann_dataset_overVoltage.xlsx', 'ann_dataset_underVoltage.xlsx', 'ann_dataset_healthy.xlsx'};
sheet = 'Sheet1'; 

for index = 1:length(filenames)
    % Read data from Excel file
    dataTable = readtable(filenames{index}, 'Sheet', sheet);
    
    % Convert table to array
    data = table2array(dataTable);

    % Normalize the data
    normalized_data = (data - min(data(:))) / (max(data(:)) - min(data(:)));

    % Write normalized data back to the same Excel sheet
    dataTable{:, :} = normalized_data; % Update table with normalized data

    writetable(dataTable, filenames{index}, 'Sheet', sheet, 'Range', 'A1');

    disp(['Data normalized and written back to Excel for filename: ', filenames{index}]);
end

disp('Completed normalization of all Excel files.');


