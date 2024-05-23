clc;
clear;
close all;
warning('off','all');

DataFile = 'Dataset/iris.csv';
DataFileTemp = 'temp.csv';

%% Global variables
mfNum = 3;
mfType = "gaussmf";
maxLevels = 10;
epoch = 100;
PairingMethod = 1;
num_inputs = 4;


%% Training
for i=1:maxLevels
    if i == 1
        %% Load Initial Data
        data=LoadData(DataFile,1);
    else        
        %% Load previous level output data
        DataFile = append('Outputs\Train\Level_',int2str(i-1),'.csv');        
        data=LoadData(DataFile,2);
    end
    %% Casaceded ANFIS STEP 1 : Pairing
    if PairingMethod == 1  % Random Pairing
        x = data.nInputs;
        for input = 1:x
            y = setdiff(1:x, input);
            r = y(randi(numel(y)));   
            pair =  [input r];
            %% Casaceded ANFIS STEP 2 : Training 
            fis=CreateANFIS(data.TrainInputs(:,pair),data.TrainTargets,mfType,mfNum,epoch);
            output = evalfis (fis,data.TrainInputs(:,pair));
            
            if input == 1
                out = output;
            else
                out = horzcat(out,output);
            end

            %% Save FIS and Pair information for testing            
            FISfn = append('FIS\FIS_',int2str(i),'_',int2str(input));
            Pairfn = append('PAIRS\PAIRS_',int2str(i),'_',int2str(input));
        
            save(Pairfn,"pair")
            writeFIS(fis,FISfn);             
        end

        %% Save previous level output
        out = horzcat(out,data.TrainTargets);
        OutFile = append('Outputs\Train\Level_',int2str(i),'.csv');
        writematrix(out,OutFile,'Delimiter',','); % write temp csv (previouse outputs of each ANFIS)
        
    end
end

TestDataFile = 'Dataset\test.csv';

%% Testing 
for i=1:maxLevels
    if i == 1
        %% Load Initial Data
        data=LoadData(TestDataFile, 3);
    else
        %% Load Temp Data
        DataFileTemp = append('Outputs\Test\Level_',int2str(i-1),'.csv');
        data=LoadData(DataFileTemp, 3);
    end
    %% Casaceded ANFIS STEP 1 : Pairing
    if PairingMethod == 1  % Random Pairing
        x = data.nInputs;
        for input = 1:x
            % file name generation
            chr1 = int2str(i);
            chr2 = int2str(input);
            Pairfn = append('PAIRS\PAIRS_',chr1,'_',chr2);   
            FISfn = append('FIS\FIS_',chr1,'_',chr2,'.fis');

            % Load the MAT file
            pair = load(Pairfn);
            fis  = readfis(FISfn);

            output = evalfis (fis,data.TestInputs(:,pair.pair));      
            
            
            if input == 1
                testout = output;
            else
                testout = horzcat(testout,output);
            end
           
        end

        %% Save previous level output
        testout = horzcat(testout,data.TestTargets);
        OutFile = append('Outputs\Test\Level_',int2str(i),'.csv');
        writematrix(testout,OutFile,'Delimiter',','); % write temp csv (previouse outputs of each ANFIS)
        %disp(out);
    end
end

%% Evaluate Results

disp(testout(:, 1:num_inputs))
% Calculate the average of the first n columns
average = mean(testout(:, 1:num_inputs), 2); % Calculate mean along the rows
rounded_average = round(average, 0);

disp([rounded_average,data.TestTargets]);

% Calculate the accuracy
correct_predictions = rounded_average == data.TestTargets;
accuracy = sum(correct_predictions) / numel(correct_predictions) * 100;

% Calculate the confusion matrix
conf_mat = confusionmat(data.TestTargets, rounded_average);

% Plot the confusion matrix
figure;
confusionchart(conf_mat);
title('Confusion Matrix');
xlabel('Predicted Label');
ylabel('True Label');

% Save the plot as an image
saveas(gcf, 'Results/confusion_matrix.png');

% Display the accuracy
disp(['Accuracy: ', num2str(accuracy), '%']);

