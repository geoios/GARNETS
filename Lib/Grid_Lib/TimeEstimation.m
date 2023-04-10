function [Time,SigmaY] = TimeEstimation(x,TimeGrid,FitNum,FitOrder)
WindowData = SearchWindow(x,TimeGrid,FitNum);  
[Time,SigmaY] = PFGrid2IncidentAngle(x,WindowData,FitOrder); 
end

