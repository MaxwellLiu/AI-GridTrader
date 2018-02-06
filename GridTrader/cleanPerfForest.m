function perfForest_cleaned = cleanPerfForest(performanceForest, threshold)
%% delete outlier in performanceForest
% especially outlier positive profit
% by Maxwell

fNo = size(performanceForest,1);
performanceForest1 = performanceForest(:);
if nargin > 1
    newdata = arrayfun(@(x)cleanoutlier(performanceForest1{x}, threshold),1:length(performanceForest1),'UniformOutput',false);
    perfForest_cleaned = reshape(newdata,fNo,size(performanceForest,2));
else
    error('please take SampleQuality for reference')
end
end

function newdata = cleanoutlier(olddata,threshold)
newdata = olddata(olddata <= threshold(2)*3);
end
