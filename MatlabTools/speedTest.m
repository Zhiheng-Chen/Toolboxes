array_time = zeros(1,3);
for ii = 1:3
    tic;
    N = 0;
    while N < 10000000000
        N = N+1;
    end
    t = toc;
    array_time(ii) = t;
end
t_avg = mean(array_time);
disp(t_avg);