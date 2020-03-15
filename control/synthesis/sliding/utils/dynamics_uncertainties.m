function Fs_struct = dynamics_uncertainties(fs, q_p, params_s, ...
                                            params_lims, params_hat)

    params_hat_s = add_symsuffix(params_s, '_hat');
    fs_hat = subs(fs, params_s, params_hat);

    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);

    abs_fs_fshat = abs(expand(fs - fs_hat));
    
    [num, den] = numden(simplify_(abs_fs_fshat));
    den = subs(den, ...
               [params_hat_s; params_s], ...
               [params_lims(:, 1); params_lims(:, 1)]);
    
    Fs_struct.Fs_num = num;
    Fs_struct.Fs_den = den;
    Fs_struct.abs_fs_fshat = abs_fs_fshat;
    Fs_struct.fs_hat = fs_hat;
end
