function Forest = growForest(TreeGrid)
% by Maxwell

obj.x = TreeGrid.x;
obj.y = TreeGrid.y;
obj.pr = TreeGrid.pr;
obj.Parameter = TreeGrid.Parameter;

Param = obj.Parameter;
Param.rdRatioTrain=3;
Param.votingPassRate = 0.1;
TreeNode = TreeGrid.TreeNode;
PR = TreeGrid.pr;
labelMax = length(TreeGrid.y);

TNum = length(TreeNode);
noTreesInForest = Param.noTreesInForest;
noSelectedForest = Param.noSelectedForest;
Forest = cell(1,4);
ForestNum = 0;
if TNum < noTreesInForest
    Forest = [];
else
    for cycleSample=1:noSelectedForest
        [SelectForest,Perfmance,TreeLabel] = growForestFunc(TreeNode, obj, labelMax);
        isTreeHasBeenSelect0 = isTreeHasBeenSelect(Forest(:,3),TreeLabel);
        if ~isempty(SelectForest) && ~isTreeHasBeenSelect0
            ForestNum = ForestNum + 1;
            Forest{cycleSample,1} = SelectForest;
            Forest{cycleSample,2} = Perfmance;
            Forest{cycleSample,3} = TreeLabel;
            Forest{cycleSample,4} = obj.Parameter;
        end
    end
    Forest(cellfun(@isempty,Forest(:,3)),:) = [];
end
end

function [SelectForest,Perfmance,TreeLabel] = growForestFunc(TreeNode, obj, labelMax)

Param = obj.Parameter;
PR = obj.pr;
noTreesInForest = Param.noTreesInForest;
rdRatioTrain = Param.rdRatioTrain;
votingPassRate = Param.votingPassRate;

[thisTreeNode,TreeLabel] = randomTree(TreeNode, noTreesInForest);
[TreeMatrix,PerfMatrix] = transfer(obj, thisTreeNode, labelMax);% be careful: the memory problem
HasTradingTreeMatrix = TreeMatrix > 0;
TradingForest = sum(HasTradingTreeMatrix,2);
VotingRate = TradingForest / noTreesInForest;
SelectTradingForest = VotingRate > votingPassRate;
Perfmance = PR(SelectTradingForest);
rd = sum(Perfmance) / MaxDrawdown(Perfmance);

if rd > rdRatioTrain
    SelectForest = thisTreeNode;
else
    SelectForest = [];
end

end

function [thisTreeNode,TreeLabel] = randomTree(TreeNode, noTreesInForest)
dimension = size(TreeNode,1);
a = randperm(dimension);
sorta = sort(a(1:noTreesInForest));
thisTreeNode = TreeNode(sorta,:);

TreeLabel = (1:dimension)';
TreeLabel = TreeLabel(sorta);

end

function [TreeMatrix,PerfMatrix] = transfer(obj, thisTreeNode, labelMax)

TreeNum = length(thisTreeNode);
TreeMatrix = zeros(labelMax,TreeNum);
PerfMatrix = zeros(labelMax,TreeNum);

for i=1:TreeNum
    for j=1:length(thisTreeNode{i})
        [labelAll,Perf,isNodeRight] = nodePerformance(obj,thisTreeNode{i}{1,j});
        if ~isNodeRight
            error('something error')
        end
        TreeMatrix(labelAll,i) = i;
        PerfMatrix(labelAll,i) = Perf;
    end
end
end

function isTreeHasBeenSelect0 = isTreeHasBeenSelect(TreeLabelAll,TreeLabel)
isTreeHasBeenSelect0 = false;
if ~isempty(TreeLabelAll{1,1})
    TreeLabelAll = cell2mat(TreeLabelAll);
    rowT = size(TreeLabel,1);
    colT = size(TreeLabelAll,1)/rowT;
    TreeLabelAll = reshape(TreeLabelAll,rowT,colT);
    tempTreeLabel = ~abs(TreeLabelAll - repmat(TreeLabel,1,colT)) < 0.001;
    if ~all(sum(tempTreeLabel))
        isTreeHasBeenSelect0 = true;
    end
end
end
