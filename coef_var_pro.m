function y = coef_var_pro(x)
% Calculate coefficient of variation using Bland and Altman's method (Bland and Altman, 1996).
% Each row of x represents a subject, and each column of x represents a measurement.
%
% Bland JM, Altman DG. Statistics Notes: Measurement error proportional to the mean. BMJ 313: 106–106, 1996.
%
% If no input is given, will use the data from Bland and Altman (1996) to
% calculate the coefficient of variation and to replicate Figure 1 and 2 in
% the paper. 
%
% Author: Xin Di, PhD.

% Data from Bland and Altman (1996)
%x1 = [0.1 0.2 0.2 0.3 0.3 0.4 0.4 0.8 1.0 1.1 1.2 1.9 2.0 2.7 2.8 3.2 4.7 4.9 4.9 7.0]';
%x2 = [0.1 0.1 0.3 0.4 0.4 0.3 1.4 0.5 1.6 0.9 0.9 2.8 1.4 1.4 6.8 2.9 4.5 1.4 3.9 4.0]';

if nargin == 0
    x1 = [0.1 0.2 0.2 0.3 0.3 0.4 0.4 0.8 1.0 1.1 1.2 1.9 2.0 2.7 2.8 3.2 4.7 4.9 4.9 7.0]';
    x2 = [0.1 0.1 0.3 0.4 0.4 0.3 1.4 0.5 1.6 0.9 0.9 2.8 1.4 1.4 6.8 2.9 4.5 1.4 3.9 4.0]';
    x = [x1 x2];
    
    log10x = log10(x);
    
    figure; plot(mean(x,2),abs(x1-x2),'.');
    figure; plot(mean(log10x,2),abs(log10x(:,1)-log10x(:,2)),'.');
    
    y = 10^(sqrt(mean(var(log10x,0,2)))) - 1;
    
else
    %logx = log(x);
    log10x = log10(x);
    
    %y = exp(sqrt(mean(var(logx,0,2)))) - 1;
    y = 10^(sqrt(mean(var(log10x,0,2)))) - 1;
    
end
