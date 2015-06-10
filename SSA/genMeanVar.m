function [tauPrime] = genMeanVar (Rjs, V, X0, eis, gis, tauPrime, aj, a_0, numSpecies)

%numSpecies = 3;

% zero out products, so only Vij's for reactants are left
indsReac = find(V >= 0); % products will have positive v values
nonCrit = V; % store V in another variable
nonCrit(indsReac) = 0; % zero out the Vij's for products

% zero out critical reactions
indsCrit = find(Rjs); % indexes of reactions which are critical will have a 1
nonCrit(indsCrit, :) = 0; % zero out all elements for critical reactions

mean = zeros(1, numSpecies); % blank vector to store mean for each species
var = zeros(1, numSpecies); % blank vector to store variance for each species

ajv = transpose(aj);
%if (nonCrit ~=0)
    for reac = 1:numSpecies % calculate mean and variance for each species
        col = nonCrit ( :, reac); % extract column of Vij's for this species
        colsq = col.* col; % square the v value for each reaction
        mean(reac) = sum(col .* ajv); % formula to calculate mean
        var(reac) = sum(colsq .* ajv); % formula to calculate variance
    end
    
    
    % I am not sure if the formulas for the maximum terms is correctly used
    % here. Is the maximum just for the top part of the term or the whole term?
    
    eg = eis./gis;
    egs = (eis./ gis).^2;
    
    meanNum =max(eg);
    indsMean = find(eg == meanNum);
    indMean = indsMean(1);
    meanTerm = meanNum./ (abs(mean(indMean))); % the maximum of the mean terms
    
    varNum = max (egs);
    indsVar = find(egs == varNum);
    indVar = indsVar(1);
    varTerm = varNum ./ abs((var(indVar))); % the maximum of the variance terms
    
    
    bothTerms = [meanTerm varTerm];
    tauPrime = min(bothTerms); % tau prime is minimum of above two terms
