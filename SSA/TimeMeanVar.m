function [mean_xs, variances_xs, mean_times] = TimeMeanVar(times_average, interval, max_rx, num_species, x1_average, x2_average, y_average, z_average)
% vector to store time for each interval 
mean_times = 0:interval:max_rx;
% number of intervals to be used for mean calculation
num_pts = length(mean_times);

% blank vector to store x1 amounts at each interval
mean_xs = zeros(num_species, num_pts);
mean_xs(1,1) = x1_average(1);
mean_xs(2,1) = x2_average(1);
mean_xs(3,1) = y_average(1);
mean_xs(4,1) = z_average(1);


% vector to store the current count of the for loop below 
ints = [0];
count = 1;

% vector to store interval variances for time intervals
variances_xs = zeros(num_species, num_pts);


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
    
    allspecs = [mean(allx1s) mean(allx2s) mean(allys) mean(allzs)];
    
    num_between = length(allx1s); % the number of times in the range
    
    % calculations for means
    mean_xs(:,count) = allspecs;
    
    % calculations for variances
    % the overall variance in each interval is the sum of all variances in
    % that interval. The variances for x1, x2, y and z are calculated
    % separately
    varsX1 = ((allx1s-mean_xs(1,count)).^2)./num_between;
    variances_x1(count) = sum(varsX1); 
    
    varsX2 = ((allx2s-mean_xs(2,count)).^2)./num_between;
    variances_x2(count) = sum(varsX2);
    
    varsY = ((allys-mean_xs(3,count)).^2)./num_between;
    variances_y(count) = sum(varsY);
    
    varsZ = ((allzs-mean_xs(4,count)).^2)./num_between;
    variances_z(count) = sum(varsZ);
    
    allvariances = [variances_x1(count) variances_x2(count) variances_y(count) variances_z(count)];
    variances_xs(:,count)= transpose(allvariances);
    
    
end
