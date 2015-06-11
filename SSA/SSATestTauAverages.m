function SSATestMultiSims
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
num_sims = 10;

% user chooses the maximum time for each simulation
max_rx = 100;

% interval used for plotting means and calculating variance
interval = 0.05 * max_rx;


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
        
        % generate one estimate for tau
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
                time = time + tau; % find new time by adding tau to previous time
                if time > max_rx
                    time = max_rx+0.1;
                end
                times = [times time]; % add new time to list of times
                b = find(X0<0);
                X0(b) = 0;
                X = [X; X0]; % store all X values in a matrix
                count = time; % increment number of reactions
            end
        end   
    end
    XX = transpose(X);
    all_values_sim = [times; XX];
    all_values = [all_values all_values_sim];
    all_value_sim = [];
    disp('Current Simulation Number')
    disp(n)
    
end
[~,I]=sort(all_values(1,:));
B=all_values(:,I);

times_average = B(1,:);
x1_average = B(2,:);
x2_average = B(3,:);
y_average = B(4,:);
z_average = B(5,:);


% calculations and plotting for moving average (mean)

mean_times = 0:interval:max_rx;
num_pts = length(mean_times);
mean_x1 = zeros(1, num_pts);
mean_x1(1) = x1_average(1);
mean_x2 = zeros(1, num_pts);
mean_x2(1) = x2_average(1);
mean_y = zeros(1, num_pts);
mean_y(1) = y_average(1);
mean_z = zeros(1, num_pts); 
mean_z(1) = z_average(1); 
ints = [0];
count = 1;
for int = interval:interval:max_rx
    count = count+1;
    ints = [ints int];
    less = times_average > (ints(count-1));
    more = times_average <= (ints(count));
    bet = less.*more;
    between = find(bet);
    mean_x1(count) = mean(x1_average(between));
    mean_x2(count) = mean(x2_average(between));
    mean_y(count) = mean(y_average(between));
    mean_z(count) = mean(z_average(between));
end


figure(2)

% first plot displays x1 amount vs time
subplot(2,2,1)
plot(times_average, x1_average, 'b')
hold on
plot(mean_times,mean_x1, 'k', 'LineWidth', 3)
title('Average X1 Amount vs Time')
xlabel('Time')
ylabel('X1 Amount')
axis([0 inf 0 inf])
hold on

% second plot displays x2 amount vs time
subplot(2,2,2)
plot(times_average, x2_average, 'r')
hold on
plot(mean_times, mean_x2, 'k', 'LineWidth', 3)
title('Average X2 Amount vs Time')
xlabel ('Time')
ylabel('X2 Amount')
axis([0 inf 0 inf])
hold on

% third plot displays y amount vs time
subplot(2,2,3)
plot(times_average ,y_average, 'g')
hold on
plot(mean_times, mean_y, 'k', 'LineWidth', 3)
title('Y Amount vs Time')
xlabel('Time')
ylabel('Y Amount')
axis ([0 inf 0 inf])
hold on

% third plot displays y amount vs time
subplot(2,2,4)
plot(times_average ,z_average, 'c')
hold on
plot(mean_times, mean_z, 'k', 'LineWidth', 3)
title('Z Amount vs Time')
xlabel('Time')
ylabel('Z Amount')
axis ([0 inf 0 inf])
hold on


toc
