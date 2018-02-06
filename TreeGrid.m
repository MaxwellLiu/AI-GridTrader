classdef TreeGrid
    %DecisionTreeGrid Summary of this class goes here
    % by Maxwell
    
    properties
        Parameter
        x
        y
        pr
        TreeNode
    end
    
    methods
        function obj = DecisionTreeGrid(Parameter, x, y, pr)
            
            obj.Parameter = Parameter;
            obj.x = x;
            obj.y = y;
            obj.pr = pr;
            obj.TreeNode = growTree(obj);
        end
        
        function TreeNode = growTree(obj)
            
            noSample = obj.Parameter.noSampleInTraining;
            TreeNode = cell(noSample,1);
            parfor cycleSample=1:noSample
                disp('search Tree: Parallel Computing')
                SelectNode = growGrid(obj);
                if ~isempty(SelectNode{1,1})
                    TreeNode{cycleSample,1} = SelectNode;
                end
            end
            TreeNode = TreeNode(~cellfun(@isempty,TreeNode));
        end
        
        function SelectNode = growGrid(obj)
            
            X = obj.x;
            Y = obj.y;
            PR = obj.pr;
            Param = obj.Parameter;
            
            IndcNo = size(X,2);
            
            no = Param.noScreener;
            noZones = Param.noZones;
            IdxInterval = Param.IdxInterval;
            minimalSamplesAtOneNode = Param.minimalSamplesAtOneNode;
            profitFactorInTrain = Param.profitFactorInTrain;
            
            idx = nchoosek(1:IndcNo,no);
            
            [thisX,thisY,thisPR,thisLabel,indloc] = randomXY(X,Y,PR,idx,noZones);
            step = 200/IdxInterval;
            SelectNodeNo = 0;
            SelectNode = cell(1,1);
            Node.LB = zeros(1,no);
            Node.UB = ones(1,no) * IdxInterval;
            Node.X = thisX;
            Node.Y = thisY;
            Node.PR = thisPR;
            Node.IndItem = indloc;
            Node.label = thisLabel;
            NodeTobeDone{1,1} = Node;
            nextunusednode = 2;
            
            while nextunusednode > 0
                thisNodeTobeDone = cell(1,1);
                nextunusednode = 0;
                for doi=1:length(NodeTobeDone)
                    thisNode = NodeTobeDone{doi,1};
                    InformationGain = 0;
                    
                    HasBestSplit = false;
                    BestSplit = zeros(1,2);
                    for xi=1:no
                        % Range = [thisNode.LB(xi) * step - 100 thisNode.UB(xi) * step - 100];
                        for i=thisNode.LB(xi)+1:thisNode.UB(xi)-1
                            cvalue = i * step - 100;
                            [InformationGain0, Node0] = computeInfoG(thisNode,xi,cvalue);
                            if InformationGain0 > InformationGain
                                InformationGain = InformationGain0;
                                LeftNode = Node0.LeftNode;
                                BestSplit = [i xi];
                                RightNode = Node0.RightNode;
                                HasBestSplit = true;
                            end
                        end
                    end
                    
                    if HasBestSplit
                        LeftNode.LB = thisNode.LB;
                        LeftNode.UB = thisNode.UB;
                        LeftNode.UB(BestSplit(2)) = BestSplit(1);
                        LeftNode.IndItem = thisNode.IndItem;
                        if size(LeftNode.X,1) > minimalSamplesAtOneNode
                            if LeftNode.performance < profitFactorInTrain
                                nextunusednode = nextunusednode+1;
                                thisNodeTobeDone{nextunusednode,1} = LeftNode;
                            else
                                SelectNodeNo = SelectNodeNo + 1;
                                SelectNode{SelectNodeNo} = LeftNode;
                            end
                        end
                        
                        RightNode.LB = thisNode.LB;
                        RightNode.UB = thisNode.UB;
                        RightNode.LB(BestSplit(2)) = BestSplit(1);
                        RightNode.IndItem = thisNode.IndItem;
                        if size(RightNode.X,1) > minimalSamplesAtOneNode
                            if RightNode.performance < profitFactorInTrain
                                nextunusednode = nextunusednode+1;
                                thisNodeTobeDone{nextunusednode,1} = RightNode;
                            else
                                SelectNodeNo = SelectNodeNo + 1;
                                SelectNode{SelectNodeNo} = RightNode;
                            end
                        end
                        
                    end
                end
                NodeTobeDone = thisNodeTobeDone;
            end
        end
        
    end
    
end

function [thisX,thisY,thisPR,thisLabel,indloc] = randomXY(X,Y,PR,idx,noZones)
dimension = size(X,1);
a = randperm(dimension);
indRand = randi(size(idx,1));
indloc = idx(indRand,:);
tempa = round(dimension/noZones);
sorta = sort(a(1:tempa));
thisX = X(sorta,indloc);
thisY = Y(sorta);
thisPR = PR(sorta);
thisLabel = (1:dimension)';
thisLabel = thisLabel(sorta);

end

function [informationGain, Node] = computeInfoG(NodeInput,xi,cvalue)

X = NodeInput.X;
Y = NodeInput.Y;
pr = NodeInput.PR;
Label = NodeInput.label;

thisX = X(:,xi);
LenX = length(thisX);
isXLeft = thisX<=cvalue;
isXRight = ~isXLeft;

NumLeft = sum(isXLeft);
NumRight = LenX-NumLeft;

YLeft = Y(isXLeft);
YRight = Y(isXRight);

YLeftequal1 = sum(YLeft>0);
YRightequal1 = sum(YRight>0);

winrateLeft = YLeftequal1/NumLeft;
entropyLeft = entropy(winrateLeft);

winrateRight = YRightequal1/NumRight;
entropyRight = entropy(winrateRight);

weightedEntropy = NumLeft * entropyLeft / LenX + NumRight * entropyRight / LenX;

winrateAll = (YLeftequal1 + YRightequal1) / LenX;
entropyAll = entropy(winrateAll);
informationGain = entropyAll - weightedEntropy;

prLeft = pr(isXLeft);
prRight = pr(isXRight);

prPerfLeft = nodeQuality(prLeft);
prPerfRight = nodeQuality(prRight);

LeftNode.X = X(isXLeft,:);
LeftNode.Y = YLeft;
LeftNode.winrate = winrateLeft;
LeftNode.entropy = entropyLeft;
LeftNode.performance = prPerfLeft;
LeftNode.PR = prLeft;
LeftNode.label = Label(isXLeft,:);

RightNode.X = X(isXRight,:);
RightNode.Y = YRight;
RightNode.winrate = winrateRight;
RightNode.entropy = entropyRight;
RightNode.performance = prPerfRight;
RightNode.PR = prRight;
RightNode.label = Label(isXRight,:);

Node.LeftNode = LeftNode;
Node.RightNode = RightNode;
Node.X = X;
Node.Y = Y;
Node.performance = pr;
Node.cvalue = cvalue;
Node.informationGain = informationGain;
Node.label = Label;

end

function dEntropy = entropy(p)
if (p == 0)
    p = 0.001;
end
dEntropy = -(p * log(p) + (1 - p) * log(1 - p));
end

function rate = nodeQuality(pr)
rate = -sum(pr(pr>0)) / sum(pr(pr<0));
end

