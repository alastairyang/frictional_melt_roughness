function [ss_k, ss_displace] = displace_mean_ss(yoffe, shearstress)
%DISPLACE_MEAN_SS 
    % this function transform the shear stress time evolution data
    % into a shear stress-displacement data
    % in addition, we find the displacement-average shear stress
    
    % yoffe fucntion has longer time than the ss(t) data so we need to 
    % cut it first
    ix = find(yoffe(:,1) < shearstress(end,1));
    yoffe_cut = yoffe(1:ix,:);
    
    % interpolating using shearstress(t)
    yoffe_interp = interp1(yoffe_cut(:,1), yoffe_cut(:,2), shearstress(:,1));
    
    displace = trapz(yoffe_cut(:,1), yoffe_interp);
    ss_displace = table(displace, shearstress(:,2));
    
    % displacement-average shear stress
    ss_k = trapz(ss_displace.displace, ss_displace.shearstress)/...
                 ss_displace.displace(end,1);
    
end

