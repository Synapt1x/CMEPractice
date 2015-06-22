function [X] = ImplicitXX(X, V, tau, num_rxns)

% xnew is an initial guess for the species amounts
xnew = X(end, :);

% xold is the species amounts at the previous time step 
xold = X(end-1, :);

criteria = 10;
diff = cirteria + 1;

while (diff >=criteria)
    % generate the first term
    firstTerm = xold; 
    
    % Generate the second term
    ajsec = ImplicitAj(xnew);
    secondTermint = [];
    for sec = 1:num_rxns
        interSec = ajsec(sec) * V(sec, :) * tau;
        secondTermint = [secondTerm; interSec] ;
    end
    secondTerm = sum(secondTermint);
    
    % generate the third term 
    ajthird = ImplicitAj(xold);
    thirdTermInt = [];
    for thir = 1: num_rxns
        thirdFirst = poissrnd(ajthird(thir) * tau);
        thirdSecond = aj(thir) * tau;
        interThird = V(thir, :) * (thirdFirst - thirdSecond);
        thirdTermInt = [thirdTermInt ; interThird];
    end
    thirdTerm = sum(thirdTermInt); 
    
    xupdate = firstTerm + secondTerm + thirdTerm;
    intdiff = ((xupdate - xnew)./(xupdate)) *100;
    diff = mean(intdiff);
    xnew = xupdate;
end


X(end, :) = xnew;

