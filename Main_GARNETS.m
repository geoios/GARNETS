clc
clear all

%% ++++Data file path++++
% Data storage path
PublicPath = '.\WorkSpace\MYGI\';
% Station name
SerialInf  = 'MYGI.1204.meiyo_m4';
% Acoustic observation data
ObsPath    = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs.GNSSA'];
% Sound speed profile observation data
SVPPath    = [PublicPath,'Obs',SerialInf,'-svp','\' SerialInf,'-svp.SVP'];
% Configuration information file
ConfigPath = [PublicPath,'Config\',SerialInf '-initcfg.ini'];
% GARPOS solution results
JapPath    = [PublicPath,'JapSol\',SerialInf '-res.dat'];

%% ++++Data reading and information acquisition++++
% Reading acoustic observation data
AcousticData   = ReadNSinex(ObsPath);
% Configuration information
ObsInf = AcousticData.Header;
% Observation session information
SessionInf = str2num(ObsInf.Sessions);  
SesNum = length(SessionInf);
% Seafloor transponder information
SPNoInf = str2num(ObsInf.Site_No);  
SPNoNum = length(SPNoInf);
% Reading GARPOS results file
JapSol        = ReadNSinex(JapPath);
% Initial value of seafloor transducer position
x0s           = Extraction_x0(JapSol);
x_Jap         = [x0s(:,2),x0s(:,1),x0s(:,3)];
% Reading configuration information file
ConfigInf = ReadNSinex(ConfigPath);
% Arm Length 
ArmLen = ConfigInf.Model_parameter.ANT_to_TD.ATDoffset(1:3);
% Reading Sound speed profile observation data
SVP     = ReadNSinex(SVPPath);
SVPData = SVP.Data.depth;

%% ++++Parameters configuration++++
% Solution strategy configuration   
Par.ArmLen     = ArmLen;               % Arm length
Par.x0s        = x_Jap;                % Initial value of seafloor transducer position
Par.BreakTime  = 1.3 * 60;             % Data breakpoint detection time
Par.ZenTime    = 5 * 60;               % Zenith delay segmentation time
Par.HorTime    = 30 * 60;              % Horizontal delay segmentation time
Par.MedBreak   = 3000000000 * 60;      % Centre point breakpoint detection time
Par.MedTime    = 3000000000 * 60;      % Centre point delay segmentation time
Par.WeightType = 0;                    % 0(Height angle weighting) or 1(Euqal weighting) 
% Main parameter constraints
Par.Mu_ZenDelay  = 0;        % Zenith delay parameter constraints
Par.Mu_HorDelay  = [0 0];    % Horizontal delay parameter constraints
Par.Mu_MedDelay  = [10000 10000 10000];   % Centre point delay parameter constraints
% Continuity constraints parameter
Par.Mu_ConZen = 1;   % Zenith delay continuity Constraint
Par.Mu_ConHor = 1;   % Horizontal delay continuity Constraint
Par.Mu_ConMed = 1;   % Centre point delay continuity Constraint                    
Par.ConWeight = 3;    
% Solution parameter configuration
Par.MaxIter     = 20;       % Maximum Iterations
Par.Termination = 10^-4;    % Iteration termination condition
Par.RobK1       = 3;        % Robust range K1
Par.RobK2       = 5;        % Robust range K2

%% ++++Data solving++++
% SolRes = [GARNETS,GARPOS,Difference];
% Delay  = {[Zenith Delay],[NDelay,EDelay]};

%% -------Network solution and single point solution of whole-sessions-------
% Par.SolModel   = 0;                    % Solving model(0:Single point solution,1:Network solution)
% Par.SingleSPNO = 1;                    % Single point solution point number
% if Par.SolModel == 0
%     Par.Mu_Main      = [zeros(1,3) 1000 1000 10000 100000*ones(1,1) 10000]; 
% else
%     Par.Mu_Main      = [zeros(1,3*SPNoNum) 1000 1000 10000 100000*ones(1,SPNoNum) 10000]; 
% end
% [SolRes,Delay,dL_Com_Rob,TimeInf] = NetworkSolver(AcousticData,SVPData,Par);
% % Figure1:Delay series of whole-sessions
% PlotDelaySeries(AcousticData,Delay,TimeInf)

%% -------Network solution of multi-sessions-------
Par.SolModel   = 1;                    % Solving model(0:Single point solution,1:Network solution)
Par.SingleSPNO = 1;                    % Single point solution point number
Par.Mu_Main      = [zeros(1,3*SPNoNum) 1000 1000 10000 100000*ones(1,SPNoNum) 10000]; 
for i = 1:SesNum
    SesObsPath = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs','_S_',num2str(i),'_L_Inf_M_Inf','.GNSSA'];
    SesAcouData = ReadNSinex(SesObsPath);
    [SolRes,Delay,dL_Com_Rob,TimeInf] = NetworkSolver(SesAcouData,SVPData,Par);
    SesRes          = SolRes(:,3:5)';
    Ses_Result(i,:) = SesRes(:);
    SesTime(:,i)    = TimeInf.ObsTime;
    SesDelay{i}     = Delay;
end
% Figure1:Error series of positioning
PlotPositionRes(Ses_Result,SesTime,TimeInf,SPNoInf)
% Figure2:Error distribution of positioning
PlotResidualdistribution(Ses_Result)

%% -------Single point solution of multi-sessions-------
% Par.SolModel   = 0;                    % Solving model(0:Single point solution,1:Network solution)
% Par.SingleSPNO = 1;                    % Single point solution point number
% Par.Mu_Main      = [zeros(1,3) 1000 1000 10000 100000*ones(1,1) 10000];
% SesObsPath = [PublicPath,'Obs',SerialInf,'-obs','\' SerialInf,'-obs','_S_',num2str(Par.SingleSPNO),'_L_Inf_M_Inf','.GNSSA'];
% SesAcouData = ReadNSinex(SesObsPath);
% [SolRes,Delay,dL_Com_Rob,TimeInf] = NetworkSolver(SesAcouData,SVPData,Par);
% % Figure1:Delay series of single-point positioning of multi-sessions
% PlotDelaySeries(SesAcouData,Delay,TimeInf)













