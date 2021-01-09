function success = counter_success()
    persistent n
    if isempty(n)
        n = 0;
    end
    n = n+1;
    success = n;
end