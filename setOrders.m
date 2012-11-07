function orderBook = storeOrders(newOrders)

global agent
global market

%% Orderbook stores values: 
%%[Price, Quantity, Time, Agent, Strategy Number]

maxNumOrders = 3;
totalAgents = length(agent.actions);
bookSize = maxNumOrders * totalAgents

orderBook = zeros(bookSize, 5);

for i = 1:bookSize
    % Determine price based on action
    if agent.action(i) == 1
      orderBook(i,1) = lastPrice - randi(10);
    elseif agent.action(i) == 0
      orderBook(i,1) = lastPrice + randi(10);
    end
    % Set order size
    orderBook(i,2) = randi(16);
    % Set order time
    orderBook(i,3) = curTime;
    % Set agent/strategy combo which placed order
    orderBook(i,4) = newOrders(i,1);
    orderBook(i,5) = newOrders(i,2);
    
end

