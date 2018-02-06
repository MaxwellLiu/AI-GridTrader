%% building tree using grid
% by Maxwell
clear
% ParallelTool

initialClass = Initial;
Param = initialClass.ExperimentParameters;

dataPath = '.\Model_Based\SampleForMatlab';
parameter = importParameter(fullfile(dataPath,'Parameter.csv'));

threshold = [-initialClass.StandardParameters.CONS_SL(parameter.IdxSelectedSLSP+1) initialClass.StandardParameters.CONS_SP(parameter.IdxSelectedSLSP+1)];

trainPath = fullfile(dataPath, 'train');
Folder = getFilename(trainPath,2);
TrainNum = length(Folder);

CreateFileFolder(dataPath,'TreeGrid')
for i=1:TrainNum
    CreateFileFolder(fullfile(dataPath,'TreeGrid'),Folder{i})
end

tic
for i=1:TrainNum
    TreeParam = Folder{i};
    trainSample = importSample(fullfile(trainPath,TreeParam,'trainSample.csv'));
    [X,Y,PR] = SampleQuality(trainSample, threshold);
    
    Tree = TreeGrid(Param, X, Y, PR);
    save(fullfile(dataPath,'TreeGrid',Folder{i},'Tree'),'Tree')
    toc
end

