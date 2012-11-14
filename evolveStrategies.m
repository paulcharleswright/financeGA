function [ ] = evolveStrategies( )
%This function mutates/recombines strategies 
%
%
%
% 

global agent
    
    %% initially test if any strengths are negative, if so flip action
    for i=1:size(agent.strengths, 3)
        for ii=1:size(agent.strengths, 1)
            if agent.strengths(ii,1,i) < 0
                agent.actions(ii,1,i) = abs(agent.actions(ii,1,i)-1);
            end
        end
    end
    
    
    %% establish groups
    % # elites = # w/ strength > 110, # worst = # w/ strength < 90
    eliteStrengthLimit = 110;
    worstStrengthLimit = 90;
    
    eliteStratsI = NaN(size(agent.conditions, 1), size(agent.conditions, 3));
    worstStratsI = NaN(size(agent.conditions, 1), size(agent.conditions, 3));
    middleStratsI = NaN(size(agent.conditions, 1), size(agent.conditions, 3));
    topHalfStratsI = NaN(size(agent.conditions, 1), size(agent.conditions, 3));
    %allButEliteStratsI = NaN(size(agent.conditions, 1), size(agent.conditions, 3));
    
    for i=1:size(agent.conditions, 3)
        [sortedValues,sortIndex] = sort(agent.strengths(:,:,i),'descend');  % sort the values in descending order
        topIndices = find(sortedValues > eliteStrengthLimit); % find guys w/ strength > eliteStrengthLimit
        bottomIndices = find(sortedValues < worstStrengthLimit); % find guys w/ strength < worstStrengthLimit
        eliteStratsI(1:length(topIndices),i) = sortIndex(1:length(topIndices)); % indices of guys w/ strength > eliteStrengthLimit
        worstStratsI(1:length(bottomIndices),i) = sortIndex(end-length(bottomIndices)+1:end); % indices of guys w/ strength < worstStrengthLimit
        middleStratsI(1:(size(agent.conditions,1)-length(topIndices)-length(bottomIndices)),i) = sortIndex(length(topIndices)+1:end-length(bottomIndices)); % indices of rest of guys
        topHalfStratsI(1:round(size(agent.conditions,1)/2),i) = sortIndex(1:round(end/2)); % keep track of top 50 percent
        %allButEliteStratsI(1:(size(agent.conditions, 1)-length(topIndices)),i) = sortIndex(length(topIndices)+1:end); % keep track of all but elite strategies (for mutation)
    end
    
%     % take best numElite parents, they move on untouched
%     numElite = 
%     nReplaced = 2;
%     % to store indices of best and worst strategies of each trader
%     topHalfStratsI = NaN(nReplaced, size(agent.conditions, 3));
%     worstStratsI = NaN(nReplaced, size(agent.conditions, 3));
%     bestStratsI = NaN(nReplaced, size(agent.conditions, 3));
%     % also store the rest of the traders (the middle guys)
%     middleStratsI = NaN(size(agent.conditions, 1) - 2*nReplaced, size(agent.conditions, 3));
%     
%     for i=1:size(agent.conditions, 3)
%         [sortedValues,sortIndex] = sort(agent.strengths(:,:,i),'descend');  % sort the values in descending order
%         bestStratsI(:,i) = sortIndex(1:nReplaced);  % keep track of indices of top # nReplaced strengths
%         worstStratsI(:,i) = sortIndex(end-nReplaced+1:end);  % keep track of indices of bottom # nReplaced strengths
%         middleStratsI(:,i) = sortIndex(nReplaced+1:end-nReplaced);  % keep track of indices of middle guys
%         topHalfStratsI(:,i) = sortIndex(1:end/2); % keep track of top 50 percent
%     end

    
    
    %% for each trader, replace worstStratsI (indices of worst strategies)
    % with children of topHalfStratsI (indicies of top 50% strategies)
    for i=1:size(worstStratsI, 2)
        % generate random vector (permutation) of indices 
        randTopHalfI = randperm(length(find(topHalfStratsI(:,i)>0))) % permutation of indices of topHalfStratsI that's not NaN
        for ii=1:length(find(worstStratsI(:,i)>0)) % for each value in worstStratsI(:,i) that's not NaN
            tempWorstChild = NaN(1, size(agent.conditions, 2)); % child being created
            parent1Index = topHalfStratsI(randTopHalfI(ii),i); % index is iith guy in randTopHalfI
            parent2Index = topHalfStratsI(randTopHalfI(end-ii+1),i); % index is (end-ii+1)th guy in randTopHalfI
            parent1Strength = agent.strengths(parent1Index,:,i);
            parent2Strength = agent.strengths(parent2Index,:,i);
            for iii=1:size(agent.conditions, 2)
                xRand = rand();
                % individual element xovers are proportionate to strategy
                % strength
                if xRand < (parent1Strength/(parent1Strength+parent2Strength))
                    tempWorstChild(iii) = agent.conditions(parent1Index,iii,i);
                else
                    tempWorstChild(iii) = agent.conditions(parent2Index,iii,i);
                end %if
            end %for iii...
            % replace strategy's condition
            agent.conditions(worstStratsI(ii,i),:,i) = tempWorstChild;
            % replace strategy's strength (weighted)
            agent.strengths(worstStratsI(ii,i),:,i) = parent1Strength*(parent1Strength/(parent1Strength+parent2Strength)) + parent2Strength*(parent2Strength/(parent1Strength+parent2Strength));
        end %for ii...
    end %for i...
    
    
    
    
    
   %% for each trader, xover middleStratsI (the rest of the strategies)
    for i=1:size(middleStratsI, 2)
        % generate random vector (permutation) of indices 
        randMiddleI = randperm(length(find(middleStratsI(:,i)>0))); % permutation of indices of middleStratsI that's not NaN
%         xHalfMiddleI = randMiddleI(1:round(end/2)); % random half used for xover
%         mHalfMiddleI = randMiddleI(end-round(end/2)+2:end); % other half set aside and used for mutation
        for ii=1:length(randMiddleI)
            tempMiddleChild = NaN(1, size(agent.conditions, 2)); % child being created
            parent1Index = middleStratsI(randMiddleI(ii),i); % index is iith guy in randMiddleI
            parent2Index = middleStratsI(randMiddleI(end-ii+1),i); % index is (end-ii+1)th guy in randMiddleI
            parent1Strength = agent.strengths(parent1Index,:,i);
            parent2Strength = agent.strengths(parent2Index,:,i);
            for iii=1:size(agent.conditions, 2)
                xRand = rand();
                % individual element xovers are proportionate to strategy
                % strength
                if xRand < (parent1Strength/(parent1Strength+parent2Strength))
                    tempMiddleChild(iii) = agent.conditions(parent1Index,iii,i);
                else
                    tempMiddleChild(iii) = agent.conditions(parent2Index,iii,i);
                end %if
            end %for iii...
            
            % replace strategy's condition
            if parent1Strength > parent2Strength
                agent.conditions(parent2Index,:,i) = tempMiddleChild;
            else
                agent.conditions(parent1Index,:,i) = tempMiddleChild;
            end %if
            % replace strategy's strength (weighted)
            agent.strengths(middleStratsI(ii,i),:,i) = parent1Strength*(parent1Strength/(parent1Strength+parent2Strength)) + parent2Strength*(parent2Strength/(parent1Strength+parent2Strength));
            
        end %for ii...
        
    end %for i...
    
    
    
    
    
     %% for each trader, replace nReplaced worst conditions and strengths with nReplaced
%     % children (created by crossing over nth worst strategy with nth best
%     % strategy)
%     for i=1:size(worstStratsI, 2)
%         for ii=1:nReplaced
%             badStrength = agent.strengths(worstStratsI(ii,i),:,i); % strength of poor strategy
%             goodStrength = agent.strengths(bestStratsI(nReplaced-ii+1,i),:,i); % strength of better strategy
%             badWeight = badStrength / (badStrength + goodStrength); % badWeight percent from bad strategy, (1-badweight) percent from good strategy
%             goodWeight = 1 - badWeight;
%             tempChild = NaN(1, size(agent.conditions, 2)); % child being created
%             for iii=1:size(agent.conditions, 2)
%                 xRand = rand();
%                 % individual element xovers are proportionate to strategy
%                 % strength
%                 if xRand < badWeight
%                     tempChild(iii) = agent.conditions(worstStratsI(ii,i),iii,i);
%                 else
%                     tempChild(iii) = agent.conditions(bestStratsI(nReplaced-ii+1,i),iii,i);
%                 end %if
%             end %for iii...
%             % actually replace strategy's condition
%             agent.conditions(worstStratsI(ii,i),:,i) = tempChild;
%             % actually replace strategy's strength (weighted)
%             agent.strengths(worstStratsI(ii,i),:,i) = badWeight*badStrength + goodWeight*goodStrength;
%             %agent.conditions(worstStratsI(ii,i),:,i) = agent.conditions(bestStrats(nReplaced-ii+1,i),:,i);
%             %agent.strengths(worstStratsI(ii,i),:,i) = agent.strengths(bestStrats(nReplaced-ii+1,i),:,i);
%         end %for ii...
%     end %for i...
%     
%     
%     
%     
%     
%     % xover the rest of the strategies for each trader
%     for i=1:size(agent.conditions, 3)
%         % generate random vector (permutation) of indices 
%         randIndices = randperm(size(middleStratsI,1));
%         % ************increment by 2 because we take every pair ****************
%         for ii=1:2:length(randIndices)-1
%             tempChild = NaN(1, size(agent.conditions, 2)); % child being created
%             parent1Index = middleStratsI(randIndices(ii),i);
%             parent2Index = middleStratsI(randIndices(ii+1),i);
%             for iii=1:size(agent.conditions, 2)
%                 xRand = rand();
%                 % individual element xovers are proportionate to strategy
%                 % strength
%                 if xRand < 0.5
%                     tempChild(iii) = agent.conditions(parent1Index,iii,i);
%                 else
%                     tempChild(iii) = agent.conditions(parent2Index,iii,i);
%                 end %if
%             end %for iii...
%             
%             % deal with assigning child a strength
%             parent1Strength = agent.strengths(parent1Index,:,i);
%             parent2Strength = agent.strengths(parent2Index,:,i);
%             tempChildStrength = (parent1Strength + parent2Strength) / 2;
%             
%             % replace worse of the two parents with the child, and also
%             % replace the strength value with the new
%             if parent1Strength > parent2Strength
%                 agent.conditions(parent2Index,:,i) = tempChild;
%                 agent.strengths(parent2Index,:,i) = tempChildStrength;
%             else
%                 agent.conditions(parent1Index,:,i) = tempChild;
%                 agent.strengths(parent1Index,:,i) = tempChildStrength;
%             end %if
%             
%         end %for ii...
%         
%     end %for i...
    
    
    
    
    
    %% mutation
    mutRate = 0.2;  % mutation rate
    for i=1:size(agent.conditions, 3) % for every agent
       for ii=1:length(find(middleStratsI(:,i)>0)) % for every strategy EXCEPT the elites and new guys (which replaced the worst guys)
           for iii=1:size(agent.conditions, 2) % for every individual condition
               a = rand();
               if a <= mutRate;   
                   b=rand();  
                   if agent.conditions(middleStratsI(ii,i), iii, i) == -1 
                       if b < 0.5
                           agent.conditions(middleStratsI(ii,i), iii, i) = 0;
                       else
                           agent.conditions(middleStratsI(ii,i), iii, i) = 1;
                       end
                   elseif agent.conditions(middleStratsI(ii,i), iii, i) == 0
                       if b < 0.5
                           agent.conditions(middleStratsI(ii,i), iii, i) = -1;
                       else
                           agent.conditions(middleStratsI(ii,i), iii, i) = 1;
                       end
                    elseif agent.conditions(middleStratsI(ii,i), iii, i) == 1
                       if b < 0.5
                           agent.conditions(middleStratsI(ii,i), iii, i) = -1;
                       else
                           agent.conditions(middleStratsI(ii,i), iii, i) = 0;
                       end
                   end %if find...
               end %if a...
           end %for iii...
       end %for ii...
    end %for i...

    %%



end