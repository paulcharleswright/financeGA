function [ dividends ] = getDividends( a,b,d_bar,var, tmax )
%Creates random vector of dividends
%   getDividends uses some information about desired average returns to
%   calculate a vector of length tmax of random dividends. 
%
%  INPUTS:
%     a is coeffecient of previous log-return 
%     b is coeffecient of gaussion noise
%     d_bar is average dividend
%     var is the variance of the gaussian noise before exponentiation
%
%  OUTPUTS:
%     dividends: array of dividends, one per time period
%
% here is a test example
%    x = getDividends(sqrt(.9),sqrt(.1),1,1,500);

dividends = zeros(1,tmax);
% Just to start the sequence
dividends(1)= d_bar;
% Iterate through remaining. Since purely random process, we can do this
% before the run starts for every time period.

for i = 2:length(dividends)
    dividends(i) = ((dividends(i-1)/d_bar)^a*d_bar*exp(b*randn*var));
end

% If you want to see a plot of the dividends:
plot(dividends);

end