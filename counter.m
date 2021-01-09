function run_index = counter()
    persistent n
    if isempty(n)
        n = 0;
    end
    n = n+1;
    run_index = n;
end