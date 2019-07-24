function plot_sim(simOut, to, fnames)
    % States
    fname = fnames{1};
    
    x = get(simOut, 'x');
    hfigx = plot_double_states(x, to, fname);
    print(hfigx, [to, fname], '-depsc2', '-r0');

    % Estimated states
    fname = fnames{2};
    xhat = get(simOut, 'xhat');
    
    hfigxhat = plot_double_states(xhat, to, fname);
    print(hfigxhat, [to, fname], '-depsc2', '-r0');
end