function [eis, gis] = genEis (epsilon, V, X, numSpecies, numRx)

gis = zeros(1, numSpecies); % blank vector to store gi values for each species
eis = zeros(1, numSpecies); % blank vector to store epsilon i values for each species

% find orders of all reactions
ordersRx = zeros(1, numRx);
for rx = 1 : numRx
    testRow = V(rx, :);
    orderRxinds = find(testRow <0);
    orderRx = -sum(testRow(orderRxinds));
    ordersRx(rx) = orderRx;
end

% find highest order for each species
orders = zeros(numSpecies, 1);
ordersInd = {};
for sp = 1:numSpecies
    allInds = zeros(1, numRx);
    testCol = V(:, sp);
    indsCheck = find(testCol <0);
    allInds(indsCheck) = 1;
    maxOrd = max(ordersRx(indsCheck));
    orders(sp,1) = maxOrd;
    orderCheck = ordersRx .* allInds;
    ordersCheck = find(orderCheck == maxOrd);
    ordersInd{sp} = ordersCheck;
end

% get the current amounts of each species (bottom row of x)
currentX = X(end, :); 

for species = 1:numSpecies % loop through ei values for all species
    Xi = currentX(species); % current amount of one species
    orderSpec = orders(species); 
    ViSpec = -V(:, species);
    %index = ordersInd{species};
    testInds = ordersInd{species};
    testAmounts = max(ViSpec(testInds));
    
    switch orderSpec
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
