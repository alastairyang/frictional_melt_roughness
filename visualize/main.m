% created on Jan 12, 2021
% edited on Jan 12, 2021
% this file first visualize the surface roughness and the histograms
% then split the surface into 9 equal size tiles
% visualize the distribution in each tile and output their stats
% the result output stats_tb is a table, recording the mean and sigma
% values of both quartz/feldspar and biotites. They are the average of the
% 9 tiles.

inputfile = "thicknessL1208.mat";
load(inputfile);
thb_1d = thb(isfinite(thb));
thqf_1d = thqf(isfinite(thqf));
relief_visual(thb, thqf);

% split the data into 9 tiles (domains)
[new_b, new_qf] = split_data(thb, thqf);
relief_visual_tiles(new_b, new_qf);

% call dist_stats function to get stats
[dist_data_b, dist_data_qf, stats_tb] = dist_stats(new_b, new_qf);