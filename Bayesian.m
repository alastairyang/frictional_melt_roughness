
function results = Bayesian(relief)
% Bayesian optimization of finite element model
% It creates the parameter space: total rise time, slip distance (scaling),
% and acceleration duration
% Created on Oct 14, 2020
% Revised on Jan 9, 2021


clear % remove all vars from the current workspace
clear counter
clear counter_success

s_s = optimizableVariable('s_s',[0.01,0.05]);
dmax = optimizableVariable('dmax',[0.015,0.03]); % trial and error: to avoid super low peak velocity
trise = optimizableVariable('trise',[1,8]); 

model = mphload('July_3_melt_1','MyModel');

% function handle
fun = @(w)mycomsol(w,relief);

results = bayesopt(fun,[s_s,dmax,trise],'IsObjectiveDeterministic',true,...
    'NumCoupledConstraints',0,'PlotFcn',...
    {@plotMinObjective,@plotConstraintModels},...
    'AcquisitionFunctionName','expected-improvement-plus','Verbose',0,...
    'MaxObjectiveEvaluations',10);

end



