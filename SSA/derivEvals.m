function [all_rxns] = derivEvals ()

syms x1; % symbolic variable for x1
syms x2; % symbolic variable for x2
syms y; % symbolic variable for y
c1 = 2; % reaction rate of reaction 1
c2 = 1; % reaction rate of reaction 2 
c3 = 2; % reaction ate of reaction 3 

syms f(x1,x2,y); %a for reaction 1 (symbolic)
syms g(x1,x2,y); %a for reaction 2 (symbolic)
syms h(x1,x2,y); %a for reaction 3 (symbolic) 

f(x1,x2,y) = c1*x1*x2; % a for reaction 1
g(x1,x2,y) = c2*x1*y; % a for reaction 2
h(x1,x2,y) = (1/2)*c3*(x2*(x2-1)); % a for reaction 3

all_species = [x1,x2,y]; % vector of all species involved in reaction 
all_rxns = [f,g,h]; % 3 different functions to represent 3 different a's 
