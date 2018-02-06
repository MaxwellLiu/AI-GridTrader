function Tree = getTree(TreePath,Folder)
% by Maxwell

thispath = fullfile(TreePath,Folder);
FileName = getFilename(thispath);
if ~isempty(FileName) && ismember(FileName,'Tree.mat')
    load(fullfile(fullfile(TreePath,Folder),'Tree.mat'))
else
    Tree = [];
end
end