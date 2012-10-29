close all
clear all

% This is the driver program which will make calls to other subprograms and
% iterate through time. Default settings are determined here.

% Uses matrix representation to store conditions
% each first dimension (row) represents an individual strategy
% each second dimension (column) represents a binary state of the market
% Each third dimension represents an agent and all his strategies

%Global variables that we might want to access in different parts of code
%so we don't need to pass it every time we call the function.

global conditions
global actions

%Constants that don't ever change throughout run:

Lstrats = 3;     % first dimension
Ntraders = 4;   % second dimension
Nstrats = 5;     % third dimension
tmax = 2;

%Initialization:

conditions = randi([-1 1],Nstrats,Lstrats,Ntraders); %Create random strategies
actions = ones(Nstrats,2,Ntraders);
actions(:,1,:) = randi([0 1],Nstrats,1,Ntraders);
state = getMarketState(Lstrats);         
t = 0;


% To test if match, 0's mean strategy matches market
test = sum(conditions == state(ones(1,Nstrats),:,ones(1,Ntraders)),2) - sum(abs(conditions),2)


%to extract only the strategy that each agent should use
% NEED TO SORT STRATEGIES BY STRENGTH BEFOREHAND 
%    so that the first strategy is the best one
%    unless we want a fitness based selection

[cond agent] = find(test ==0)
[useless ind] = unique(agent,'first');

cond = cond(ind)
agent = agent(ind)

% Now index into actions matrix into (agent,cond) and somehow use 
% that action
%actions(cond,1,agent)
actions([2 3] , 1 , [2 3])

%while t < tmax
%    state = getMarketState(Lstrats);
%    
%    
%    
%end


