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
Nstrats = 10;     % third dimension
maxNoOrders = 5; % max number of orders an agent can have
tmax = 7;        

%Initialization:
t = 5;
agent = struct('conditions',randi([-1 1],Nstrats,Lstrats,Ntraders),...
    'actions',randi([0 1],Nstrats,1,Ntraders),...
    'strengths',ones(Nstrats,1,Ntraders,tmax)*100);  % Start them all at 100
                                               % Strategy, Trader, then Time
                                               
                                               
market = struct('price',zeros(tmax,1),...
    'state',NaN(tmax,Lstrats),...
    'bestBuy',NaN(tmax,1),...
    'bestSell',NaN(tmax,1),...
    'interestRate',.05,...
    'orderBook',NaN(Ntraders*maxNoOrders,6),...
    'dividend',getDividends(sqrt(.9),sqrt(.1),1,.1,tmax));

%    'orderBookLength',Ntraders*maxNoOrders);
%market.state = getMarketState(6);

while t < tmax
    
    getMarketState(t);
    % Get new market orders
    [ncond, nagent] = getOrders(t);
    
    % Put into order book and update order book
    % Update strengths
    % update market properties, ie, price,
     
    %setOrders([nagent,ncond]);
    
    % mutate / recombine strategies
    evolveStrategies()
    
    %update timestep
    t= t + 1;
end