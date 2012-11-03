function [ ] = evolveStrategies( )
%This function mutates/recombines strategies 
%
%
%
% 

global agent
    
    % initially test if any strengths are negative, if so flip action
    for i=1:size(agent.strengths, 3)
        for ii=1:size(agent.strengths, 1)
            if agent.strengths(ii,1,i) < 0
                agent.actions(ii,1,i) = abs(agent.actions(ii,1,i)-1);
            end
        end
    end
    
    % number of poor strategies replaced by best ones
    nReplaced = 2;
    % to store indices of best and worst strategies of each trader
    worstStrats = NaN(nReplaced, size(agent.conditions, 3));
    bestStrats = NaN(nReplaced, size(agent.conditions, 3));
    
    for i=1:size(agent.conditions, 3)
        [sortedValues,sortIndex] = sort(agent.strengths(:,:,i),'descend');  % sort the values in descending order
        bestStrats(:,i) = sortIndex(1:nReplaced);  % keep track of indices of top # nReplaced strengths
        worstStrats(:,i) = sortIndex(end-nReplaced+1:end);  % keep track of indices of bottom # nReplaced strengths
    end

    
    
    % for each trader, replace nReplaced worst conditions and strengths with nReplaced
    % best conditions and strengths - (NOT keeping RESPECTIVE conditions and
    % strengths together........)
    for i=1:size(worstStrats, 2)
        for ii=1:nReplaced
            agent.conditions(worstStrats(ii,i),:,i) = agent.conditions(bestStrats(nReplaced-ii+1,i),:,i);
            %agent.strengths(worstStrats(ii,i),:,i) = agent.strengths(bestStrats(nReplaced-ii+1,i),:,i);
        end %for ii...
    end %for i...
    
    
    % mutation
    mutRate = 0.2;  % mutation rate
    for i=1:size(agent.conditions, 3) % for every agent
       for ii=1:size(agent.conditions, 1) % for every strategy
           for iii=1:size(agent.conditions, 2) % for every individual condition
               a = rand();
               if a <= mutRate;   
                   b=rand();  
                   if agent.conditions(ii, iii, i) == -1 
                       if b < 0.5
                           agent.conditions(ii, iii, i) = 0;
                       else
                           agent.conditions(ii, iii, i) = 1;
                       end
                   elseif agent.conditions(ii, iii, i) == 0
                       if b < 0.5
                           agent.conditions(ii, iii, i) = -1;
                       else
                           agent.conditions(ii, iii, i) = 1;
                       end
                    elseif agent.conditions(ii, iii, i) == 1
                       if b < 0.5
                           agent.conditions(ii, iii, i) = -1;
                       else
                           agent.conditions(ii, iii, i) = 0;
                       end
                   end %if find...
               end %if a...
           end %for iii...
       end %for ii...
    end %for i...

    % xover



end

