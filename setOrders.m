function tempBook = setOrders(newOrders, time)

global agent
global market

%% Orderbook stores values: 
%%[Price, Quantity, Type, Time, Agent, Strategy Number]

numNewOrders = size(newOrders, 1);
orderBook = market.orderBook;
tempBuy = NaN(numNewOrders, 6);
tempSell = NaN(numNewOrders, 6);
tempBook = NaN(numNewOrders, 6);
buyIndex = 0;
sellIndex = 0;

start = find(isnan(orderBook),1);

for i = 1:numNewOrders
    index = newOrders(i,:);
    % Determine price based on action
    if time == 0
        if agent.action(index(2),index(1)) == 1
            tempBuy(i,1) = lastPrice - normrnd(2,.5);
        elseif agent.action(index(2),index(1)) == 0
            tempSell(i,1) = lastPrice + normrnd(2,.5);
        end
    elseif time > 0
        if agent.action(index(2),index(1)) == 1
            tempBuy(i,1) = lastPrice - normrnd(1,1);
        elseif agent.action(index(2),index(1)) == 0
            tempSell(i,1) = lastPrice + normrnd(1,1);
        end
    end
    % Set order type
    tempBook(i,2) = agent.action(index(2),index(1));
    % Set order size
    tempBook(i,3) = randi(16);
    % Set order time
    tempBook(i,4) = curTime;
    % Set agent/strategy combo which placed order
    tempBook(i,5) = newOrders(i,1);
    tempBook(i,6) = newOrders(i,2);
end

buyIndex = find(tempBook(:,2) == 1);
[~, Y] = sort(tempBook(buyIndex,1),'descend');
tempBuy = tempBook(buyIndex(Y),:);

sellIndex = find(tempBook(:,2) == 0);
[~, K] = sort(tempBook(sellIndex,1));
tempSell = tempBook(sellIndex(K),:);

executedOrders = marketOrder(tempBuy,tempSell,time);