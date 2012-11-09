function [ cond, nagent ] = getOrders(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


global agent
global market

Nstrats = size(agent.conditions,1);
Ntraders = size(agent.conditions,3);
% To test if match, 0's mean strategy matches market
test = sum(agent.conditions == market.state(ones(1,Nstrats),:,ones(1,Ntraders)),2)...
    - sum(abs(agent.conditions),2);

% to extract only the strategy that each agent should use

[cond nagent] = find(test == 0);

%Needs to be tested to see if works to find most fit strategy
% Is this even how we want to do this?

[y, i] = sort(agent.strengths(cond,:,nagent));


% Need to check that this works
cond = cond(i);
nagent = nagent(i);

[useless ind] = unique(nagent,'first'); %Ensure 1 action per agent

cond = cond(ind);     % Now only one condition per agent 
nagent = nagent(ind); % And their corresponding agent

end

