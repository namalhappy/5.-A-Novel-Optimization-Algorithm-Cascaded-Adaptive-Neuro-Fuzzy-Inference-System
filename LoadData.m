
function data=LoadData(name,opt)    

    if opt == 1 %% Initial data preparing. (Split data to train and test Randomly (70% -30%) ) 
        dataraw=load(name);

        Inputs=dataraw(:,1:end-1);
        Targets=dataraw(:,end);
    
        nSample=size(Inputs,1);
        nInputs=size(Inputs,2);
    
        % Shuffle Data
        S=randperm(nSample);
        Inputs=Inputs(S,:);
        Targets=Targets(S,:);    
      
        % Train Data
        pTrain=0.7;
        nTrain=round(pTrain*nSample);
        TrainInputs=Inputs(1:nTrain,:);
        TrainTargets=Targets(1:nTrain,:);
        Train_data = [TrainInputs TrainTargets];

        % Test Data
        
        TestInputs=Inputs(nTrain+1:end,:);
        TestTargets=Targets(nTrain+1:end,:);
        Test_data = [TestInputs TestTargets];

        % Export
        data.TrainInputs=TrainInputs;
        data.TrainTargets=TrainTargets;
        data.TestInputs=TestInputs;
        data.TestTargets=TestTargets;
        data.nInputs = nInputs;
        data.nSample = nSample;   

        % Save train.csv and test.csv for reproductability
        writematrix(Train_data,'Dataset/train.csv','Delimiter',','); 
        writematrix(Test_data,'Dataset/test.csv','Delimiter',','); 

    elseif  opt == 2 %% Load level output data as inputs (using only train set)

        dataraw=load(name);
        
        Inputs=dataraw(:,1:end-1);
        Targets=dataraw(:,end);
    
        nSample=size(Inputs,1);
        nInputs=size(Inputs,2);
    
        %Export
        data.TrainInputs=Inputs;
        data.TrainTargets=Targets;
        data.nInputs = nInputs;
        data.nSample = nSample;        

    elseif  opt == 3 %% Load level output data as inputs (using only test set)

        dataraw=load(name);
        
        Inputs=dataraw(:,1:end-1);
        Targets=dataraw(:,end);
    
        nSample=size(Inputs,1);
        nInputs=size(Inputs,2);
    
        %Export
        data.TestInputs=Inputs;
        data.TestTargets=Targets;
        data.nInputs = nInputs;
        data.nSample = nSample;         
    end 
    
end
