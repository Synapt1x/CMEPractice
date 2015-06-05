function [tau, j] = TauAndJGen (aj)
    num_rands = length(aj); % find the number of aj's to test
    taus = []; % start a blank vector to store tau values
    for r = 1:num_rands
        ran_j = rand; % generate a new random number
        tauj = (1/aj(r)) * log(1/ran_j); % equation to calculate tau
        taus = [taus tauj]; % store all taus in a vector
    end
    
    tau = min(taus); % return the minimum tau value
    j = find(taus ==tau); % find the index of the minimum tau value
    
