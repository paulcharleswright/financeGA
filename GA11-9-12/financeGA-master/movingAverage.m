function [ maverage ] = movingAverage( func, n, t)
%Returns simple n-poing moving average of func
%  returns n-day moving average from func data time series

global market

maverage = sum(func(t-n:t-1))/n;

end

