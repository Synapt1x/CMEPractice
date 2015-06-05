function [time, times, X0, X, num_rx, c, V, num_species] = InitializeParameters()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initializes the chemical reaction problem by defining an
% initial time, initial quantities of each reactant and the reaction rates
% of each chemical reaction. 

% The initial quantities, and reaction rates can be changed by the user.
% If the number of reactions or species is changed, additional changes will 
% need to be made in the main program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = 0; % initial time is 0 seconds
times = [0]; % start a vector to hold all times 

X0 = [40 40 20]; % initial amounts of each reactant stored in a vector
X = X0;

num_rx = 3; % the number of different chemical reactions

c = [.02 .01 .02]; % a vector to store the reaction rates of each reaction 

V = [-1 -1 1; -1 1 -1; 1 -2 0]; % amount of species consumed all reactions

num_species = 3;
