function data_interp = plotfunction_interp(data)

% PLOTFUNCTION_INTERP:
%   This function takes in the bayesopt data for all the runs for
%   each Monte Carlo sampling and interpolate the yoffe function
%   parameter space given the evaluated points and their cost 
%   function values. 
%   written: Jan 9, 2021
%   edited: Jan 9, 2021

    N = 20; 
    % optimizablevar should be 1x3 array
    % 1 -> s_s, 2 -> dmax, 3 -> trise
    optimizable = data.VariableDescriptions; 
    ss_linspace = linspace(optimizable(1).Range(1),... 
                           optimizable(1).Range(2), N);
    dmax_linspace = linspace(optimizable(2).Range(1),...
                             optimizable(2).Range(2), N);
    trise_linspace = linspace(optimizable(3).Range(1),...
                             optimizable(3).Range(2), N); 

                    
    input_evaluated = table2array(data.XTrace); % transform to array                    
    output_evaluated = data.ObjectiveTrace;
    
    % generate meshgrid
    [ss_q, dmax_q, trise_q] = meshgrid(ss_linspace, dmax_linspace,...
                                       trise_linspace);                                 
    [s_s, dmax, trise] = meshgrid(input_evaluated(:,1), input_evaluated(:,2),...
                                  input_evaluated(:,3));
    
    % interpolation for 3-D gridded data 
    data_interp = interp3(s_s, dmax, trise, output_evaluated,...
                          ss_q, dmax_q, trise_q);
    
end

