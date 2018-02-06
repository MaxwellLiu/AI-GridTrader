function parameter = importParameter(filename)
% by Maxwell

fid = fopen(filename);

tline = fgets(fid);
gridcontent = cell(1,1);
cellNo = 0;
while ischar(tline)
    contractinf = strfind(tline,'contract');
    if ~isempty(contractinf)
        contractinf2 = regexp(tline,':');
        parameter.contractKeys = tline(contractinf2+1:end-2);
    end
    
    DTinf = strfind(tline,'direction');
    if ~isempty(DTinf)
        contractinf2 = regexp(tline,':');
        parameter.direction = str2double(tline(contractinf2+1:end-2));
    end
    
    spsllocinf = strfind(tline,'spslloc');
    if ~isempty(spsllocinf)
        spsllocinf2 = regexp(tline,':');
        parameter.IdxSelectedSLSP = str2double(tline(spsllocinf2+1:end));
    end
    
    IdxSelectedScreenerinf = strfind(tline,'IdxSelectedScreener');
    if ~isempty(IdxSelectedScreenerinf)
        IdxSelectedScreenerinf1 = regexp(tline,':');
        IdxSelectedScreenerinf2 = tline(IdxSelectedScreenerinf1+1:end-2);
        temp1 = regexp(IdxSelectedScreenerinf2,',','split');
        parameter.IdxSelectedScreener = str2double(temp1);
    end
    
    
    spslinfinf = strfind(tline,'spslinf');
    if ~isempty(spslinfinf)
        spslinfinf1 = regexp(tline,':');
        spslin2 = tline(spslinfinf1+1:end-2);
        cellNo = cellNo + 1;
        gridcontent(cellNo,1) = {spslin2};
    end
    
    Idcinf = strfind(tline,'Idc');
    if ~isempty(Idcinf)
        cellNo = cellNo + 1;
        gridcontent(cellNo,1) = {tline(1:end-2)};
    end
    
    tline = fgets(fid);
end
parameter.gridcontent = gridcontent;
fclose(fid);

end