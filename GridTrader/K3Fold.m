function perfForestIndc = K3Fold(performanceForest)
%% performanceForest include 3 column: train performance\val performance\test performance
% one row means one strategy
% by Maxwell

fNo = size(performanceForest,1);
performanceForest1 = performanceForest(:);
perfIndc = arrayfun(@(x)ProfitToDrawdown(performanceForest1{x}),1:length(performanceForest1));
perfForestIndc = reshape(perfIndc,fNo,size(performanceForest,2));

end