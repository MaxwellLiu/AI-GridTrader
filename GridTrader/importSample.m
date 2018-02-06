function trainSample = importSample(filename)
% by Maxwell

fid = fopen(filename);

tline = fgets(fid);
trainSample = cell(1,1);
No = 0;
while ischar(tline)
    No = No + 1;
    thisline = regexp(tline,',','split');
    Len = length(thisline)-1;
    trainSample(No,1:Len) = thisline(2:end);
    tline = fgets(fid);
end
trainSample = str2double(trainSample);
fclose(fid);
end