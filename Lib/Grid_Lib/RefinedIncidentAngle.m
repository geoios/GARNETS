function [T,Y,Z,L,Theta,Iteration,RayInf] = RefinedIncidentAngle(PF,Horizontal,Depth,GridData,WindowNum,Order,Terminate)

WindowData = SearchWindow(Horizontal,GridData,WindowNum);
Iteration = 0;

while 1
    Iteration = Iteration + 1;
    [cos_alfa1,Sig_y] = PFGrid2IncidentAngle(Horizontal,WindowData,Order);   
    Theta = asin(cos_alfa1); 
    [T,Y,Z,L,ts,xx,zz,LL,RayInf] = RayTracing(PF,Theta,+inf,+inf,Depth);
    DeltaYY = abs(Y - Horizontal);

    if DeltaYY < Terminate || Iteration > 50
        break
    end
     
    AddData    = [Y,cos_alfa1];
    WindowData = [WindowData ; AddData];
end

