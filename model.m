function outdata = model(tbl_param, yoffe2)
    % edited: Jan 9, 2021: temperature transposed
    
    model = evalin('base','model');
    
    % change loc
    model.param.set('loc', tbl_param.loc);
    model.param.set('Tf',tbl_param.Tf);
    model.param.set('rise',tbl_param.risetime);
    model.param.set('t1',tbl_param.t_las);
    model.param.set('v1',tbl_param.v);

    % yoffe function
    model.func('int2').set('table', cellfun(@num2str,...
        num2cell([yoffe2]),'UniformOutput',false));

    %try
        % run the model
        model.study('std1').run;
        
        L = 0.03;
        N = 500;
        dN = L/(N-1);
        x0 = 0:dN:L;
        y0 = 0;
        [x,y] = meshgrid(x0,y0);
        xx = [x(:),y(:)]';

        % retrieve solution info
        info2 = mphsolinfo(model, 'soltag', 'sol16');
        t_all2 = extractfield(info2,'solvals');
        melt_time = t_all2(end); % effectively the melting time

        % keep the temp distribution of the last time
        % extract T values
        temp = mphinterp(model,'comp1.T','coord',xx,'dataset','dset13'); 
        temp_las2 = temp(end,:);
        temperature = temp_las2;

    % extract position and velocity
        space = mphtable(model,'tbl1');
        space_data = extractfield(space,'data');
        space_data = reshape(space_data,numel(space_data)/4,[]);
        % find the max thickness
        k = find(space_data(:,1)>=tbl_param.cutoff_time,1);
        thickness = max(space_data(k:end,2));
        % convert space_data to 1x1 cell array. [1 2] means that num2cell takes
        % in both dimensions 1 and 2
        space = num2cell(space_data,[1 2]); 
        % bundle up into a table
        % transpose temperature vector
        outdata = table(melt_time, temperature', thickness, space);

        
    % Combine data into a structure
end

