function [labelAll,Perf,isNodeRight] = nodePerformance(obj,TreeNode,checkNodeornot)
% by Maxwell

x = obj.x;
pr = obj.pr;
IdxInterval = obj.Parameter.IdxInterval;

X = x(:,TreeNode.IndItem);
LB = TreeNode.LB * 200/IdxInterval - 100;
UB = TreeNode.UB * 200/IdxInterval - 100;

if LB(1) == -100
    isCondition = X(:,1) >= LB(1) & X(:,1) <= UB(1);
else
    isCondition = X(:,1) > LB(1) & X(:,1) <= UB(1);
end

for i=2:size(X,2)
    if LB(i) == -100
        isCondition = isCondition & (X(:,i) >= LB(i) & X(:,i) <= UB(i));
    else
        isCondition = isCondition & (X(:,i) > LB(i) & X(:,i) <= UB(i));
    end
end
% Selectedx = X(isCondition,:);

labelAll = find(isCondition);

Perf = pr(isCondition,:);
labelTree = TreeNode.label;

isNodeRight = true;
if nargin > 2 && checkNodeornot
    if ~all(ismember(labelTree,labelAll))
        isNodeRight = false;
    end
end