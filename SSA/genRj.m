function [Rjs, aj, a_0] = genRj (X0, V, all_rxns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates Ls values for each reaction in order to determine whether the
% reaction is critical. If there are critical reactions, the function
% outputs a variable that tells the main program to call the tau generation
% function for critical reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the minimum value of lj for rj to be considered a critical reaction. This
% can be a whole number between 2-20. It's usually equal to 10
nc = 10;  

numRxns = 3;

species1 = X0(1); % amount of x1
species2 = X0(2); % amount of x2
species3 = X0(3); % amount of y

% find ajs for each reaction and store in a vector
aj = single(all_rxns(species1,species2,species3));
a_0 = sum(aj); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check_elements is used to keep track of which elements in the matrix v
% will need to be check to determine whether they are critical. If an aj is
% negative the entire row for that reaction will be zeroed. If Vij is
% positive, then the one element will be zeroed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Ljs = zeros(1,3);
Rjs = zeros(1,3);

check_rxns = aj>0; %tells which reactions to check
check_elements = V <0;

for check = 1:numRxns
    if check_rxns(check) ==1
        check_els = check_elements(check, :); % row of which elements to check
        Vls = V(check, :);
        XL = X0(check_els);
        VL = Vls(check_els);
        possLs = min(XL./VL);
        Ljs(check) = possLs;
    else
        Ljs(check) = nc+1;
    end
end
Rjs = single(Ljs < nc); % vector of critical reactions


