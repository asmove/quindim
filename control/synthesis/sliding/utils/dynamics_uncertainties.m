function [Fs, abs_fs_fshat] = dynamics_uncertainties(fs, q_p, params_s, params_lims)
    params_hat_s = add_symsuffix(params_s, '_hat');
    fs_hat = subs(fs, params_s, params_hat_s);

    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);

    abs_fs_fshat = expand(fs - fs_hat);
   
    fs_len = length(fs);
    Fs = sym(zeros(fs_len, 1));
    for i = 1:fs_len
        [num, den] = numden(abs_fs_fshat(i));

        % Numerator and denominator for f vector
        num_sup = triang_ineq(num, q_p, 'F calculation', ...
                              [params_s; params_hat_s], ...
                              [params_max; params_max], 0);
        
        den_inf = triang_ineq(den, q_p, 'F calculation', ...
                              [params_s; params_hat_s], ...
                              [params_min; params_min], 1);
        
        Fs(i) = num_sup./den_inf;
    end
end
