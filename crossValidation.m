%% train to validation and simulink
%% validation
% by Maxwell

clear
ParallelTool

FatherPath = 'G:\Model_Based\SampleForMatlab';

parameter = importParameter(fullfile(FatherPath,'Parameter.csv'));
initialClass = Initial;
threshold = [-initialClass.StandardParameters.CONS_SL(parameter.IdxSelectedSLSP+1) initialClass.StandardParameters.CONS_SP(parameter.IdxSelectedSLSP+1)];

valpath = fullfile(FatherPath,'val');
simpath = fullfile(FatherPath,'sim');
ForestPath = fullfile(FatherPath,'Forest');

CreateFileFolder(FatherPath,'SearchedForest')
SearchedForestPath = fullfile(FatherPath,'SearchedForest');

%% 
Folder = getFilename(ForestPath,2);

cycleNum = length(Folder);
perfVal = cell(cycleNum,1);
ForestTobeSelect = cell(1,6);
FTNo = 0;
for i=1:cycleNum
    disp(['CV-Progress£º' num2str(i) '/' num2str(cycleNum)])
    Forest = getForest(ForestPath,Folder{i});
    if isempty(Forest)
        continue
    end
    perftrainForest = Forest(:,2);
    
    %% validation
    valSample = importfile20160705(fullfile(valpath,Folder{i},'trainSample.csv'), 1, 1000000);
    %valSample = importSample(fullfile(valpath,Folder{i},'trainSample.csv'));
    obj.x = valSample(:,1:end-2);
    obj.y = valSample(:,end-1);
    obj.pr = valSample(:,end);
    ForestNo = size(Forest,1);
    perfvalForest = cell(ForestNo,1);
    parfor j=1:ForestNo
        perfvalForest0 = predictForest(Forest(j,:), obj);
        % perfInc = sum(performValForest)/MaxDrawdown(performValForest);
        perfvalForest{j,1} = perfvalForest0;
    end
    
    %% simulink
    simSample = importfile20160705(fullfile(simpath,Folder{i},'trainSample.csv'), 1, 1000000);
    %simSample = importSample(fullfile(simpath,Folder{i},'trainSample.csv'));
    obj.x = simSample(:,1:end-2);
    obj.y = simSample(:,end-1);
    obj.pr = simSample(:,end);
    perfsimForest = cell(ForestNo,1);
    parfor j=1:ForestNo
        perfsimForest0 = predictForest(Forest(j,:), obj);
        perfsimForest{j,1} = perfsimForest0;
    end
    
    performanceForest = [perftrainForest perfvalForest perfsimForest];
    perfForest_cleaned = cleanPerfForest(performanceForest, threshold);
    perfForestIndc = K3Fold(perfForest_cleaned);
    thisSelect = (perfForestIndc(:,2)>=2 & perfForestIndc(:,3)>=2);
    if sum(thisSelect) > 0
        ForestTobeSelect(FTNo+1:FTNo+sum(thisSelect),1) = Folder(i);
        ForestTobeSelect(FTNo+1:FTNo+sum(thisSelect),2:end) = [Forest(thisSelect,[1 4]) perfForest_cleaned(thisSelect,:) ];
        FTNo = FTNo+sum(thisSelect);
    end
end

save ForestTobeSelect ForestTobeSelect
writeTotxt(SearchedForestPath, ForestTobeSelect, parameter)
