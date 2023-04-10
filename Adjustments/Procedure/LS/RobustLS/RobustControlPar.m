function RobPar = RobustControlPar()
%%% ¿¹²î·½°¸
RobPar.Var         = 'Var';
RobPar.Type2       = 'IGG3';
RobPar.RobustK1    = 3;      %% robust estimation parameter
RobPar.RobustK2    = 2;      %% robust estimation parameter
%RobPar.RobustK3    = 4;  
RobPar.q           = 1/2;
RobPar.UpperIter   = 20;
RobPar.Termination = 10^-4;