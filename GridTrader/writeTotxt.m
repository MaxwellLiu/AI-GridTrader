function writeTotxt(SearchedForestPath, ForestTobeSelect, parameter)
%% output MATLAB Engine result to Trading system
% by Maxwell

ForestTobeSelect = sortrows(ForestTobeSelect,1);
CreateFileFolder(SearchedForestPath,'Grid')
CreateFileFolder(SearchedForestPath,'Tree')
CreateFileFolder(SearchedForestPath,'Forest')
GridFolder = fullfile(SearchedForestPath,'Grid');
TreeFolder = fullfile(SearchedForestPath,'Tree');
ForestFolder = fullfile(SearchedForestPath,'Forest');

Num = size(ForestTobeSelect,1);
direction = parameter.direction;
contract = parameter.contractKeys;
spslloc = parameter.IdxSelectedSLSP;
IdxSelectedScreener = parameter.IdxSelectedScreener;
gridcontent = parameter.gridcontent;
spslinf = gridcontent{1,1};
GridContent = gridcontent(2:end,:);
for i=1:Num
    crossInf = ForestTobeSelect{i,1};
    loc = regexp(crossInf,'_','split');
    indicator = loc(1);
    entryindicator = (IdxSelectedScreener == str2double(indicator{1}));
    cpvalue = loc(2);
    cpvalue = cpvalue{1};
    if i >1 && strcmp(crossInf,ForestTobeSelect{i-1,1})
        forestnameNo = forestnameNo+1;
    else
        forestnameNo=0;
    end
    votingrate = ForestTobeSelect{i,3}.votingPassRate;
    IdxInterval = ForestTobeSelect{i,3}.IdxInterval;
    %forestname = ['Forest_direction_' crossInf '_' num2str(forestnameNo)];
    forestname = standnaming_Forest(standname, direction, crossInf, forestnameNo);
    fileForest = fopen(fullfile(ForestFolder,[forestname '.csv']),'w');
    fprintf(fileForest,'%s,%f\n','VotingPassRate',votingrate);
    for j=1:size(ForestTobeSelect{i,2},1)
        if forestnameNo > 0
            treenameNo = treenameNo + 1;
        else
            treenameNo = j;
        end
        %TreeName = ['Tree_direction_' crossInf '_' num2str(treenameNo) ];
        TreeName = standnaming_Tree(standname, direction, crossInf, treenameNo);
        fprintf(fileForest,'%d,%s\n',j-1,TreeName);
        
        fileTree = fopen(fullfile(TreeFolder,[TreeName '.csv']),'w');
        thisTree = ForestTobeSelect{i,2}{j,1};
        for g=1:length(thisTree)
            thisGrid = thisTree{g};
            % GridName = ['Grid_direction_' crossInf '_' num2str(treenameNo) ];
            GridName = standnaming_Grid(standname, contract, direction, spslloc, crossInf, thisGrid, IdxInterval);
            fprintf(fileTree,'%d,%s\n',j-1,GridName);
            
            fileGrid = fopen(fullfile(GridFolder,[GridName '.csv']),'w');
            IndItem = thisGrid.IndItem;
            LB = thisGrid.LB*(200/IdxInterval)-100;
            UB = thisGrid.UB*(200/IdxInterval)-100;
            
            fprintf(fileGrid,'%s\n',GridName);
            fprintf(fileGrid,'%s\n',contract);
            fprintf(fileGrid,'%s\n',spslinf);
            fprintf(fileGrid,'%s\n',GridContent{entryindicator,1});
            for idc=1:length(IndItem)
                fprintf(fileGrid,'%s\n',GridContent{IndItem(idc)});
            end
            fprintf(fileGrid,'%s\n',['Rule Cross CrossPoint ' cpvalue]);
            for idc=1:length(IndItem)
                fprintf(fileGrid,'%s%d%s%d\n','Rule Range LB ',LB(idc),' UB ',UB(idc));
            end
            
            fclose(fileGrid);
        end
        fclose(fileTree);
    end
    fclose(fileForest);
end

end