function [ cond, nagent ] = getOrders( t )
%This compares the market state to each agents strategies and chooses the
%one with the highest strength. 
%
%
% Output:
%   cond and nagent give the row and depth, respectively, of the condition
%   used in the matrix. Using this, one can extract the associated action
%   or strength if desired. This information will be passed onto the
%   setOrders function which will add the orders to the order book or
%   execute them as market orders.


global agent
global market

curState = market.state(t,:);

Nstrats = size(agent.conditions,1);
Ntraders = size(agent.conditions,3);
% To test if match, 0's mean strategy matches market
test = sum(agent.conditions == curState(ones(1,Nstrats),:,ones(1,Ntraders)),2)...
    - sum(abs(agent.conditions),2);

% to extract only the strategy that each agent should use

[cond nagent] = find(test == 0);

%Needs to be tested to see if works to find most fit strategy
% Is this even how we want to do this?

ind = sub2ind([Nstrats,Ntraders],cond,nagent);

[y, i] = sort(agent.strengths(ind));

cond = cond(i);
nagent = nagent(i);

[useless ind] = unique(nagent,'last'); %Ensure 1 action per agent

cond = cond(ind);     % Now only one condition per agent 
nagent = nagent(ind); % And their corresponding agent

end

