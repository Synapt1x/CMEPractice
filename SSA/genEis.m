function [eis, gis] = genEis (epsilon, V, X, numSpecies, numRx)

gis = zeros(1, numSpecies); % blank vector to store gi values for each species
eis = zeros(1, numSpecies); % blank vector to store epsilon i values for each species

ordersRx = zeros(1, numRx); % vector to store order of each reaction
for rx = 1 : numRx % loop to find order of each reactions
    testRow = V(rx, :); % extract the V's for the reaction
    orderRxinds = find(testRow <0); % find all species which are products
    orderRx = -sum(testRow(orderRxinds)); % order is the sum of # species consumed
    ordersRx(rx) = orderRx; % store the order of the reaction
end

% find highest order for each species
orders = zeros(numSpecies, 1); % vector to store highest order rxn of each species
ordersInd = {};

for sp = 1:numSpecies % loop to find highest order reaction of each species
    allInds = zeros(1, numRx);
    testCol = V(:, sp); % extract all v values of the species
    indsCheck = find(testCol <0); % find all reactions where species is used
    allInds(indsCheck) = 1;
    
    % if species is never a reactant, the maximum order is 0
    if length(indsCheck) ==0
        maxOrd = 0;
    % maximum order is highest order reaction in which species is a
    % reactant
    else
        maxOrd = max(ordersRx(indsCheck));
    end
    orders(sp,1) = maxOrd; % store order for the species
    orderCheck = ordersRx .* allInds;
    ordersCheck = find(orderCheck == maxOrd);
    ordersInd{sp} = ordersCheck; % store indexes of the reactions 
end

% get the current amounts of each species (bottom row of x)
currentX = X(end, :); 

for species = 1:numSpecies % loop through ei values for all species
    Xi = currentX(species); % current amount of one species
    orderSpec = orders(species);  %retrieve maximum order for the species
    ViSpec = -V(:, species); % extract v values for the species
    
    testInds = ordersInd{species}; 
    testAmounts = max(ViSpec(testInds)); % find maximum amount of species consumed
    
    switch orderSpec % gis depends on highest order of the species
        case 1 % maximum order of reaction for species is 1
            gi = 1;
        case 2 % maximum order of reaction for species is 2
            if testAmounts > 1 % two parts of species used in 1 rxn
                gi = 2+(1/(Xi-1));
            else
                gi = 2;
            end
        case 3 % maximum order of reaction for species is 3
            if testAmounts >2 % three parts of species used in 1 rxn
                gi = 3+(1/(Xi-1)) + (2/(Xi-2));
            elseif testAmounts >1 % two parts of species used in 1 rxn
                gi = (3/2) * (2+(1/(Xi-1)));
            else
                gi = 3;
            end
    end
    gis(species) = gi; % store gi value for this species
end

eis = epsilon ./ gis; % calculate eis for each species
