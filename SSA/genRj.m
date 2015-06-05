function [Rjs] = genRj (X0, V, all_rxns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generates Ls values for each reaction in order to determine whether the
% reaction is critical. If there are critical reactions, the function
% outputs a variable that tells the main program to call the tau generation
% function for critical reactions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the minimum value of lj for rj to be considered a critical reaction. This
% can be a whole number between 2-20. It's usually equal to 10
nc = 10;  

species1 = X0(1); % amount of x1
species2 = X0(2); % amount of x2
species3 = X0(3); % amount of y

% find ajs for each reaction and store in a vector
aj = single(all_rxns(species1,species2,species3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check_elements is used to keep track of which elements in the matrix v
% will need to be check to determine whether they are critical. If an aj is
% negative the entire row for that reaction will be zeroed. If Vij is
% positive, then the one element will be zeroed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find which reactions have negative aj's, zero their whole row
first_row = aj>0;
first_col= transpose(first_row);

% append two columns of the same values to the first column to make a
% matrix. One row is for each reaction, one column is for each species 
check_elements = double(repmat(first_col,1,3));

% find indexes of non-zero reactions (the elements in these rows will be
% tested later
indexes = find(first_row);

% find negative Vij's for reactions which are not zeroed out
% negative Vij's will have a 1 in check_element, positive Vij's will have a
% 0 in check_element
check_elements(indexes, :) = V(indexes, :)<0;



% Stores the Lj value for all reactions
Ljs = zeros(1,3);

for x = 1:3 % generates an lj value for each reaction

    Vs = V(x,:); % chooses row of Vij values for a reaction
    
    check = check_elements(x,:); % finds non zero elements 
    ind = find(check); % finds indexes of non zero elements
    x_to_check = X0(ind); % finds x's of indexes determined above
    V_to_check = Vs(ind); % finds vs of indexes determined above
    
    Ls = ceil(x_to_check ./ abs(V_to_check)); % find lj for all elements
    if length(Ls) ~= 0
        Ljs(x) = min(Ls); % find lj for one reaction and store it (minimum Lj value)
    else
        Ljs(x) = nc;
    end

end

Rjs = single(Ljs < nc); % vector of critical reactions
