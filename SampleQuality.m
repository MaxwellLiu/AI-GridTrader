function [X,Y,PR] = SampleQuality(trainSample, varargin)
%% trainSample quality test
% major target test performance.
% delete more than 3 standard deviation PR
% by Maxwell

PR = trainSample(:,end);
PRNum = length(PR);
if nargin < 2
    outlierSDV=3;
    MeanPR = mean(PR);
    StdPR = std(PR);
    ToDelete = (PR - MeanPR)/StdPR > outlierSDV;
    
    scatter(1:PRNum,PR)
    hold on
    plot(ones(PRNum,1)*(MeanPR+outlierSDV*StdPR),'r')
    plot(-ones(PRNum,1)*(MeanPR+outlierSDV*StdPR),'r')
    hold off
    title('SampleQuality')
    
else
    threshold = varargin{1};
    ToDelete = PR > threshold(2)*1.5 | PR < threshold(1)*1.5;
    scatter(1:PRNum,PR,1)
    hold on
    plot(ones(PRNum,1)*threshold(2)*1.5,'r')
    plot(ones(PRNum,1)*threshold(1)*1.5,'r')
    hold off
    title('SampleQuality')
    
end

CreateFileFolder(pwd, 'SampleQuality')
saveas(gcf,['./SampleQuality/' 'trainSample' datestr(now,30) '.jpg'])

trainSample(ToDelete,:) = [];

X = trainSample(:,1:end-2);
Y = trainSample(:,end-1);
PR = trainSample(:,end);


end