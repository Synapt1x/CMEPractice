close all
clear all
clc 
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmed by: Ella Thomson
% Tracks the changes in amounts of three chemical reactants involved in
% three chemical reactions. The reactions occur at randomly distributed
% times. The program plots the quantities of all three substances vs time.
% It produces two plots; one figure with each substance on its own plot,
% and one figure with all three substances on the same plot. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prompt = 'How many simulations would you like to run?';
num_sims = input(prompt);
 
prompt = 'What is the maximum time? (less than 0.07 seconds)';
max_rx = input(prompt) ;

for n = 1:num_sims
    % asks the user how many reactions they want to track

    go_ahead = 1; % will be tested to determine whether to plot
    count = 0;

    % call intialize parameters to define ititial time and concentrations
    [time, times, X0, X, num_rx, c, V, num_species] = InitializeParameters ();

 

    while count <max_rx;
        
        % identify all critical reactions
        [Rjs] = genRj (X0, V); 
    
        [tau_prime, a_0, aj] = genTauPrime (Rjs, V, X0);

        compare = 10 * (1/a_0);
        
        if tau_prime < compare
            % generate 100 individual SSA steps
            for ssaSteps = 1:10
                [tau, j] = TauAndJGen (aj);
                time = time + tau; % find new time by adding tau to previous time
                times = [times time]; % add new time to list of times
    
                Vj = V(j,:); % retrieve V values for the selected reaction
                X0 = X0 + Vj; % get new X0 value
                X = [X; X0]; % store all X values in a matrix
                count = time;
            end
    
        else
            % generate tau double prime
            [tau_double_prime] = genTauDoublePrime(aj, Rjs);   
 
            % generate changes to species amounts from reactions during tau
             if tau_prime < tau_double_prime 
                tau = tau_prime;
                % amount each species changes if tau is selected as tau
                % prime
                [X0] = amountChanges(X0, aj, V, num_rxns, tau, Rjs);
              
             else
                tau = tau_double_prime;
                % amount each species changes if tau is tau double prime
                % (only one critical reaction can occur) 
                [X0] = amountChangesDouble(X0, aj, V, tau, Rjs);
             end
        
            time = time + tau; % find new time by adding tau to previous time
            times = [times time]; % add new time to list of times
            X = [X; X0]; % store all X values in a matrix
            count = time; % increment number of reactions
        end
    end
    
    type_plots_b = {'b-', 'b*', 'bd', 'bp', 'bh', 'b^'};
    type_plots_r = {'r-', 'r*', 'rd', 'rp', 'rh', 'r^'};
    type_plots_k = {'k-', 'k*', 'kd', 'kp', 'kh', 'k^'};
    
    if go_ahead ==1 % check if plotting will occur
        figure(1) 
    
        % first plot displays x1 amount vs time
        subplot(3,1,1)
        plot(times, X(:,1), type_plots_b{n})
        title('X1 Amount vs Time')
        xlabel('Time')
        ylabel('X1 Amount')
        hold on

        % second plot displays x2 amount vs time
        subplot(3,1,2)
        plot(times, X(:,2), type_plots_r{n})
        title('X2 Amount vs Time')
        xlabel ('Time')
        ylabel('X2 Amount')
        hold on

        % third plot displays y amount vs time 
        subplot(3,1,3)
        plot(times,X(:,3), type_plots_k{n})
        title('Y Amount vs Time') 
        xlabel('Time')
        ylabel('Y Amount') 
        hold on 

    end
end
toc
