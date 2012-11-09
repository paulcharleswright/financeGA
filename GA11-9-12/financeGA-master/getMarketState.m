function [ mstate ] = getMarketState( Lstrats, t )
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
mstate = (randi(2,1,Lstrats)-1.5)*2;

mstate = [market.price(t)>market.price(t-1),...  %price went up last period
    market.price(t-1)>market.price(t-2),...      %price went up 2 periods ago
    market.price(t-2)>market.price(t-3)];        %price went up 3 periods ago

mstate = (mstate - .5)*2;
end
