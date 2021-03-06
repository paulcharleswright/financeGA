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

global agent
global market

%Constants that don't ever change throughout run:
Lstrats = 3;     % first dimension
Ntraders = 4;    % second dimension
Nstrats = 5;     % third dimension
tmax = 7;        

%Initialization:
t = 4;

agent = struct('conditions',randi([-1 1],Nstrats,Lstrats,Ntraders),...
    'actions',randi([0 1],Nstrats,1,Ntraders),...
    'strengths',ones(Nstrats,1,Ntraders)*100);

market = struct('price',zeros(100,1),'state',(randi(2,1,Lstrats)-1.5)*2);

market = struct('price',zeros(100,1),...
    'state',getMarketState(Lstrats,4));

while t < tmax
    
    state = getMarketState(Lstrats,t)
    % Get new market orders
    [ncond, nagent] = getOrders();
    nagent
    % Put into order book and update order book
    
    
    % Update strengths
    
    
    % update market properties, ie, price,
    
    
    % mutate / recombine strategies
    
    
    %update timestep
    t= t + 1
end