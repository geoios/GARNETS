function [SolRes,Delay,dL_Com_Rob,TimeInf] = NetworkSolver(AcousticData,SVPData,Par) 
%% ++++Parameters configuration++++
% Solution strategy configuration
SolModel   = Par.SolModel;      
SingleSPNO = Par.SingleSPNO;
ArmLen     = Par.ArmLen;          % Arm length
x_Jap      = Par.x0s;             % Initial value of seafloor transducer position
BreakTime  = Par.BreakTime;       % Data breakpoint detection time
ZenTime    = Par.ZenTime;         % Zenith delay segmentation time
HorTime    = Par.HorTime   ;      % Horizontal delay segmentation time
MedBreak   = Par.MedBreak ;       % Centre point breakpoint detection time
MedTime    = Par.MedTime  ;       % Centre point delay segmentation time
WeightType = Par.WeightType;      % 0(Height angle weighting) or 1(Euqal weighting) 
% Main parameter constraints
Mu_Main     = Par.Mu_Main;   
Mu_ZenDelay = Par.Mu_ZenDelay;    % Zenith delay parameter constraints
Mu_HorDelay = Par.Mu_HorDelay;    % Horizontal delay parameter constraints
Mu_MedDelay = Par.Mu_MedDelay;    % Centre point delay parameter constraints
% Continuity constraints parameter
Mu_ConZen = Par.Mu_ConZen;    % Zenith delay continuity Constraint
Mu_ConHor = Par.Mu_ConHor;    % Horizontal delay continuity Constraint
Mu_ConMed = Par.Mu_ConMed;    % Centre point delay continuity Constraint                    
ConWeight = Par.ConWeight;    
% Solution parameter configuration
MaxIter     = Par.MaxIter;       % Maximum Iterations
Termination = Par.Termination;   % Iteration termination condition
RobK1       = Par.RobK1;         % Robust range K1
RobK2       = Par.RobK2;         % Robust range K2

%% ++++++++++++ Data Information Index +++++++++++
% Data index
DelayIdx     = [4];         % Sound ray propagation time
STimeIdx     = [9];         % Acoustic emission time
RTimeIdx     = [16];        % Acoustic receive time
SControlIdx  = [10 11 12];  % Emission point
RControlIdx  = [17 18 19];  % Receive point
SAttitudeIdx = [13 14 15];  % Emission attitude
RAttitudeIdx = [20 21 22];  % Receive attitude
% Data information
DateUTC = AcousticData.Header.DateUTC ;  
DateUTC = str2num(strrep(DateUTC,'-',','));
[ObsData,StntionObs] = StandardData1(AcousticData);   
ObsStartTime = ObsData(1,9);
ObsEndTime   = ObsData(end,9);
TotalObs     = ObsData;
TotalObsNum  = size(TotalObs,1);

StnSeq   = unique(TotalObs(:,3));
StnNum   = length(StnSeq);  
LinkList = zeros(StnNum,TotalObsNum);
for i = 1:TotalObsNum
    iObsNo = TotalObs(i,3);
    StnLoc = find(StnSeq==iObsNo);    
    LinkList(StnLoc,i) = 1;
end

if SolModel == 0
    ObsData    = StntionObs{SingleSPNO};
    StntionObs = StntionObs(SingleSPNO);
    x_Jap      = x_Jap(SingleSPNO,:);
    LinkList   = LinkList(SingleSPNO,:);
    StnNum     = 1;  
    StnSeq     = SingleSPNO;
end
                          
ObsNum     = size(ObsData,1);
AllObsTime = TotalObs(:,STimeIdx);   
MeanTime   = mean(AllObsTime);
RecTime    = [ObsData(1,9);ObsData(end,9)];
% Data breakpoint detection
BreakPoint      = BreakPointDetect(AllObsTime,BreakTime);
BreakPoint(end) = BreakPoint(end) + 1;
% Vertical breakpoint 
[BlockIdx_Zen,MeanSecTime_Zen] = TimeSegment(BreakPoint,ZenTime,AllObsTime);
% Horizontal breakpoint 
[BlockIdx_Hor,MeanSecTime_Hor] = TimeSegment(BreakPoint,HorTime,AllObsTime);
% Centre point breakpoint 
MedBreakPoint                = BreakPointDetect(AllObsTime,MedBreak);
MedBreakPoint(end)           = MedBreakPoint(end) + 1;
[BlockIdx_Med,MeanSecTime_Med] = TimeSegment(MedBreakPoint,MedTime,AllObsTime);

%% ++++++++++++ Constraint parameter configuration ++++++++++++
% Vertical
BlockNum_Zen = length(BlockIdx_Zen);
for i = 1:BlockNum_Zen - 1
    TimeDiff_Zen(i,:) = MeanSecTime_Zen(i+1) - MeanSecTime_Zen(i);
end
Mu_ZenPar = BlockWeight_New(TimeDiff_Zen,Mu_ConZen,ConWeight);
% Horizontal
BlockNum_Hor = length(BlockIdx_Hor);
for i = 1:BlockNum_Hor - 1
    TimeDiff_Hor(i,:) = MeanSecTime_Hor(i+1) - MeanSecTime_Hor(i);
end
Mu_HorPar = BlockWeight_New(TimeDiff_Hor,Mu_ConHor,ConWeight);
Mu_HorPar = repelem(Mu_HorPar,2);
% Centre point 
BlockNum_Med = length(BlockIdx_Med);
for i = 1:BlockNum_Med - 1
    TimeDiff_Med(i,:) = MeanSecTime_Med(i+1) - MeanSecTime_Med(i);
end
if BlockNum_Med ==1
    Mu4 = 1;
else
    Mu4 = BlockWeight(TimeDiff_Med,Mu_ConMed,ConWeight);
end
% Delay parameter constraint
Mu_ZenDelay = repmat(Mu_ZenDelay,1,BlockNum_Zen);
Mu_HorDelay = repmat(Mu_HorDelay,1,BlockNum_Hor);
Mu_MedDelay = repmat(Mu_MedDelay,1,BlockNum_Med);

%% ++++++++++++ Sound velocity profile information ++++++++++++
PF        = SVPData;
WindowNum = 2;          
Order     = 1;         
PF        = PFGrad(PF,WindowNum,Order); 
c0        = MeanVel(PF);       % Weighted average sound velocity

%% ++++++++++++ Initial parameter settings ++++++++++++
% Main parameter
x0 = [];  
for i = 1:StnNum
    x0 = [x0,x_Jap(i,:)];
end
HardDelay  = zeros(1,StnNum);
RadVel     = 0;
Main_x0    = [x0,ArmLen(1:3),HardDelay,RadVel];
MainParNum = length(Main_x0);
MainPos    = 1:MainParNum;
% Delay error parameter(zenith)
ZenDelay_x0  = zeros(1,BlockNum_Zen);       
ZenDelay_Pos = MainParNum+1:MainParNum + BlockNum_Zen;    
ZenDelayNum  = length(ZenDelay_x0);
% Delay error parameter(horizontal)
HorDelay_x0  = zeros(1,2*BlockNum_Hor);             
HorDelay_Pos = ZenDelay_Pos(end)+1:ZenDelay_Pos(end) + 2 * BlockNum_Hor;  
HorDelayNum  = length(HorDelay_x0);
Delay      = [ZenDelay_x0,HorDelay_x0];
DelayPos   = ZenDelay_Pos(1):HorDelay_Pos(end);                
DelayNum   = BlockNum_Zen + 2 * BlockNum_Hor;
% Delay error parameter(centre point)
MedDelay_x0  = zeros(1,3*BlockNum_Med);
MedDelay_Pos = DelayPos(end)+1:DelayPos(end) + 3*BlockNum_Med;
MedDelayNum  = BlockNum_Med * 3;
% Initial parameter
x_ini = [Main_x0,ZenDelay_x0,HorDelay_x0,MedDelay_x0];
StnBlock_Zen = zeros(StnNum,BlockNum_Zen);
StnBlock_Hor = zeros(StnNum,BlockNum_Hor);

%% ++++++++++++ Data solving ++++++++++++
for Loop = 1:MaxIter
    B_Com  = [];
    dL_Com = [];
    P_Com  = [];

    for sn = 1:StnNum    
       Stnx0(sn,:) =  x_ini(3*sn-2:3*sn);
    end
    MedPoint = mean(Stnx0);
    Mean_U   = mean(Stnx0(:,3));

    for s = 1:StnNum
        sObs      = StntionObs{s};
        sLinkList = LinkList(s,:);
        % Observation data extraction
        DelayTime  = sObs(:,DelayIdx);
        SEpochTime = sObs(:,STimeIdx);
        REpochTime = sObs(:,RTimeIdx);
        SPoints    = sObs(:,SControlIdx);
        RPoints    = sObs(:,RControlIdx);
        SAttitude  = sObs(:,SAttitudeIdx);
        RAttitude  = sObs(:,RAttitudeIdx);
        % Observation value calculation
        L             = DelayTime * c0;
        sDataNum      = size(DelayTime,1);
        StnDataNum(s) = sDataNum;
        % Iteration variable clearing
        STraLoc = []; SRs = []; RTraLoc = []; RRs = [];
        e1 = []; t1 = []; dis1 = []; e2 = []; t2 = []; dis2 = [];
        B_ArmLen1 = []; B_ArmLen2 = [];
        SCosElv = []; RCosElv = [];
        STanElv = []; RTanElv = [];
        f_HorDelayN1 = []; f_HorDelayN2 = []; B_HorDelayN1 = []; B_HorDelayN2 = [];
        f_HorDelayE1 = []; f_HorDelayE2 = []; B_HorDelayE1 = []; B_HorDelayE2 = [];
        SVelocity = []; RVelocity = [];
        
        for i = 1:sDataNum
            % Arm length conversion
            [STraLoc(i,:),SRs(:,:,i)] = ArmCalibration_Jap(x_ini(3*StnNum+1:3*StnNum+3)',SAttitude(i,:),SPoints(i,:));
            [RTraLoc(i,:),RRs(:,:,i)] = ArmCalibration_Jap(x_ini(3*StnNum+1:3*StnNum+3)',RAttitude(i,:),RPoints(i,:));
            % Acoustic ray tracing       
            [e1(i,:),t1(i,:),AddInf1] = RayJac_Num(STraLoc(i,:),x_ini(3*s-2:3*s),PF);
            dis1(i,:) = t1(i,:) * c0;
            [e2(i,:),t2(i,:),AddInf2] = RayJac_Num(RTraLoc(i,:),x_ini(3*s-2:3*s),PF);
            dis2(i,:) = t2(i,:) * c0;
            B_ArmLen1(i,:) = [e1(i,:) * SRs(:,1,i),e1(i,:) * SRs(:,2,i),e1(i,:) * SRs(:,3,i)];
            B_ArmLen2(i,:) = [e2(i,:) * RRs(:,1,i),e2(i,:) * RRs(:,2,i),e2(i,:) * RRs(:,3,i)];
        end
        Dis = dis1 + dis2;
        
        % 天顶延迟(垂直方向)       
        if SolModel == 0
            Eta_c       = 1;
            Eta_u       = 1;
        else
            Eta_c       = AddInf1.cx * (1/c0);
            Eta_u       = Stnx0(s,3) * (1/Mean_U);
        end

        Cos_Zen1    = e1(:,3);
        Cos_Zen2    = e2(:,3);
        B_ZenDelay1 = -(1./Cos_Zen1) .* (Eta_c * Eta_u);
        B_ZenDelay2 = -(1./Cos_Zen2) .* (Eta_c * Eta_u);
        
        % 天顶延迟(水平方向)
        U_s1        = STraLoc(:,3) - x_ini(3*s);
        U_s2        = RTraLoc(:,3) - x_ini(3*s);
        tan_phi_nx1 = x_ini(3*s-2) .* (1./U_s1);
        tan_phi_nx2 = x_ini(3*s-2) .* (1./U_s2);
        tan_phi_ex1 = x_ini(3*s-1) .* (1./U_s1);
        tan_phi_ex2 = x_ini(3*s-1) .* (1./U_s2);
        for t =1:sDataNum 
            tan_phi_ns1(t,:) = e1(t,2)/Cos_Zen1(t);
            tan_phi_ns2(t,:) = e2(t,2)/Cos_Zen2(t);
            tan_phi_es1(t,:) = e1(t,1)/Cos_Zen1(t);
            tan_phi_es2(t,:) = e2(t,1)/Cos_Zen2(t);
            
            B_HorDelayN1(t,:) = -(1/Cos_Zen1(t)) * ((tan_phi_ns1(t) + tan_phi_nx1(t))/2) * (Eta_c*Eta_u^2);
            B_HorDelayN2(t,:) = -(1/Cos_Zen2(t)) * ((tan_phi_ns2(t) + tan_phi_nx2(t))/2) * (Eta_c*Eta_u^2);
            B_HorDelayE1(t,:) = -(1/Cos_Zen1(t)) * ((tan_phi_es1(t) + tan_phi_ex1(t))/2) * (Eta_c*Eta_u^2);
            B_HorDelayE2(t,:) = -(1/Cos_Zen2(t)) * ((tan_phi_es2(t) + tan_phi_ex2(t))/2) * (Eta_c*Eta_u^2);
        end

        % Data segmentation(zenith)
        f_ZenDelay1  = []; f_ZenDelay2  = [];
        Sta_ZenDelay = 1; End_ZenDelay  = 0;
        for k = 1:BlockNum_Zen
            kBlock = BlockIdx_Zen{k};                 
            BlockEpochNum = sLinkList(kBlock);       
            StnBlockNum  = sum(BlockEpochNum);      
            StnBlock_Zen(s,k) = StnBlockNum;
            if StnBlockNum == 0
                continue
            end
            End_ZenDelay = End_ZenDelay + StnBlockNum;
            kBlockIdx = ZenDelay_Pos(k);
            kf_Zen1 = x_ini(kBlockIdx) .* B_ZenDelay1(Sta_ZenDelay:End_ZenDelay,:) ;
            kf_Zen2 = x_ini(kBlockIdx) .* B_ZenDelay2(Sta_ZenDelay:End_ZenDelay,:);
            f_ZenDelay1 = [f_ZenDelay1;kf_Zen1];
            f_ZenDelay2 = [f_ZenDelay2;kf_Zen2];
            Sta_ZenDelay = End_ZenDelay + 1;
        end
        f_ZenDelay = f_ZenDelay1  + f_ZenDelay2 ;  
        
        % Data segmentation(horizontal)
        f_HorDelayN1 = []; f_HorDelayN2 = [];
        f_HorDelayE1 = []; f_HorDelayE2 = [];
        Sta_HorDelay = 1; End_HorDelay  = 0;
        for k = 1:BlockNum_Hor
            kBlock = BlockIdx_Hor{k};                 
            BlockEpochNum = sLinkList(kBlock);        
            StnBlockNum  = sum(BlockEpochNum);        
            StnBlock_Hor(s,k) = StnBlockNum;
            if StnBlockNum == 0
                continue
            end
            End_HorDelay = End_HorDelay + StnBlockNum;
            kBlockIdx = HorDelay_Pos(2*k-1:2*k);
            % Horizontal-N         
            kf_HorN1 = x_ini(kBlockIdx(1)) .* B_HorDelayN1(Sta_HorDelay:End_HorDelay,:);
            kf_HorN2 = x_ini(kBlockIdx(1)) .* B_HorDelayN2(Sta_HorDelay:End_HorDelay,:);
            f_HorDelayN1 = [f_HorDelayN1;kf_HorN1];
            f_HorDelayN2 = [f_HorDelayN2;kf_HorN2];
            % Horizontal-E        
            kf_HorE1 = x_ini(kBlockIdx(2)) .* B_HorDelayE1(Sta_HorDelay:End_HorDelay,:);
            kf_HorE2 = x_ini(kBlockIdx(2)) .* B_HorDelayE2(Sta_HorDelay:End_HorDelay,:);
            f_HorDelayE1 = [f_HorDelayE1;kf_HorE1];
            f_HorDelayE2 = [f_HorDelayE2;kf_HorE2];
            Sta_HorDelay = End_HorDelay + 1;
        end
        f_HorDelayN = f_HorDelayN1 + f_HorDelayN2;
        f_HorDelayE = f_HorDelayE1 + f_HorDelayE2;  
        
        % Data segmentation(centre point)
        sMedDiff = (Stnx0(s,:) - MedPoint)/1000;
        B_MedDelayU1  = B_ZenDelay1  * sMedDiff(3);
        B_MedDelayU2  = B_ZenDelay2  * sMedDiff(3);
        B_MedDelayN1  = B_HorDelayN1 * sMedDiff(1);
        B_MedDelayN2  = B_HorDelayN2 * sMedDiff(1);
        B_MedDelayE1  = B_HorDelayE1 * sMedDiff(2);
        B_MedDelayE2  = B_HorDelayE2 * sMedDiff(2);
        
        f_MedDelayU1 = [];  f_MedDelayU2 = [];
        f_MedDelayN1 = [];  f_MedDelayN2 = [];
        f_MedDelayE1 = [];  f_MedDelayE2 = [];
        StaP_MedDelay = 1; End_MedDelay = 0;
        for k = 1:BlockNum_Med
            kBlock = BlockIdx_Med{k};                     
            BlockEpochNum = sLinkList(kBlock);        
            MedStnBlockNum  = sum(BlockEpochNum);        
            MedStnBlockInf(s,k) = MedStnBlockNum;
            if MedStnBlockNum == 0
                continue
            end
            End_MedDelay = End_MedDelay + MedStnBlockNum;
            kBlockIdx = 3*k-2:3*k;
            % centre point-Z
            kf_MedU1 = B_MedDelayU1(StaP_MedDelay:End_MedDelay,:) * x_ini(MedDelay_Pos(kBlockIdx(1)));
            kf_MedU2 = B_MedDelayU2(StaP_MedDelay:End_MedDelay,:) * x_ini(MedDelay_Pos(kBlockIdx(1)));
            f_MedDelayU1 = [f_MedDelayU1;kf_MedU1];
            f_MedDelayU2 = [f_MedDelayU2;kf_MedU2];
            % centre point-N
            kf_MedN1 = B_MedDelayN1(StaP_MedDelay:End_MedDelay,:) .* x_ini(MedDelay_Pos(kBlockIdx(2))); 
            kf_MedN2 = B_MedDelayN2(StaP_MedDelay:End_MedDelay,:) .* x_ini(MedDelay_Pos(kBlockIdx(2)));
            f_MedDelayN1 = [f_MedDelayN1;kf_MedN1];
            f_MedDelayN2 = [f_MedDelayN2;kf_MedN2];
            % centre point-E
            kf_MedE1 = B_MedDelayE1(StaP_MedDelay:End_MedDelay,:) .* x_ini(MedDelay_Pos(kBlockIdx(3))) ;
            kf_MedE2 = B_MedDelayE2(StaP_MedDelay:End_MedDelay,:) .* x_ini(MedDelay_Pos(kBlockIdx(3))) ;
            f_MedDelayE1 = [f_MedDelayE1;kf_MedE1];
            f_MedDelayE2 = [f_MedDelayE2;kf_MedE2];
            StaP_MedDelay = End_MedDelay + 1;
        end
        f_MedDelayU = f_MedDelayU1 + f_MedDelayU2 ;
        f_MedDelayN = f_MedDelayN1 + f_MedDelayN2;
        f_MedDelayE = f_MedDelayE1 + f_MedDelayE2;
        
        % Hardware error
        f_HardDelay = x_ini(3*StnNum+3+s) * c0 * ones(sDataNum,1);

        % Radial velocity 
        for j = 1:sDataNum
            X_velocity = (RTraLoc(j,1) - STraLoc(j,1))/DelayTime(j);
            Y_velocity = (RTraLoc(j,2) - STraLoc(j,2))/DelayTime(j);
            Z_velocity = (RTraLoc(j,3) - STraLoc(j,3))/DelayTime(j);
            SVelocity(j,:)  = e1(j,:) * [X_velocity Y_velocity Z_velocity]';
            RVelocity(j,:)  = e2(j,:) * [X_velocity Y_velocity Z_velocity]';
        end
        f_RadVel = (SVelocity + RVelocity) * x_ini(3*StnNum+3+StnNum+1);

        % Observation design matrix
        B1 = [e1 B_ArmLen1 ones(sDataNum,1)*c0 SVelocity B_ZenDelay1 B_HorDelayN1 B_HorDelayE1 B_MedDelayU1 B_MedDelayN1 B_MedDelayE1];
        B2 = [e2 B_ArmLen2 ones(sDataNum,1)*c0 RVelocity B_ZenDelay2 B_HorDelayN2 B_HorDelayE2 B_MedDelayU2 B_MedDelayN2 B_MedDelayE2];
        B  = B1 + B2;
        dL = L - (Dis + 2*f_HardDelay + f_RadVel + f_ZenDelay + f_HorDelayN + f_HorDelayE + f_MedDelayU + f_MedDelayN + f_MedDelayE);
        
        % Observation weighted
        if WeightType == 1   
            P = ones(sDataNum,1);   
        else  
            P  = [];
            for st = 1:sDataNum
                Ps = (STraLoc(st,3)-x_ini(3*s))/norm(STraLoc(st,:)-x_ini(3*s-2:3*s));
                Pr = (RTraLoc(st,3)-x_ini(3*s))/norm(RTraLoc(st,:)-x_ini(3*s-2:3*s));
                P(st,1)  = (Ps + Pr)/2;
            end   
        end
        sig = VarEst(dL,1,'Med');
        for sk = 1:sDataNum
            P(sk,1)  = P(sk) * IGG3_w(RobK1,RobK2,dL(sk)/sig);
        end
        
        % Design matrix information index
        DelayMat{s}    = B(:,9:11);         
        MedDelayMat{s} = B(:,12:14);
        B_Com  = [B_Com;B];
        dL_Com = [dL_Com;dL];
        P_Com  = [P_Com;P];
    end
    % Design matrix blocking
    % Seafloor point position + Hardware delay error
    StnCol = 1:3;
    HarCol = 7;
    StnSta = 1;
    StnEnd = 0;
    A_Stn  = []; 
    A_Har  = [];
    for o = 1:StnNum
        oStnObsNum =  StnDataNum(o);
        StnEnd = StnEnd + oStnObsNum;
        oStnB = B_Com(StnSta:StnEnd,StnCol);
        oHarB = B_Com(StnSta:StnEnd,HarCol);
        A_Stn = blkdiag(A_Stn,oStnB);
        A_Har = blkdiag(A_Har,oHarB);
        StnSta = StnEnd + 1;
    end
    % Arm length error
    A_Arm = B_Com(:,4:6);
    % Radial velocity error
    A_Rad = B_Com(:,8);
    % Delay error(zenith)
    A_ZenDelay = [];
    for rv = 1:StnNum
        rZenDelay = zeros(StnDataNum(rv),BlockNum_Zen);
        rRowSta = 1;
        rRowEnd = 0;
        for z = 1:BlockNum_Zen
            if StnBlock_Zen(rv,z) == 0
                continue
            end
            rCol = z;
            rRowEnd = rRowEnd + StnBlock_Zen(rv,z);
            zBlock = DelayMat{rv}(rRowSta:rRowEnd,1);
            rZenDelay(rRowSta:rRowEnd,rCol) = zBlock;  
            rRowSta = rRowEnd + 1;        
        end
        A_ZenDelay    = [A_ZenDelay;rZenDelay]; 
    end
    % Delay error(horizontal)
    A_HorDelay = [];
    for rh = 1:StnNum
        rDelay = zeros(StnDataNum(rh),2*BlockNum_Hor);
        rRowSta = 1;
        rRowEnd = 0;
        for z = 1:BlockNum_Hor
            if StnBlock_Hor(rh,z) == 0
                continue
            end
            rColSta = 2 * z - 1;
            rColEnd = 2 * z;
            rRowEnd = rRowEnd + StnBlock_Hor(rh,z);
            zBlock = DelayMat{rh}(rRowSta:rRowEnd,2:3);
            rDelay(rRowSta:rRowEnd,rColSta:rColEnd) = zBlock;
            rRowSta = rRowEnd + 1;
        end
        A_HorDelay    = [A_HorDelay;rDelay];
    end
    % Delay error(centre point)
    A_MedDelay = [];
    for r = 1:StnNum
        rDelayMed = zeros(StnDataNum(r),3*BlockNum_Med);
        rRowSta = 1;
        rRowEnd = 0;
        for z = 1:BlockNum_Med
            if MedStnBlockInf(r,z) == 0
                continue
            end
            rColSta = 3 * z - 2;
            rColEnd = 3 * z;
            rRowEnd = rRowEnd + MedStnBlockInf(r,z);
            zBlockMed = MedDelayMat{r}(rRowSta:rRowEnd,:);
            rDelayMed(rRowSta:rRowEnd,rColSta:rColEnd) = zBlockMed;      
            rRowSta = rRowEnd + 1;        
        end
        A_MedDelay = [A_MedDelay;rDelayMed];
    end
    % Design martix
    A = [A_Stn,A_Arm,A_Har,A_Rad,A_ZenDelay,A_HorDelay,A_MedDelay];
    % Parameter constraints
    ZenDelay  = x_ini(ZenDelay_Pos);
    HorDelay  = x_ini(HorDelay_Pos);
    HorNDelay = HorDelay(1:2:end);
    HorEDelay = HorDelay(2:2:end);
    
    MedDelay  = x_ini(MedDelay_Pos);
    MedZDelay = MedDelay(1:3:end);
    MedNDelay = MedDelay(2:3:end);
    MedEDelay = MedDelay(3:3:end);

     [Row_A,Col_A] = size(A);
     % Delay error continuity constraints
     % Zenith continuity constraints
     ConsMat_Zen = zeros(BlockNum_Zen-1,Col_A);
     Mat_Zen     = zeros(BlockNum_Zen-1,BlockNum_Zen);
     L_Zen       = [];
     for t = 1:BlockNum_Zen - 1
         RowS = t;
         ColS = t;
         ColR = t+1;      
         Mat_Zen(RowS,ColS:ColR) = [-1,1];
         iConsL = -[ZenDelay(t+1) - ZenDelay(t)];
         L_Zen  = [L_Zen;iConsL];
     end
     ConsMat_Zen(:,ZenDelay_Pos) = Mat_Zen;
     % Horizontal continuity constraints
     ConsMat_Hor = zeros(2*(BlockNum_Hor-1),Col_A);
     Mat_Hor     = zeros(2*(BlockNum_Hor-1),2*BlockNum_Hor);
     L_Hor       = [];
     DiffMat_Hor = [-1*eye(2),eye(2)];
     for t = 1:BlockNum_Hor - 1
         RowS = 2 * t - 1;
         RowE = 2 * t;
         ColS = 2 * t - 1;
         ColR = 2 * t + 2;
         Mat_Hor(RowS:RowE,ColS:ColR) = DiffMat_Hor;
         iConsH =  -[HorNDelay(t+1) - HorNDelay(t)
                     HorEDelay(t+1) - HorEDelay(t)];
         L_Hor = [L_Hor;iConsH];
     end
     ConsMat_Hor(:,HorDelay_Pos) = Mat_Hor;
     % Centre point continuity constraints
     ConsMat_Med = zeros(3*(BlockNum_Med-1),Col_A);
     L_Med       = [];
     DiffMat_Med = [-1*eye(3),eye(3)];
     for t = 1:BlockNum_Med - 1
         RowS = 3 * t - 2;
         RowE = 3 * t;
         MedColS = 3 * t - 2 + MainParNum + (2*BlockNum_Hor+BlockNum_Zen);
         MedColR = 3 * t + 3 + MainParNum + (2*BlockNum_Hor+BlockNum_Zen);
         ConsMat_Med(RowS:RowE,MedColS:MedColR) = DiffMat_Med;
         iMedConsL = -[MedZDelay(t+1) - MedZDelay(t)
                       MedNDelay(t+1) - MedNDelay(t)
                       MedEDelay(t+1) - MedEDelay(t)];
         L_Med = [L_Med;iMedConsL];
     end
   
     % Main parameter constraints
     Lim_Main      = diag(Mu_Main);
     ConB_Main     = zeros(MainParNum,Col_A);
     ConB_Main(:,MainPos) = Lim_Main;
     ConsMainL = (Main_x0 - x_ini(1:MainParNum)).*Mu_Main;
 
     % Delay error parameter constraints
     % Zenith delay error constraints
     Lim_DelayV  = diag(Mu_ZenDelay);
     ConB_DelayV = zeros(ZenDelayNum,Col_A);
     ConB_DelayV(:,ZenDelay_Pos) = Lim_DelayV;
     ConsDelayL_V  = (ZenDelay_x0 - x_ini(ZenDelay_Pos)).*Mu_ZenDelay;
     % Horizontal delay error constraints
     Lim_DelayH   = diag(Mu_HorDelay);
     ConB_DelayH = zeros(HorDelayNum,Col_A);
     ConB_DelayH(:,HorDelay_Pos) = Lim_DelayH;
     ConsDelayL_H  = (HorDelay_x0 - x_ini(HorDelay_Pos)).*Mu_HorDelay;
     % Centre point delay error constraints
     Lim_MedDelay = diag(Mu_MedDelay);
     ConB_MedDelay = zeros(MedDelayNum,Col_A);
     ConB_MedDelay(:,MedDelay_Pos) = Lim_MedDelay;
     ConsMedDelayL  = (MedDelay_x0 - x_ini(MedDelay_Pos)).*Mu_MedDelay;
     
     % Constraints information
     ConsMat = [
                % Main
                ConB_Main;
                ConB_DelayV;
                ConB_DelayH;
                ConB_MedDelay;
                % Continuity
                ConsMat_Zen.*Mu_ZenPar;
                ConsMat_Hor.*Mu_HorPar
                ConsMat_Med.*Mu4;
                ];     

     ConsL   = [
                % Main
                ConsMainL';
                ConsDelayL_V';
                ConsDelayL_H';
                ConsMedDelayL'
                % Continuity
                L_Zen.*Mu_ZenPar;
                L_Hor.*Mu_HorPar;
                L_Med.*Mu4;                
                ];
     ConsP   = ones(length(ConsL),1);
     % Design martix + Observation value + Weighted value
     Com_A = [A;ConsMat];
     Com_L = [dL_Com;ConsL];
     Com_P = [P_Com;ConsP];
     
     % Least squares solution
     [dx,sigma,L_est,v,N,Qx,J] = WLS(Com_A,Com_L,Com_P);
     dL_Com_Rob = dL_Com.*P_Com;

     Record_dx(Loop,:) = dx';
     x_ini(1:StnNum*3)     = x_ini(1:StnNum*3) - dx(1:StnNum*3)';
     x_ini(StnNum*3+1:end) = x_ini(StnNum*3+1:end) + dx(StnNum*3+1:end)';
     
     if max(abs(dx)) < Termination
         ErrorNum = length(find(P_Com==0));
         ResOutput.ErrorRate = ErrorNum/length(P_Com);
         ResOutput.Sigma = sigma;
         Sigmaii = diag(Qx);
         LocSigmaii = Sigmaii(1:3*StnNum)*sigma^2;
         for mm = 1:StnNum
             LocSigma(mm,:) = LocSigmaii(3*mm-2:3*mm);
         end
         ResOutput.Dx = sqrt(LocSigma);      
         break;
     end
end
Loop    % iteration time 

% Seafloor point position
for gg = 1:StnNum
    StnPos(gg,:) =  x_ini(3*gg-2:3*gg);
end

StnDiff = StnPos - x_Jap;
SolRes = [StnSeq ones(StnNum,1) StnPos ones(StnNum,1) x_Jap ones(StnNum,1) StnDiff];

ZenDelay   = x_ini(ZenDelay_Pos);
HorDelay   = x_ini(HorDelay_Pos);
HorNDelay  = HorDelay(1:2:end);
HorEDelay  = HorDelay(2:2:end);
Delay      = {ZenDelay',[HorNDelay',HorEDelay']};

TimeInf.Date     = DateUTC;
TimeInf.BlockZen = MeanSecTime_Zen;
TimeInf.BlockHor = MeanSecTime_Hor;
TimeInf.ObsTime  = [ObsStartTime,ObsEndTime];





