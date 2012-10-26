close all
clear all

% This is probably a better way
% Uses matrix representation to store strategies
% each first dimension (row) represents an individual strategy
% each second dimension (column) represents a binary state of the market
% Each third dimension represents an agent and all his strategies


Lstrats = 30;     % first dimension
Ntraders = 400;   % second dimension
Nstrats = 500;     % third dimension


strats = randi([-1 1],Nstrats,Lstrats,Ntraders); %Create random strategies
state = (randi(2,1,Lstrats)-1.5)*2;              %Create a random market state to test with

%state(ones(1,Nstrats),:,ones(1,Ntraders))

%match = strats - state(ones(1,Nstrats),:,ones(1,Ntraders))

% To test if match, 0's mean strategy matches market
test = sum(strats == state(ones(1,Nstrats),:,ones(1,Ntraders)),2) - sum(abs(strats),2);


disp('hi')

%% Bad Mechanism to store agents

% 
% close all;
% clear all;
% 
% %agents = cell(5,1);
% 
% %agents{:}=struct('strategies',zeros(2,2))
% 
% %agents{:}.strategies
% 
% 
% agents = struct('strategies', cell(4,1),'fitness',ones(3,1));
% 
% for i = 1:4
%     agents(i).strategies = randi(2,3,5)-1;
% end
% agents(1).strategies(1,:)
% %size(agents(1).strategies)
% %size([1 1 1 1 1])
% agents(1).strategies(1,:) == [1 1 1 1 1]
% 

