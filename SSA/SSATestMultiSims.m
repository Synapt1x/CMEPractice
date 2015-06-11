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
num_sims = 100;

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


% calculations and plotting for moving average (mean)

% vector to store time for each interval 
mean_times = 0:interval:max_rx;
% number of intervals to be used for mean calculation
num_pts = length(mean_times);

% blank vector to store x1 amounts at each interval
mean_x1 = zeros(1, num_pts);
mean_x1(1) = x1_average(1);

% blank vector to store x2 amounts at each interval
mean_x2 = zeros(1, num_pts);
mean_x2(1) = x2_average(1);

% blank vector to sore y amounts at each interval
mean_y = zeros(1, num_pts);
mean_y(1) = y_average(1);

% blank vector to store z amounts at each interval
mean_z = zeros(1, num_pts); 
mean_z(1) = z_average(1); 

% vector to store the current count of the for loop below 
ints = [0];
count = 1;

% vector to store interval variances for x1
variances_x1 = zeros(1, num_pts);

% vector to store interval variances for x2
variances_x2 = zeros(1, num_pts);

% vector to store inerval variances for y
variances_y = zeros(1, num_pts);

% vector to store interval variances for z
variances_z = zeros(1, num_pts);

for int = interval:interval:max_rx % generates mean and variance for each interval
    count = count+1; % increment the counter
    ints = [ints int]; % store current count 
    less = times_average > (ints(count-1)); % lower end of range 
    more = times_average <= (ints(count)); % upper end of range
    bet = less.*more; % will generate a 1 for all time indexes to be considered
    between = find(bet); % find indexes of times to be considered
    allx1s = x1_average(between); % all x1 amounts in the range
    allx2s = x2_average(between); % all x2 amounts in the range
    allys = y_average(between); % all y amounts in the range
    allzs = z_average(between); % all z amounts in the range
    
    num_between = length(allx1s); % the number of times in the range
    
    % calculations for means
    mean_x1(count) = mean(allx1s); % average of x1 amounts in the range
    mean_x2(count) = mean(allx2s); % average of x2 amounts in the range
    mean_y(count) = mean(allys); % average of y amounts in the range
    mean_z(count) = mean(allzs); % average of z amounts in the range
    
    % calculations for variances
    % the overall variance in each interval is the sum of all variances in
    % that interval. The variances for x1, x2, y and z are calculated
    % separately
    varsX1 = ((allx1s-mean_x1(count)).^2)./num_between;
    variances_x1(count) = sum(varsX1); 
    
    varsX2 = ((allx2s-mean_x2(count)).^2)./num_between;
    variances_x2(count) = sum(varsX2);
    
    varsY = ((allys-mean_y(count)).^2)./num_between;
    variances_y(count) = sum(varsY);
    
    varsZ = ((allzs-mean_z(count)).^2)./num_between;
    variances_z(count) = sum(varsZ);
end

figure(2)

% first plot displays average x1 amount vs time
subplot(2,2,1)
plot(times_average, x1_average, 'b') % plots all points from all simulations
hold on
plot(mean_times,mean_x1, 'k', 'LineWidth', 3) % plots mean point in each time interval
title('Average X1 Amount vs Time (Time Intervals)')
xlabel('Time')
ylabel('X1 Amount')
axis([0 inf 0 inf])
hold on

% second plot displays x2 amount vs time
subplot(2,2,2)
plot(times_average, x2_average, 'r') % plots all points from all simulations
hold on
plot(mean_times, mean_x2, 'k', 'LineWidth', 3) % plots mean point in each interval
title('Average X2 Amount vs Time (Time Intervals)') 
xlabel ('Time')
ylabel('X2 Amount')
axis([0 inf 0 inf])
hold on

% third plot displays y amount vs time
subplot(2,2,3)
plot(times_average ,y_average, 'g') % plots all points from all simulations
hold on
plot(mean_times, mean_y, 'k', 'LineWidth', 3) % plots average point in each interval
title('Average Y Amount vs Time (Time Intervals)')
xlabel('Time')
ylabel('Y Amount')
axis ([0 inf 0 inf])
hold on

% fourth plot displays y amount vs time
subplot(2,2,4)
plot(times_average ,z_average, 'c') % plots all points from all simulations
hold on
plot(mean_times, mean_z, 'k', 'LineWidth', 3) % plots average point in each interval
title('Average Z Amount vs Time (Time Intervals)')
xlabel('Time')
ylabel('Z Amount')
axis ([0 inf 0 inf])
hold on


disp('Variance X1') % prints overall variance for x1
disp(mean(variances_x1)) % variance x1 is mean of variances from each interval

disp('Variance X2') % prints overall vaiance for x2
disp(mean(variances_x2)) % variance x2 is mean of variances from each interval

disp('Variance Y') % prints overall variance for y
disp(mean(variances_y)) % variance y is mean of variances from each interval

disp('Variance Z') % prints overall variane for z
disp(mean(variances_z)) % variance z is mean of variances from each interval

toc
