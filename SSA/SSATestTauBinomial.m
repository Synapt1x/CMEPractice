function SSATestTauBinomial
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

% user chooses how many simulations to run
num_sims = 1;
 
% user chooses the maximum time for each simulation
max_rx = 5;

% evaluate derivatives for all equations. Returns a vector of 3 symbolic
% equations (one for each reaction). Values will be plugged in to the
% symbolic equations to calculate the aj for each reaction 
%all_rxns = derivEvals (); 
tau_prime = 0;

for n = 1:num_sims % loop through all simulations. Plot after each sim
    
    count = 0; % start each simulation with reaction time = 0

    % call intialize parameters to define ititial time and concentrations
    [time, times, X0, X, num_rx, V, num_species] = InitializeParameters ();
    nc = evalCrit(X0);
     while count <=max_rx; % loop through tau steps until max time is reached
     
        % identify all critical reactions
        [Rjs, aj, a_0] = genRj (X0, V,nc); 
    
        % generate one estimate for tau 
        [eis, gis] = genEis (0.05, V, X, num_species, num_rx);
        [tau_prime] = genMeanVar (Rjs, V, X0, eis, gis, tau_prime, aj, a_0);
        

        % comparison for the bound of tau
         compare = 5 * (1/a_0);
        
        if abs(tau_prime) < compare
            % generate 100 individual SSA steps
            for ssaSteps = 1:5
                [tau, j] = TauAndJGen (aj);
                time = time + abs(tau); % find new time by adding tau to previous time
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
             if abs(tau_prime) < tau_double_prime 
                tau = abs(tau_prime);
                % amount each species changes if tau is selected as tau
                % prime
                [X0] = amountChanges(X0, aj, V, num_rx, tau, Rjs);
                time = time + tau; % find new time by adding tau to previous time
                times = [times time]; % add new time to list of times
                X = [X; X0]; % store all X values in a matrix
                count = time; % increment number of reactions
              
             else
                tau = abs(tau_double_prime);
                % amount each species changes if tau is tau double prime
                % (only one critical reaction can occur) 
                [X0] = amountChangesDouble(X0, aj, V, tau, Rjs);
                time = time + tau; % find new time by adding tau to previous time
                times = [times time]; % add new time to list of times
                X = [X; X0]; % store all X values in a matrix
                count = time; % increment number of reactions
             end
        
            
            
        end
        disp(times)
     end
    
    % plotting symbols for different simulation runs 
    type_plots_b = {'b>-', 'b*-', 'bd-', 'bp-', 'bh-', 'b^-'};
    type_plots_r = {'r>-', 'r*-', 'rd-', 'rp-', 'rh-', 'r^-'};
    type_plots_k = {'k>-', 'k*-', 'kd-', 'kp-', 'kh-', 'k^-'};
 
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
toc
