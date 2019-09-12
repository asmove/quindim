function Fs = dynamics_uncertainties(fs, q_p, params_s, params_lims)
    params_hat_s = add_symsuffix(params_s, '_hat');
    fs_hat = subs(fs, params_s, params_hat_s);

    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);

    abs_fs_fshat = expand(fs - fs_hat);

    abs_fs_fshat     
   
    fs_len = length(fs);
    Fs = sym(zeros(fs_len, 1));
    for i = 1:fs_len
        [num, den] = numden(abs_fs_fshat(i));

        % Numerator and denominator for f vector
        num_sup = func_minmax(num, q_p, 0, 'F calculation');
        
        num_sup = subs(num_sup, params_s, params_max);
        num_sup = subs(num_sup, params_hat_s, params_max);
        
        den_inf = func_minmax(den, q_p, 1, 'F calculation');
        
        den_inf = subs(den_inf, params_s, params_min);
        den_inf = subs(den_inf, params_hat_s, params_min);
        
        Fs(i) = num_sup./den_inf;
    end
end
