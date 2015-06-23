function impTau = ImplicitTau(Rjs, V, aj, num_species, X, gis)
V(V>0) = 0; % zero out all product species
V((Rjs>0), :) = 0; % zero out all critical reactions

means = zeros(1, 3);
vars = zeros(1, 3);
epsilon = 0.03;

for (ii = 1: num_species)
    vcol = V(:, ii); % retrieve V values for one species
    vrow = transpose(vcol);
    tempMean = vrow .* aj; % find mean for one species
    tempVar = tempMean .* vrow; % find variance for one species
    means(ii) = sum(tempMean); % store 
    vars(ii) = sum(tempVar); 
end



