% relief data analysis
% created Jan 12, 2021
% edited Jan 12, 2021

function relief_visual_tiles(new_b, new_qf)
    figure(2)
    % biotite
    for i = 1:9
        subplot(3,3,i)
        histogram(new_b{i},10, 'Normalization', 'pdf');
        xlabel("biotite thickness")
        ylabel("Percentage")
    end
    figure(3)
    for i = 1:9
        subplot(3,3,i)
        histogram(new_qf{i},10, 'Normalization', 'pdf');
        xlabel("quartz/feldspar thickness")
        ylabel("Percentage")
    end
end