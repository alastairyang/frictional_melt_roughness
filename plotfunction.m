% creates a custom plot function that plots the shear stress evolution of 
% each feldspar and biotite simulations. 
% written: Jan 3rd, 2021

function stop = plotfunction(results, state)
persistent var1 iter_count dimension
stop = false;
switch state % bayesopt returns 'initial','iteration','done'
    case 'initial'
        var1 = figure;
        iter_count = 0;
        dimension = sqrt(results.NumObjectiveEvaluations(1));
        if floor(dimension) ~= dimension
            stop = true;
            print('Number of iterations cannot be taken square root!');
        end
    case 'iteration'
        % we create a figure for each iteration
        ss = result.XTrace(iter_count, 1);
        dmax = result.XTrace(iter_count, 2);
        trise = result.XTrace(iter_count, 3);
        figure(var1);
        iter_count = iter_count + 1;
        subplot(dimension, dimension, iter_count);
        loglog(results.UserDataTrace{iter_count}.data_biotite(1,:).space{1,1}(:,1),...
             results.UserDataTrace{iter_count}.data_biotite(1,:).space{1,1}(:,4), 'r*-')
         hold on
        loglog(results.UserDataTrace{iter_count}.data_feldspar(1,:).space{1,1}(:,1),...
             results.UserDataTrace{iter_count}.data_feldspar(1,:).space{1,1}(:,4),'bo-')
        xlabel('Simulation Time (s)')
        ylabel('Shear Stress (Pa)')
        title("Time-Dependent Shear Stress, ss = "+ ss + ", Dmax = "+ dmax...
              + ", RiseT = " + trise) % string array, double quote
        legend('Biotite','Feldspar')
        grid on
        drawnow

end