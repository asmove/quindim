function cparams_str = controller_params(sys, poles, ...
                                         rel_qqbar, is_int, ...
                                         is_dyn_bound)
    
    % Sliding constant matrices
    refdyn_str = refdyn_params(sys, poles, rel_qqbar, is_int);
    
    % Matrix and dynamic matrices
    alpha_ = refdyn_str.alpha;
    [Ms_s, fs_s] = Ms_fs(sys, alpha_);
    
    % Sliding surface and auxiliary matrices
    s_struct = s_sr_srp(sys, refdyn_str, is_int, is_dyn_bound);
    
    refdyn_str
    s_struct
    
    cparams_str.Ms_s = Ms_s;
    cparams_str.fs_s = fs_s;
    cparams_str = merge_struct(cparams_str, s_struct);
    cparams_str = merge_struct(cparams_str, refdyn_str);
end
