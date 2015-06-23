function SSATestAdaptive
tic
%{
Programmed by: Ella Thomson
Tracks the changes in amounts of three chemical reactants involved in
three chemical reactions. The reactions occur at randomly distributed
times. The program plots the quantities of all three substances vs time.
It produces two plots; one figure with each substance on its own plot,
and one figure with all three substances on the same plot.
%}

% user chooses how many simulations to run
num_sims = 10;

% user chooses the maximum time for each simulation
max_rx = 100;   

% interval used for plotting means and calculating variance
interval = 0.01 * max_rx;

% evaluate derivatives for all equations. Returns a vector of 3 symbolic
% equations (one for each reaction). Values will be plugged in to the
% symbolic equations to calculate the aj for each reaction
%all_rxns = derivEvals ();
tau_prime = 0;

all_values = [];

for n = 1:num_sims % loop through all simulations. Plot after each sim
    
    count = 0; % start each simulation with reaction time = 0
    
    % call intialize parameters to define ititial time and concentrations
    [time, times, X0, X, num_rx, V, num_species] = InitializeParameters ();
    nc = evalCrit(X0);
    while count <=max_rx; % loop through tau steps until max time is reached
        
        % identify all critical reactions
        [Rjs, aj, a_0] = genRj (X0, V,nc, num_rx);
        
        % generate one estimate for tau (tau prime)
        [eis, gis] = genEis (0.05, V, X, num_species, num_rx);
        [tau_prime] = genMeanVar (Rjs, V, X0, eis, gis, tau_prime, aj, a_0, num_species);
        
        % comparison for the bound of tau
        compare = abs(5 * (1/a_0));
        
        if abs(tau_prime) < compare
            % generate 100 individual SSA steps
            for ssaSteps = 1:5
                while count <=(max_rx-0.5)
                    [tau, j] = TauAndJGen (aj);
                    time = time + abs(tau); % find new time by adding tau to previous time
                    times = [times time]; % add new time to list of times
                    
                    Vj = V(j,:); % retrieve V values for the selected reaction
                    X0 = X0 + Vj; % get new X0 value
                   
                    
                    % if species amount is less than 0, correct it
                    b = find(X0<0);
                    X0(b) = 0;
                    X = [X; X0]; % store all X values in a matrix
                    %if time <= max_rx
                    count = time;
                    %end
                end
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
   
                [X0] = ImplicitXX(X, V, X0, tau, num_rx);
                
                time = time + tau; % find new time by adding tau to previous time
                if time > max_rx
                    time = max_rx +0.1;
                end
                times = [times time]; % add new time to list of times
                X = [X; X0]; % store all X values in a matrix
                count = time; % increment number of reactions
                
            else
                tau = abs(tau_double_prime);
                % amount each species changes if tau is tau double prime
                % (only one critical reaction can occur)
                [X0] = amountChangesDouble(X0, aj, V, tau, Rjs, num_rx);
                
                [X0] = ImplicitXX(X, V, X0, tau, num_rx);
                time = time + tau; % find new time by adding tau to previous time
                % if time is greater than the max time, correct it 
                if time > max_rx
                    time = max_rx+0.1;
                end
                times = [times time]; % add new time to list of times
                % if species amount is less than 0, correct it
                b = find(X0<0);
                X0(b) = 0;
                X = [X; X0]; % store all X values in a matrix
                count = time; % increment number of reactions
            end
        end   
    end
    % all species amounts for one simulation
    XX = transpose(X);
    
    % store all times and species amounts for one simulations
    all_values_sim = [times; XX];
    all_values = [all_values all_values_sim]; 
    
    % store all times and species amounts for all simulations 
    all_value_sim = [];
    
    % print the current simulation number (can be removed)
    disp('Current Simulation Number')
    disp(n)
    
end

% put all times and corresponding species amounts in ascending order 
[~,I]=sort(all_values(1,:));
B=all_values(:,I);

times_average = B(1,:); % extract row with all times
x1_average = B(2,:); % extract row with all X1 amounts
x2_average = B(3,:); % extract row with all X2 amounts
y_average = B(4,:); % extract row with all y amounts
z_average = B(5,:); % extract row with all x amounts
q_average = B(6,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculations and plotting for moving average (mean) with number of points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[mean_xs_num, variances_xs_num, times_plot_num, st_dev_pos, st_dev_neg] = StepsMeanVar(times_average,...
    num_species, x1_average, x2_average, y_average, z_average, q_average);


figure(1)

colours = {'b', 'g', 'c', 'r', 'm'};
titles = {'X1 vs Time', 'X2 vs Time', 'Y vs Time', 'Z vs Time', 'Q vs Time'};
Ylabs = {'X1', 'X2', 'Y', 'Z', 'Q'};

for pl = 1:num_species
    subplot(3,2,pl)
    plot(times_plot_num, st_dev_pos(pl,:), colours{pl}) % plots all points from all simulations
    hold on
    plot(times_plot_num, mean_xs_num(pl,:), 'k', 'LineWidth', 3) % plots mean point in each steps interval
    hold on
    plot(times_plot_num, st_dev_neg(pl,:), colours{pl})
    hold on
    title(titles{pl})
    xlabel('Time')
    ylabel(Ylabs{pl})
    axis([0 inf 0 inf])
    hold on
end

varsTitles ={'Variance X1', 'Variance X2', 'Variance Y', 'Variance Z', 'Variance Q'};

for varct = 1:num_species
    disp(varsTitles{varct})
    disp(mean(variances_xs_num(varct,:)))
end

toc
