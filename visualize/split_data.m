function [new_b, new_qf] = split_data(b,qf)
%SPLIT_DATA This function splits data into 9 equally sized domains
    % since there is a variation in whole-pseudotachylyte thickness
    % the input data have sie of 625x641
    [x,y] = size(b);
    % making dimensions divisible by three
    na = NaN(x,1);
    b = [b, na];
    qf = [qf, na];
    dx = (x-1)/3; % 208
    dy = (y+1)/3;
    
    new_b = cell(3);
    % biotite data
    new_b{1,1} = b(1:dx, 1:dy);
    new_b{1,2} = b(1:dx, dy+1:2*dy);
    new_b{1,3} = b(1:dx, 2*dy+1:3*dy);
    new_b{2,1} = b(dx+1:2*dx, 1:dy);
    new_b{2,2} = b(dx+1:2*dx, dy+1:2*dy);
    new_b{2,3} = b(dx+1:2*dx, 2*dy+1:3*dy);
    new_b{3,1} = b(2*dx+1:3*dx, 1:dy);
    new_b{3,2} = b(2*dx+1:3*dx, dy+1:2*dy);
    new_b{3,3} = b(2*dx+1:3*dx, 2*dy+1:3*dy);
    
    new_qf = cell(3);
    % quartz and feldspar data
    new_qf{1,1} = qf(1:dx, 1:dy);
    new_qf{1,2} = qf(1:dx, dy+1:2*dy);
    new_qf{1,3} = qf(1:dx, 2*dy+1:3*dy);
    new_qf{2,1} = qf(dx+1:2*dx, 1:dy);
    new_qf{2,2} = qf(dx+1:2*dx, dy+1:2*dy);
    new_qf{2,3} = qf(dx+1:2*dx, 2*dy+1:3*dy);
    new_qf{3,1} = qf(2*dx+1:3*dx, 1:dy);
    new_qf{3,2} = qf(2*dx+1:3*dx, dy+1:2*dy);
    new_qf{3,3} = qf(2*dx+1:3*dx, 2*dy+1:3*dy);
    
    % get rid of NaN values
    for i = 1:9
        temp = new_b{i};
        new_b{i} = temp(isfinite(new_b{i}));
        temp = new_qf{i};
        new_qf{i} = temp(isfinite(new_qf{i}));
    end
    
end

