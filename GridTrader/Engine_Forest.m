%% growForest
% by Maxwell

clear
% ParallelTool

dirpath = '\Model_Based\SampleForMatlab';
TreePath = fullfile(dirpath,'TreeGrid');
ForestPath = fullfile(dirpath,'Forest');
Folder = getFilename(TreePath,2);

cycleNum = length(Folder);

CreateFileFolder(dirpath,'Forest')
for i=1:cycleNum
    CreateFileFolder(ForestPath,Folder{i})
end

parfor i=1:cycleNum
    disp(['Forest-Progress£º' num2str(i) '/' num2str(cycleNum)])
    Tree = getTree(TreePath,Folder{i});
    if isempty(Tree)
        continue
    end
    Forest = growForest(Tree);
    if ~isempty(Forest)
        parsave(fullfile(ForestPath,Folder{i},'Forest.mat'),Forest)
    end
    % clear Tree Forest
end
