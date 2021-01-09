function y = heaviside_diy(x)
    len = length(x);
    y = zeros(1,len);
    for i = 1:len
        if x(i) == 0
            q = 0.5;
        elseif x(i) < 0
            q = 0;
        else
            q = 1;
        end
    y(i) = q;
    end
end

