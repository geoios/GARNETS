function [fitresult,gof,V] = SurfFit(data)

% Method z = f(h,a)
    % Set up fittype and options.
    ft1 = fittype( 'poly55' );% 22 33,45 ...
    opts = fitoptions( ft1 );
    opts.Lower = [-Inf -Inf -Inf -Inf -Inf -Inf]; 
    opts.Robust = 'Bisquare';%robustness
    opts.Upper = [Inf Inf Inf Inf Inf Inf];%
    opts.Normalize = 'on'; 

    % Fit model to data.
    [fitresult, gof] = fit([data(:,1), data(:,2)], data(:,3), ft1, opts );

    % Residual
    V = feval(fitresult,data(:,1),data(:,2)) - data(:,3);