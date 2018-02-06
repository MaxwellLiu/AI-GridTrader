classdef Initial
    % Initial Summary of this class goes here
    % by Maxwell
    
    properties
        %PriceDataStore
        ExperimentParameters
        StandardParameters
        %Indicator
    end
    
    methods
        function this = Initial()
            %% parameter setting
            this.StandardParameters = Initial.setStandardParameters();
            this.ExperimentParameters = setParameter(this, this.StandardParameters);
            
        end
        
        function ExperimentParameters = setParameter(obj, StandardParameters)
            %% parameter setting, some based on StandardParameters
            ExperimentParameters.contractKeys = 'ruHot';
            ExperimentParameters.IdxSelectedScreener = [1,2,3,4,5,6,10,11,12,13,14,15,16,17];
            ExperimentParameters.IdxSelectedInterval = 1;
            ExperimentParameters.IdxSelectedDirection = 2;%1Long 2Short
            ExperimentParameters.IdxSelectedSLSP = 2;
            
            ExperimentParameters.noSampleInTraining = 5000;
            ExperimentParameters.noSelectedForest = 500;
            ExperimentParameters.noTreesInForest = 10;
            ExperimentParameters.noZones = 2;
            ExperimentParameters.noScreener = 2;
            ExperimentParameters.rdRatioTrain = 3;
            ExperimentParameters.isIntraDayMode = true;
            
            ExperimentParameters.holdPeriod = 500;
            ExperimentParameters.minimalSamplesAtOneNode = 100;
            ExperimentParameters.minimalWinrateAtOneNode = 0.65;
            
            ExperimentParameters.profitFactorInTrain = 2;
            ExperimentParameters.votingPassRate = 0.1;
            
            ExperimentParameters.trainStarts = [ 20030101000000, 20040101000000, 20050101000000, 20070101000000, 20110101000000, 20120101000000 ];
            ExperimentParameters.trainEnds =   [ 20031230000000, 20041231000000, 20051231000000, 20071231000000, 20111230000000, 20121231000000 ];
            
            ExperimentParameters.valStarts = [ 20060101000000, 20080101000000, 20090601000000, 20100101000000, 20140101000000 ];
            ExperimentParameters.valEnds =   [ 20061231000000, 20081230000000, 20091231000000, 20101231000000, 20141231000000 ];
            
            ExperimentParameters.simStarts = [ 20130101000000, 20150101000000, 20160101000000 ];
            ExperimentParameters.simEnds   = [ 20131231000000, 20151231000000, 20161231000000 ];
            
            ExperimentParameters.orderCoverCondition = [ true,    % 1.stop loss at open
                true,    % 2.stop profit at open
                true,    % 3.stoploss normal
                true,    % 4.stopprofit normal
                true,    % 5.dailytrading
                false,    % 6.hold period
                true,    % 7.cover last trading at Research
                false,   % 8.cover after profit loss some
                false    % 9.not loss cover
                ];
            
            ExperimentParameters.directionalType = StandardParameters.CONS_DIR(ExperimentParameters.IdxSelectedDirection);
            ExperimentParameters.sl = StandardParameters.CONS_SL(ExperimentParameters.IdxSelectedSLSP);
            ExperimentParameters.sp = StandardParameters.CONS_SP(ExperimentParameters.IdxSelectedSLSP);
            ExperimentParameters.IdxInterval = StandardParameters.CONS_GI(ExperimentParameters.IdxSelectedInterval);
            
        end
        
    end
    
    methods(Static)
        function StandardParameters = setStandardParameters()
            %% setting StandardParameters
            StandardParameters.CONS_SL = [0.002,0.003,0.004,0.005, 0.006,0.007,0.008,0.009,0.01, 0.02, 0.002, 0.006, 0.002,  0.01];
            StandardParameters.CONS_SP = [0.004,0.006,0.008,0.01,0.012,0.014,0.016, 0.018,0.02, 0.04,0.002, 0.002, 0.00005, 0.003];
            
            %% Standard01: Preset number of grid intervals.
            StandardParameters.CONS_GI = [ 50,100,150,200, 10, 500, 1000,20];
            
            %% Standard02: Preset standard of required number of trades for a qualified grid.
            StandardParameters.CONS_RNT = [50,100,200];
            
            %% Standard03: Preset standard of required ratio of RETURN/MAXDRAWBACK.
            StandardParameters.CONS_RRD = [ 2, 2.5, 3, 3.5, 4];
            
            %% 策略方向参数
            StandardParameters.CONS_DIR = [ 1, -1 ];
            
            %% 策略是日内还不是日间
            StandardParameters.CONS_INTRADAY = [true, false];
            
        end
    end
end

