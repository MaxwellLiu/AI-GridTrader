function performanceForest = predictForest(Forest, obj)
% by Maxwell

Param = Forest{1,4};
Tree = Forest{1,1};
obj.Parameter = Param;

votingrate = Param.votingPassRate;
TreeNo = length(Tree);
labelMax = size(obj.x,1);

TreeMatrix = zeros(labelMax,TreeNo);
PerfMatrix = zeros(labelMax,TreeNo);

for i=1:TreeNo
    thisTree = Tree{i,1};
    for j=1:length(thisTree)
        [labelAll,Perf,~] = nodePerformance(obj,thisTree{1,j},false);
        TreeMatrix(labelAll,i) = i;
        PerfMatrix(labelAll,i) = Perf;
    end
end

HasTradingTreeMatrix = TreeMatrix > 0;
TradingForest = sum(HasTradingTreeMatrix,2);
VotingRate = TradingForest / TreeNo;
SelectTradingForest = VotingRate > votingrate;
performanceForest = obj.pr(SelectTradingForest);

end

