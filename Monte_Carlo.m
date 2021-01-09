% Creation date: Jan 5, 2021
% This file creates monte-carlo sampling of the relief data and feed into 
% the Bayesian function

clear
tic

% assuming normal distribution
[x,y] = dataset; % data unpacking
f = fit(x.', y.', 'gauss1');
mu = f.b;
sigma = f.c;

N = 30; % sampling 30 points
parameters = zeros(N,3);
ShearStress_biotite = cell(N,1); % create N empty cells
ShearStress_feldspar = cell(N,1);


% don't forget to normalize the distribution
for i = 1:N
    relief = normrnd(mu, sigma);
    results = Bayesian(relief);
    % extract yoffe function parameters
    parameters(i,:) = [results.XAtMinEstimatedObjective.s_s... 
                       results.XAtMinEstimatedObjective.dmax... 
                       results.XAtMinEstimatedObjective.trise];
    % find the # evalution that outputs the min objective func
    ix = find((results.XTrace.s_s == parameters(i,1)) &...
               (results.XTrace.dmax == parameters(i,2)) &...
               (results.XTrace.trise == parameters(i,3)));
    ShearStress_biotite{i} = results.UserDataTrace{ix}...
                  .data_biotite(1,:).space{1,1}(:,[1 4]);
    ShearStress_feldspar{i} = results.UserDataTrace{ix}...
                  .data_feldspar(1,:).space{1,1}(:,[1 4]);
end


timeElapsed = toc/60 % from second to min
