function [dist_data_b, dist_data_qf, stats_tb] = dist_stats(new_b, new_qf)
%DIST_STATS 
    % created on Jan 12, 2021
    % edited on Jan 12, 2021
    % this function takes cleaned relief_tile data and output stats
    dist_data_b = cell(3);
    dist_data_qf = cell(3);
    mu_sum_b = 0;
    mu_sum_qf = 0;
    sigma_sum_b = 0;
    sigma_sum_qf = 0;
    for i = 1:9
        dist_data_b{i} = fitdist(new_b{i}, 'normal');
        dist_data_qf{i} = fitdist(new_qf{i}, 'normal');
        mu_sum_b = mu_sum_b + dist_data_b{i}.mu;
        mu_sum_qf = mu_sum_qf + dist_data_qf{i}.mu;
        sigma_sum_b = sigma_sum_b + dist_data_b{i}.sigma;
        sigma_sum_qf = sigma_sum_qf + dist_data_qf{i}.sigma;
        if i==9
            mu_b = mu_sum_b/9;
            mu_qf = mu_sum_qf/9;
            sigma_b = sigma_sum_b/9;
            sigma_qf = sigma_sum_qf/9;
            stats_tb = table(mu_b, mu_qf, sigma_b, sigma_qf);
    end
end

