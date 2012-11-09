function [ maverage ] = movingAverage( n, t )
%UNTITLED4 Summary of this function goes here
%  returns n-day moving average from price time series

global market

maverage = sum(market.price(t-n:t-1))/n;

end

