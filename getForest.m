function Forest = getForest(ForestPath,Folder)
% by Maxwell

thispath = fullfile(ForestPath,Folder);
FileName = getFilename(thispath);
if ~isempty(FileName) && ismember(FileName,'Forest.mat')
    load(fullfile(thispath,'Forest.mat'))
else
    Forest = [];
end
end