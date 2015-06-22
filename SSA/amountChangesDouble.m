function [X0] = amountChangesDouble(X0, aj, V, tau, Rjs, numRxns)
%{
Calculates changes in the amounts of all species. Selects one critical
reaction to occur once. All other critical reactions occur 0 times in time
tau. The number of non-critical reactions is determined by poisson distributd
random numbers!
%}

%numRxns = 3;
nonPros = {};
for n = 1:numRxns
    nonPro = find((V(numRxns, :))<0);
    nonPros{n} = nonPro;
end

js = find(Rjs); % find indexes of all critical reactions (j values)
ajc = aj(js); % find ajs for critical reactions
a0c = sum(ajc); % a0c is sum of ajs for critial reactions only

numCrit = length(ajc); % find the number of critical reactions
probs = ones(1, numCrit); % vector to store probability of  critical rxns
prob = 0; % start probability at 0
for num=1:numCrit
    Vrow = V(num,:);
    indsReac = nonPros{num};
    %if Vrow(indsReac) <=0
       % probs(num) = prob;
   % else
        prob = prob + (ajc(num) / a0c); % probability to be tested is sum of all previous probabilities
        probs(num) = prob; % store probability for given reaction
    %end
end

ranTest = rand;
if numCrit >0
    if ranTest < probs(1)
        j = 1; % critical reaction 1 will occur
    elseif ranTest < probs(2)
        j = 2;  % critical reaction 2 will occur
    else
        j = 3; % critical reaction 3 will occur
    end
    
    changeCrit = V(j,:); % retrieve changes caused by critical reaction
    X0 = X0 + changeCrit; % add changes to previous amounts of species
 
end


% changes to concentrations for non-critical reactions
indsNon = find(not(Rjs)); % indexes of non-critical reactions
numNon = length(indsNon); % find number of non-critical reactions

for non = 1:numNon
    indNon = indsNon(non); % index of the reaction
    ajnon = aj(indNon); % retrieve the a value of the reaction
    changeNonCrit = V(indNon, :); % changes to each species from the reaction
    numTimes = poissrnd(ajnon*tau); % number of times the reaction occurs
    totalChange = changeNonCrit.* numTimes; % the change in each species
    X0 = X0 + totalChange; % new amounts of each species
end
