function [x,sigma,L_est,v,N,Qx,J] = WLS(A,L,P)
%% WLS(A,L)
%% Function:Obtain the LS estimations
 %% inputs:
  % + A  %   the design matrix
  % + L  %   obsevations 
  % + Px    % weights for parameters with porior information
 %% outputs
  % + LSopt.x   % LS parameter estimaton
  % + LSopt.v   % LS residual
  % + LSopt.sig % variance of unit weight
  % + LSopt.L_est % approximation of L
  % + LSopt.N   % A'PA,weight matrix of parameters
  % + LSopt.Qx  % cofactor matrix of parameters
  % + LSopt.J   % --
%%%%%%%%%%%%%%%%%%%%%%% Test code %%%%%%%%%%%%%%%%%%%%%%%%%%%
% nargout == 1
% A=[1 -1;-1 2;2 -3];
% L=[5;-4;10];
% P=eye(3);
% [x] = WLS(A,L)

% nargout < 5
% A=[1 -1;-1 2;2 -3];
% L=[5;-4;10];
% P=eye(3);
% [x,sigma,L_est,v] = WLS(A,L,P)

% else
% A=[1 -1;-1 2;2 -3];
% L=[5;-4;10];
% P=eye(3);
% [x,sigma,L_est,v,N,Qx,J] = WLS(A,L,P)
%% Outputs:
% nargout == 1
% x=[6.333 1.000]

% nargout < 5
% x=[6.333 1.000]
% sigma = 0.5774
% L_est = [5.333 -4.333 9.667]
% v = [-0.333 0.333 0.333]

%else
% x=[6.333 1.000]
% sigma = 0.5774
% L_est = [5.333 -4.333 9.667]
% v = [-0.333 0.333 0.333]
% N = [6 -9;-9 14]
% Qx = [4.667 3.000;3.000 2.000]
% J = [0.667 0.333 0.333;0.333 0.667 -0.333;0.333 -0.333 0.667]
%[x,sigma,L_est,v,N,Qx,J] = WLS(A,L,P)
  [n,m] = size(A);
  if nargout == 1
     x = GaussEI(A,L,P);                   %if the number of outputs is only one,can use the GuassEI
  elseif nargout < 5
     [x RSS] = RecursionGuass_El(A,L,P);   %if the number of outputs is no more than five,can use the RecursionGuass_El
     sigma   = sqrt(RSS/(n-m));            %Negative values appear!
  if nargout == 2; return; end
     L_est = A*x;                          %get an approximation of L
     v     = L - L_est;                    %get the residual
  else                                     %traditional procedure
     [x,sigma,L_est,v,N,Qx,J] = OWLS(A,L,P);
  end