function [xnew] = ImplicitXX(X, V, X0, tau, num_rxns)

% xnew is an initial guess for the species amounts
xnew = X0;

% xold is the species amounts at the previous time step 
xold = X(end, :);

% maximum tolerance between subsequent estimates
criteria = 10;
diff = criteria + 1;

while (diff >=criteria) % loop through new estimates of X(t+tau)
    % generate the first term for implicit X generation
    firstTerm = xold; 
    
    % Generate the second term
    ajsec = ImplicitAj(xnew); % evaluate aj with X(t + tau) 
    secondTermint = []; % vector to store each reaction
    for sec = 1:num_rxns % loop through second term for all reactions
        interSec = ajsec(sec) * V(sec, :) * tau; 
        secondTermint = [secondTermint; interSec] ;
    end
    secondTerm = sum(secondTermint); % produce a vector of changes to X
    
    % generate the third term 
    ajthird = ImplicitAj(xold); % generate aj at x(t)
    thirdTermInt = []; % vector to store each reaction
    for thir = 1: num_rxns % loop through third term for all reactions
        thirdFirst = poissrnd(ajthird(thir) * tau); 
        thirdSecond = ajthird(thir) * tau;
        interThird = V(thir, :) * (thirdFirst - thirdSecond);
        thirdTermInt = [thirdTermInt ; interThird];
    end
    thirdTerm = sum(thirdTermInt); 
   
    xupdate = firstTerm + secondTerm + thirdTerm; % update estimate for X
    intdiff = ((xupdate - xnew)./(xupdate)) *100; % percent difference between subsequent updates
    diff = mean(intdiff); % average of percent differences
    xnew = xupdate; % get new estimate for X
end


