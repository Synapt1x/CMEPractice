function [X0] = amountChanges(Old_X, aj, V, num_rxns, tau, Rj)
    
    final_amount = Old_X;
    
    for n=1 :num_rxns % loop through changes in all species from all reactions
        aspec = aj(n); % current a value of a substance
        vspec = V(n); % changes in amounts of substances from each reaction
        
        if (Rj(n) ==0)
            change_amount = 0;
            
        else
            poi_ran = poissrnd(tau*aspec); % generate a poisson random number
            change_amount = poi_ran * vspec; % the change in the substance is the # of reactions * the amount used in each reactin
        end
        final_amount = change_amount + final_amount; % add change to previous amount to get new amount
    end
    X0 = final_amount; 
