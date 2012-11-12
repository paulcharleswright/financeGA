function [ mstate ] = getMarketState( t )
%returns the vector that represents the current state of market
%   getMarketState returns a vector of 1's and -1's that reveals true
%   characteristics about the market for agents to compare their conditions
%   to.

%  THIS IS VERY TEMPORARY.

% This will become much more complicated when we have to implement the
% actual rules that govern each of the individual indices in the array
% (i.e. whether priced increased last generation.

% We may also need to pass in / access global variables to check certain
% conditions.
global market
%mstate = (randi(2,1,Lstrats)-1.5)*2;
t
mstate = [market.price(t-1)>market.price(t-2),... %price went up last period
    market.price(t-2)>market.price(t-3),...       %price went up 2 periods ago
    market.price(t-3)>market.price(t-4),...       %price went up 3 periods ago
    market.dividend(t-1)>market.dividend(t-2),... %div   went up last period
    market.dividend(t-2)>market.dividend(t-3),... %div   went up 2 periods ago
    market.dividend(t-3)>market.dividend(t-4),... %div   went up 3 periods ago
    movingAverage(market.dividend,2,t)>movingAverage(market.dividend,3,t)]
    
    % These rules can be easily modified to be any combination desired.
    % We should talk about how many / how diverse we want to be


mstate = (mstate - .5)*2;
end
