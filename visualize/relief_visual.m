% relief data analysis
% created Jan 12, 2021
% edited Jan 12, 2021
function relief_visual(thb, thqf)
    thb_1d = thb(isfinite(thb));
    thqf_1d = thqf(isfinite(thqf));
    figure(1)
    subplot(2,2,1)
    histogram(thb_1d, 10, 'Normalization', 'pdf');
    xlabel("biotite thickness")
    ylabel("Percentage")
    subplot(2,2,2)
    histogram(thqf_1d, 10, 'Normalization', 'pdf');
    xlabel("quartz/feldspar thickness")
    ylabel("Percentage")
    subplot(2,2,3)
    imagesc(thb)
    xlabel("x dimension")
    ylabel("y dimension")
    subplot(2,2,4)
    imagesc(thqf)
    xlabel("x dimension")
    ylabel("y dimension")
end