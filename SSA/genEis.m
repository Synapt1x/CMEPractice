function [eis, gis] = genEis (epsilon, V, X, numSpecies, numRx)
%numSpecies = 3;
%numRx = 3;
%epsilon = 0.05;
%V = [-1 -1 1; -1 1 -1; 1 -2 0]; % v values for all reactions
%X = [1 2 3; 40 40 20];
orders = []; % blank vector to store the order of each reaction
% it may be possible to input the orders as a vector. The reactions are not
% changing and this will reduce the time required to calculate the orders
% each time this function is called 


gis = zeros(1, numRx); % blank vector to store gi values for each species
eis = zeros(1, numRx); % blank vector to store epsilon i values for each species

for row = 1:numRx % makes a vector of the orders of each reaction 
    testRow = V(row, :); % vector for one species being used in all rxn's
    orderRowLength = find(testRow <0); % find reactions where species is used
    orderRow = length(orderRowLength); % num of reactions where species is used
    orders(row, 1) = orderRow; % store all orders in a vector 
end
    

% get the current amounts of each species (bottom row of x)
currentX = X(end, :); 

for species = 1:numSpecies % loop through ei values for all species
    allOrdNeg = V(species, :); % extract the column of reactants for 1 species
    allOrdPos = - allOrdNeg;
    rxToTest = find(allOrdNeg <0); % find which reations use up this species
    orderSpec = max(orders(rxToTest)); % find maximum order of species
    orderInd = find(orders == orderSpec); % num of reaction with maximum order
    Xi = currentX(species); % current amount of one species
    
    
    switch orderSpec
        case 1 % maximum order of reaction for species is 1
        gi = 1;
        case 2 % maximum order of reaction for species is 2
            if allOrdPos(orderInd) > 1 % two parts of species used in 1 rxn
                gi = 2+(1/(Xi-1));
            else
                gi = 2;
            end
        case 3 % maximum order of reaction for species is 3
            if allOrdPos(orderInd) >2 % three parts of species used in 1 rxn
                gi = 3+(1/(Xi-1)) + (2/(Xi-2));
            elseif allOrdPos(orderInd) >1 % two parts of species used in 1 rxn
                gi = (3/2) * (2+(1/(Xi-1)));
            else
                gi = 3;
            end
    end
    gis(species) = gi; % store gi value for this species
end

eis = epsilon ./ gis; % calculate eis for each species
    


