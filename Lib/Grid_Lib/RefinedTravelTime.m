function [Time,Sig_y] = RefinedTravelTime(Horizontal,GridData,WindowNum,Order)
WindowData = SearchWindow(Horizontal,GridData,WindowNum);
[Time,Sig_y] = PFGrid2IncidentAngle(Horizontal,WindowData,Order);
end