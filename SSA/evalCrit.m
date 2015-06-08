function nc = evalCrit(X0)
averageStart = sum(X0) / length(X0);
nc = 0.1.* averageStart; 
