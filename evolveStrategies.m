function [ ] = evolveStrategies( )
%This function mutates/recombines strategies 
%
%
%
% 

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
    
    
    
    
    % take best nReplaced parents, xover to make children, children
    % replace worst nReplaced parents
    nReplaced = 2;
    % to store indices of best and worst strategies of each trader
    worstStratsI = NaN(nReplaced, size(agent.conditions, 3));
    bestStratsI = NaN(nReplaced, size(agent.conditions, 3));
    % also store the rest of the traders (the middle guys)
    middleStratsI = NaN(size(agent.conditions, 1) - 2*nReplaced, size(agent.conditions, 3));
    
    for i=1:size(agent.conditions, 3)
        [sortedValues,sortIndex] = sort(agent.strengths(:,:,i),'descend');  % sort the values in descending order
        bestStratsI(:,i) = sortIndex(1:nReplaced);  % keep track of indices of top # nReplaced strengths
        worstStratsI(:,i) = sortIndex(end-nReplaced+1:end);  % keep track of indices of bottom # nReplaced strengths
        middleStratsI(:,i) = sortIndex(nReplaced+1:end-nReplaced);  % keep track of indices of middle guys
    end

    
    
    % for each trader, replace nReplaced worst conditions and strengths with nReplaced
    % children (created by crossing over nth worst strategy with nth best
    % strategy)
    for i=1:size(worstStratsI, 2)
        for ii=1:nReplaced
            badStrength = agent.strengths(worstStratsI(ii,i),:,i); % strength of poor strategy
            goodStrength = agent.strengths(bestStratsI(nReplaced-ii+1,i),:,i); % strength of better strategy
            badWeight = badStrength / (badStrength + goodStrength); % badWeight percent from bad strategy, (1-badweight) percent from good strategy
            goodWeight = 1 - badWeight;
            tempChild = NaN(1, size(agent.conditions, 2)); % child being created
            for iii=1:size(agent.conditions, 2)
                xRand = rand();
                % individual element xovers are proportionate to strategy
                % strength
                if xRand < badWeight
                    tempChild(iii) = agent.conditions(worstStratsI(ii,i),iii,i);
                else
                    tempChild(iii) = agent.conditions(bestStratsI(nReplaced-ii+1,i),iii,i);
                end %if
            end %for iii...
            % actually replace strategy's condition
            agent.conditions(worstStratsI(ii,i),:,i) = tempChild;
            % actually replace strategy's strength (weighted)
            agent.strengths(worstStratsI(ii,i),:,i) = badWeight*badStrength + goodWeight*goodStrength;
            %agent.conditions(worstStratsI(ii,i),:,i) = agent.conditions(bestStrats(nReplaced-ii+1,i),:,i);
            %agent.strengths(worstStratsI(ii,i),:,i) = agent.strengths(bestStrats(nReplaced-ii+1,i),:,i);
        end %for ii...
    end %for i...
    
    
    % xover the rest of the strategies for each trader
    for i=1:size(agent.conditions, 3)
        % generate random vector (permutation) of indices 
        randIndices = randperm(size(middleStratsI,1));
        % ************increment by 2 because we take every pair ****************
        for ii=1:2:length(randIndices)-1
            tempChild = NaN(1, size(agent.conditions, 2)); % child being created
            parent1Index = middleStratsI(randIndices(ii),i);
            parent2Index = middleStratsI(randIndices(ii+1),i);
            for iii=1:size(agent.conditions, 2)
                xRand = rand();
                % individual element xovers are proportionate to strategy
                % strength
                if xRand < 0.5
                    tempChild(iii) = agent.conditions(parent1Index,iii,i);
                else
                    tempChild(iii) = agent.conditions(parent2Index,iii,i);
                end %if
            end %for iii...
            
            % deal with assigning child a strength
            parent1Strength = agent.strengths(parent1Index,:,i);
            parent2Strength = agent.strengths(parent2Index,:,i);
            tempChildStrength = (parent1Strength + parent2Strength) / 2;
            
            % replace worse of the two parents with the child, and also
            % replace the strength value with the new
            if parent1Strength > parent2Strength
                agent.conditions(parent2Index,:,i) = tempChild;
                agent.strengths(parent2Index,:,i) = tempChildStrength;
            else
                agent.conditions(parent1Index,:,i) = tempChild;
                agent.strengths(parent1Index,:,i) = tempChildStrength;
            end %if
            
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

    



end



end

