function [objective,userdata] = mycomsol(w,relief)
    % input: x.s_s, x.dmax, x.trise
    
    replace = 3;
    cutoff_time = 0.01; % cut the first part of displacement info where the layer rapidly shrinks; this magnitude works fine for 4.75e-6 and v=0.5
    % sample roughness value: final version: a value sampled by monte carlo
    sample_value = relief; % it's just a place holder now

    run_index = counter;
    
    % define some parameters
    loc = 0.00000475; % 4.75e-6
    L = 0.03; % COMSOL model space
    v = 0.5; % time-average slip velocity
    alpha = 4.8478e-07; % solid diffusivity
    k = 1.5; % solid conductivity
    T0 = 400; % ambient temp
    shear = 7e+07; % initial shear stress
    
    % Comsol time step
    dt1 = 0.01; 

    % pass the parameter and re-create the yoffe function
    t = [-1:dt1:w.trise];
    orig_y = (2/(pi*w.trise)).*heaviside_diy(t).*heaviside_diy(w.trise-t).*sqrt((w.trise-t)./t);
    orig_y(1/dt1+1) = replace;
    g = (1/(w.s_s^2)).*((t.*heaviside_diy(t).*heaviside_diy(w.s_s-t))+(2*w.s_s-t).*...
    heaviside_diy(t-w.s_s).*heaviside_diy(2*w.s_s-t));

    % convolution
    c = w.dmax*conv(orig_y,g);
    t2 = [-1:dt1:2*w.trise];
    G = c((2/dt1)+1:end); %201
    dimension = size(G);
    t2 = t2(1/dt1+1:end); %101
    t2 = t2(1:dimension(2));
    yoffe1 = [t2;G./2]'; % only half the velocity in this half space

    % integrate to get distance
    slip = trapz(yoffe1(:,1),yoffe1(:,2)); 

    % real coordinates
    N = 500;
    dN = L/(N-1);
    x0 = 0:dN:L;
    y0 = 0;
    [x,y] = meshgrid(x0,y0);
    xx = [x(:),y(:)]';
    
    
    %%% first run
    Tf = 1173; % biotite melting point
    risetime = w.trise;
    tbl_param = table(loc, Tf, risetime, v, cutoff_time, alpha, k, shear, T0);
    t_las = analyticalsol_time(tbl_param);
    % Prepare the rest of Yoffe function
    j = find(t2 <= t_las); % last element of j is the # left neighbor of t_las
    yoffe2 = yoffe1(j(end)+1:end,:); 
    yoffe2(:,1) = yoffe2(:,1)-yoffe2(1,1); % reset t axis
    tbl_param = addvars(tbl_param, t_las);
    % use model
    data_biotite = model(tbl_param, yoffe2);
    
    % find displacement-averaged shear stress ss_k
    shearstress = data_biotite(1,:).space{1,1}(:,[1 4]);
    [ss_k_biotite, ss_k_bt_table] = displace_mean_ss(yoffe2, shearstress);
    
    %%% second run: higher melting temp
    Tf = 1523.15; % K-Feldspar melting point
    tbl_param.Tf = Tf;
    t_las = analyticalsol_time(tbl_param);
    % Prepare the rest of Yoffe function
    j = find(t2 <= t_las); % last element of j is the # left neighbor of t_las
    yoffe2 = yoffe1(j(end)+1:end,:); 
    yoffe2(:,1) = yoffe2(:,1)-yoffe2(1,1); % reset t axis
    tbl_param.t_las = t_las;
    % use model
    data_feldspar = model(tbl_param, yoffe2);
    
    % find displacement-averaged shear stress ss_k
    shearstress = data_feldspar(1,:).space{1,1}(:,[1 4]);
    [ss_k_feldspar, ss_k_fs_table] = displace_mean_ss(yoffe2, shearstress);
  
    % adding to masterdata
    data_biotite = addvars(data_biotite, ss_k_biotite, ss_k_bt_table);
    data_feldspar = addvars(data_feldspar, ss_k_feldspar, ss_k_fs_table);
    
    % store userdata
    userdata = table(data_biotite, data_feldspar);
   
    % record the successful parameter
    success = counter_success;
        
    %catch % catch the error; if error, give a positive constraint value (not satisfied)
    %    constraint = 100;
    %    fail = fail + 1;
    %end

    % the objective is to minimize diff:(sample roughness value and
    % simulated max thickness difference)
    % squared distance
    objective = (sample_value - abs(data_feldspar.thickness-data_biotite.thickness))^2;
    %constraint = -100; % satisfactory
    
end
