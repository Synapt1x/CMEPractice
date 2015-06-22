function [aj] = ImplicitAj (X0)
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