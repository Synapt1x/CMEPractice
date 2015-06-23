function [time, times, X0, X, num_rx, V, num_species] = InitializeParameters()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initializes the chemical reaction problem by defining an
% initial time, initial quantities of each reactant and the reaction rates
% of each chemical reaction. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = 0; % initial time is 0 seconds

times = [0]; % start a vector to hold all times 

X0 = [400 400 400 0 400]; % initial amounts of each reactant stored in a vector

X = X0; % used to store amounts of species at all time pts for one sim

num_rx = 4; % the number of different chemical reactions

V = [-1 3 1 1 0; -1 2 -1 0 1; 1 -2 0 1 0; 0 2 -1 0 -1]; % v values for all reactions

num_species = 5; % the number of species involved in all reactions




