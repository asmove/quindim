function cparams_str = controller_params(sys, poles, rel_qqbar, is_int)
    
    % Sliding constant matrices
    [alpha_a, alpha_u, ...
     lambda_a, lambda_u] = alpha_lambda(sys, poles, rel_qqbar);
    
    % Matrix and dynamic matrices
    [Ms_s, fs_s] = Ms_fs(sys, alpha_a, alpha_u);
    
    % Sliding surface and auxiliary matrices
    [s, sr, sr_p] = s_sr_srp(sys, , is_int);
    
    cparams_str.alpha_a = alpha_a; 
    cparams_str.alpha_u = alpha_u;
    cparams_str.lambda_a = lambda_a;
    cparams_str.lambda_u = lambda_u;
    
    cparams_str.Ms_s = Ms_s;
    cparams_str.fs_s = fs_s;

    cparams_str.s = s;
    cparams_str.sr = sr;
    cparams_str.sr_p = sr_p;
end
