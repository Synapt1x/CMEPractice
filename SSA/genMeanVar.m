function [tauPrime, a_0, aj] = genMeanVar (Rjs, V, X0, eis, gis)

%V = [-1 -1 1; -1 1 -1; 1 -2 0];
%Rjs = [0 0 0];
numReactions = 3;
numSpecies = 3;
%eis = 0.025 * (ones(1, 3));
%gis = [2 2 2]; 

species1 = X0(1); % amount of x1
species2 = X0(2); % amount of x2
species3 = X0(3); % amount of y

syms x1; % symbolic variable for x1
syms x2; % symbolic variable for x2
syms y; % symbolic variable for y
c1 = 2; % reaction rate of reaction 1
c2 = 1; % reaction rate of reaction 2 
c3 = 2; % reaction ate of reaction 3 

nummat = zeros(numSpecies,numReactions); % blank matrix to hold f values
changes = [-1, -1, +1;-1,1,-2;1,-1,0]; % changes in species quantities from reactions
deriv={}; % blank cell to hold derivative symbolic function 

syms f(x1,x2,y); %a for reaction 1 (symbolic)
syms g(x1,x2,y); %a for reaction 2 (symbolic)
syms h(x1,x2,y); %a for reaction 3 (symbolic) 

f(x1,x2,y) = c1*x1*x2; % a for reaction 1
g(x1,x2,y) = c2*x1*y; % a for reaction 2
h(x1,x2,y) = (1/2)*c3*(x2*(x2-1)); % a for reaction 3

all_species = [x1,x2,y]; % vector of all species involved in reaction 
rxns = {f,g,h}; % 3 different function to represent 3 different a's
all_rxns = [f,g,h]; % 3 different functions to represent 3 different a's 
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


