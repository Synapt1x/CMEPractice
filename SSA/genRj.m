function [Rjs, aj, a_0] = genRj (X0, V, nc, numRxns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates Ls values for each reaction in order to determine whether the
% reaction is critical. If there are critical reactions, the function
% outputs a variable that tells the main program to call the tau generation
% function for critical reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the minimum value of lj for rj to be considered a critical reaction. This
% can be a whole number between 2-20. It's usually equal to 10

species1 = X0(1); % amount of x1
species2 = X0(2); % amount of x2
species3 = X0(3); % amount of y
species5 = X0(5);
% find ajs for each reaction and store in a vector. These need to be
% changes based on the reactions defined in initializeParameters. Each aj
% is the partial derivative of that reaction
aj = [0.00001*species1 0.0001*species1*species3 0.5*0.000001*species2*(species2-1) 0.0001*species3*species5];
%aj = single(all_rxns(species1,species2,species3));
a_0 = sum(aj); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check_elements is used to keep track of which elements in the matrix v
% will need to be check to determine whether they are critical. If an aj is
% negative the entire row for that reaction will be zeroed. If Vij is
% positive, then the one element will be zeroed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ljs = zeros(1,3); % define a blank vector to store Lj for each reaction

% If Rj for a reaction is 1, it means that that reaction is critical. If Rj
% is 0 for a reaction, it means that that reaction is not critical. Rj will
% be an input to other functions
Rjs = zeros(1,3); % define a blank vector to store Rj for each reaction

check_rxns = aj>0; % Only reactions with positive ajs will be checked
check_elements = V <0; % Only species that are reactants will be checked

for check = 1:numRxns % loop that generates an Lj for each reaction 
    if check_rxns(check) ==1 % check if aj for reaction is positive
        check_els = check_elements(check, :); % row of which elements to check
        Vls = V(check, :); % extract the V values for the reaction
        XL = X0(check_els); % get the current amounts of each species
        VL = Vls(check_els); % determines which species are reactants
        possLs = min(XL./VL); %  Lj is ratio of amount of species to amoutn that will be consumed
        Ljs(check) = possLs;
    else
        Ljs(check) = nc+1; % if aj is not positive, reaction is not critical
    end
end

% a reaction is critical if its Lj value is less than a predetermined
% amount. This amount is calculated in the genCrit function, based on the
% initial amount of each species, but can be changed. 

Rjs = single(Ljs < nc); 


