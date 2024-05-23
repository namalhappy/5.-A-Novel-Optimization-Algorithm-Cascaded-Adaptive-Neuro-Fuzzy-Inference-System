function fis=CreateANFIS(input,outputs,mfType,mfNum,epoch)

    x=input;
    t=outputs;

    genopt = genfisOptions('GridPartition');
    
    genopt.NumMembershipFunctions = mfNum;
    genopt.InputMembershipFunctionType = mfType;

    inFIS = genfis(x,t,genopt);
    opt = anfisOptions('InitialFIS',inFIS);
    opt.DisplayANFISInformation = 1;
    opt.DisplayErrorValues = 1;
    opt.DisplayStepSize = 0;
    opt.DisplayFinalResults = 1;
    opt.EpochNumber= epoch;

    fis = anfis([x t],opt);
    %plotmf(fis,'input',1) 


end