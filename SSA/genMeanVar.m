function [tauPrime, a_0, aj] = genMeanVar (Rjs, V, X0, eis, gis, all_rxns)

%V = [-1 -1 1; -1 1 -1; 1 -2 0];
%Rjs = [0 0 0];
numReactions = 3;
numSpecies = 3;
%eis = 0.025 * (ones(1, 3));
%gis = [2 2 2]; 

species1 = X0(1); % amount of x1
species2 = X0(2); % amount of x2
species3 = X0(3); % amount of y


a_0 = single(sum(all_rxns(species1,species2,species3))); % a0 is sum of all aj's
aj = single(all_rxns(species1,species2,species3));

% zero out products, so only Vij's for reactants are left
indsReac = find(V > 0); % products will have positive v values
nonCrit = V; % store V in another variable 
nonCrit(indsReac) = 0; % zero out the Vij's for products 

% zero out critical reactions
indsCrit = find(Rjs); % indexes of reactions which are critical will have a 1
nonCrit(:, indsCrit) = 0; % zero out all elements for critical reactions

mean = zeros(1, numSpecies); % blank vector to store mean for each species
var = zeros(1, numSpecies); % blank vector to store variance for each species 

ajv = transpose(aj); 

for reac = 1:numSpecies % calculate mean and variance for each species
    col = nonCrit ( :, reac); % extract column of Vij's for this species
    colsq = col.* col; % square the v value for each reaction
    mean(reac) = sum(col .* ajv); % formula to calculate mean
    var(reac) = sum(colsq .* ajv); % formula to calculate variance
end


% I am not sure if the formular for the maximum terms is correctly used
% here. Is the maximum just for the top part of the term or the whole term?

eg = eis./gis;
egs = (eis./ gis).^2;

meanNum =max(eg);
indMean = find(eg == meanNum);
meanTerm = meanNum./ (abs(mean(indMean))); % the maximum of the mean terms

varNum = max (egs);
indVar = find(egs == varNum);
varTerm = varNum ./ (var(indVar)); % the maximum of the variance terms


bothTerms = [meanTerm varTerm];
tauPrime = min(bothTerms); % tau prime is minimum of above two terms 


