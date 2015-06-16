function [mean_xs_num, variances_xs_num, times_plot_num, st_dev_pos, st_dev_neg] = StepsMeanVar(times_average, num_species, x1_average, x2_average, y_average, z_average, q_average)

total_num = length(times_average); % find the total number of points
int_num = round(0.0025 * total_num); % each inerval is 10% of the total number of points

% vector which defines the indexes for all intervals 
mean_points = 1:int_num:total_num;

% store the times at the above indexes (these will be used as the time
% points for each interval
times_plot_num = times_average(mean_points);

% the number of intervals to be used for mean calculation (steps)
num_pts_size = length(mean_points);

% blank vector to store amounts at each step interval
mean_xs_num = zeros(num_species, num_pts_size);
mean_xs_num(1,1) = x1_average(1);
mean_xs_num(2,1) = x2_average(1);
mean_xs_num(3,1) = y_average(1);
mean_xs_num(4,1) = z_average(1); 
mean_xs_num(5,1) = q_average(1);

% vector to store the current count of the for loop below 
ints_num = [1];
count_num = 1;

% vector to store interval variances for x1 for step intervals
variances_xs_num = zeros(num_species, num_pts_size);

st_dev_pos = zeros(num_species, num_pts_size);
st_dev_neg = zeros(num_species, num_pts_size);

for ints = int_num:int_num:total_num % generates mean and variance for each interval
    count_num = count_num+1; % increment the counter (started at 1)
    ints_num = [ints_num ints];% add th current interval to the list
    
    % the ranges defined below are all the points in the current interval
    % as defined by the cutoff vaues in ints_num 
    allx1s_num = x1_average(ints_num(count_num-1): ints_num(count_num)); % all x1 amounts in the step range
    allx2s_num = x2_average(ints_num(count_num-1): ints_num(count_num)); % all x2 amounts in the step range
    allys_num = y_average(ints_num(count_num-1): ints_num(count_num)); % all y amounts in the step range
    allzs_num = z_average(ints_num(count_num-1): ints_num(count_num)); % all z amounts in the step range 
    allqs_num = q_average(ints_num(count_num-1): ints_num(count_num));
    amt_between = length(allx1s_num); % the number of values in the above range
    
    % calculations for means
    mean_xs_num(:, count_num) = [mean(allx1s_num) mean(allx2s_num) mean(allys_num) mean(allzs_num) mean(allqs_num)];
    
    % calculations for variances
    % the overall variance in each interval is the sum of all variances in
    % that interval. The variances for x1, x2, y and z are calculated
    % separately
    varsX1_num = ((allx1s_num-mean_xs_num(1,count_num)).^2)./amt_between;
    varsX2_num = ((allx2s_num-mean_xs_num(2,count_num)).^2)./amt_between;
    varsY_num = ((allys_num-mean_xs_num(3,count_num)).^2)./amt_between;
    varsZ_num = ((allzs_num-mean_xs_num(4,count_num)).^2)./amt_between;
    varsQ_num = ((allqs_num-mean_xs_num(5,count_num)).^2)./amt_between;

    variances_xs_num(:,count_num) = [sum(varsX1_num) sum(varsX2_num) sum(varsY_num) sum(varsZ_num) sum(varsQ_num)];
    
    st_dev_pos(1,count_num) = mean_xs_num(1,count_num) + sqrt(sum(varsX1_num));
    st_dev_pos(2,count_num) = mean_xs_num(2,count_num) + sqrt(sum(varsX2_num));
    st_dev_pos(3,count_num) = mean_xs_num(3,count_num) + sqrt(sum(varsY_num));
    st_dev_pos(4,count_num) = mean_xs_num(4,count_num) + sqrt(sum(varsZ_num));
    st_dev_pos(5,count_num) = mean_xs_num(5,count_num) + sqrt(sum(varsQ_num));
    
    st_dev_neg(1,count_num) = mean_xs_num(1,count_num) - sqrt(sum(varsX1_num));
    st_dev_neg(2,count_num) = mean_xs_num(2,count_num) - sqrt(sum(varsX2_num));
    st_dev_neg(3,count_num) = mean_xs_num(3,count_num) - sqrt(sum(varsY_num));
    st_dev_neg(4,count_num) = mean_xs_num(4,count_num) - sqrt(sum(varsZ_num));
    st_dev_neg(5,count_num) = mean_xs_num(5,count_num) - sqrt(sum(varsQ_num));
end

st_dev_pos(:,1) = st_dev_pos(:,2);
st_dev_neg(:,1) = st_dev_neg(:,2); 
