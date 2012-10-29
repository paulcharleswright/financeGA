function [ mstate ] = getMarketState( Lstrats )
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
global conditions
mstate = (randi(2,1,Lstrats)-1.5)*2;

end

