function [all_rxns] = derivEvals ()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uses symbolic variables to calculate and store the aj equations for all
% reactions. It outputs the unsolved equations as symbolic equations stored
% in a vector.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

syms x1; % symbolic variable for x1
syms x2; % symbolic variable for x2
syms y; % symbolic variable for y
c1 = .02; % reaction rate of reaction 1
c2 = .01; % reaction rate of reaction 2 
c3 = .02; % reaction ate of reaction 3 

% define three symbolic functions which will be used to evaluate the aj's
% for each reaction (f for reaction 1, g for reaction 2, h for reaction 3)
syms f(x1,x2,y); 
syms g(x1,x2,y);
syms h(x1,x2,y); 

f(x1,x2,y) = c1*x1*x2; % a for reaction 1 (symbolic)
g(x1,x2,y) = c2*x1*y; % a for reaction 2 (symbolic) 
h(x1,x2,y) = (1/2)*c3*(x2*(x2-1)); % a for reaction 3 (symbolic) 

all_rxns = [f,g,h]; % 3 different functions to represent 3 different a's 

