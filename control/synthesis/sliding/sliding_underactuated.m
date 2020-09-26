function u = sliding_underactuated(sys, etas, poles, ...
                                   params_lims, rel_qqbar, ...
                                   errors, is_int, is_dyn_bound, ...
                                   switch_type, options)
    
    % Deprecated: substitute symbolics to double values
%     [U, S, V] = svd(subs(sys.dyn.Z, params_lims));
%     sys.dyn.H = inv(U)*sys.dyn.H;
%     sys.dyn.h = inv(U)*sys.dyn.h;
%     sys.dyn.Z = S;
%     q = sys.kin.q;
%     
%     D = equationsToMatrix(rel_qqbar, q);
% 
%     if(isempty(symvar(D*S)) && ~any(any(D*S)))
%         error('The system cannot control this subspace!');
%     end

    U = 1;
    V = 1;
    
    params_hat_n = sys.descrip.model_params';
    [n, m] = size(sys.dyn.Z);
    
    for i = 1:m
        param_lims = params_lims(i, 1:2);
        param_hat = params_hat_n(i);
        
        if((param_hat >= param_lims(1)) || (param_hat <= param_lims(2)))
            continue;
        else
            error('Estimation parameters MUST be within interval!');
        end
    end
    
%     if(length(etas) ~= m)
%         error('Number of etas MUST be equal to inputs!');
%     end
    
    params_s = sys.descrip.syms.';
    params_hat_s = add_symsuffix(params_s, '_hat');
    
    % Parameter limits
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    q = sys.kin.q;
    p = sys.kin.p;
    
    q_a = q(1:m);
    q_u = q(m+1:n);
    
    if(length(sys.kin.Cs) ~= 1)
        [m, ~] = size(sys.kin.C{1});
        
        Cs = eye(m);
        for i = 1:length(sys.kin.C)
            Cs = Cs*sys.kin.Cs{i};
        end
    else
        Cs = sys.kin.C;
    end
    
    p = p{end};
    
    qp = Cs*p;
    q_p = [q; qp];
    
    cparams = controller_params(sys, poles, rel_qqbar, ...
                                is_int, is_dyn_bound);

    % Dynamics uncertainties
    Fs_struct = dynamics_uncertainties(cparams.fs_s, q_p, ...
                                       params_s, params_lims, ...
                                       sys.descrip.model_params');
    
    % Mass matrix uncertainties
    Ms_struct = mass_uncertainties2(cparams.Ms_s, ...
                                    q_p, params_s, params_lims);
    
    if(is_int)
        double(abs(cparams.alpha)*errors.error_qp)
        double(abs(cparams.lambda)*errors.error_q)
        double(abs(cparams.mu)*errors.error_w)
        
        u.phi0 = abs(cparams.alpha)*errors.error_qp + ...
                 abs(cparams.lambda)*errors.error_q + ...
                 abs(cparams.mu)*errors.error_w;
    else
        u.phi0 = abs(cparams.alpha)*errors.error_qp + ...
                 abs(cparams.lambda)*errors.error_q;
    end
    
    if(strcmp(switch_type, 'sign'))
        % Do nothing

    elseif(strcmp(switch_type, 'sat'))
        u.phi = u.phi0;

    elseif(strcmp(switch_type, 'poly'))
        u.phi = u.phi0;
        u.degree = options.degree;
        
    elseif(strcmp(switch_type, 'hyst'))
        u.phi_min = -u.phi0;
        u.phi_max = u.phi0;

    else
        error('The accepted tokens are sign, sat, poly or hyst.');
    end
    
    % Gains
    u.K = @(Fs_struct, Ms_struct) ...
            diag(simplify_(Ms_struct.C*(Fs_struct.Fs + ...
                           Ms_struct.D*abs(cparams.sr_p + ...
                           Fs_struct.fs_hat) + etas)));
        
    u.Ms_struct = Ms_struct;
    u.Fs_struct = Fs_struct;
    
    % Manifold parameters
    u.cparams = cparams;
    
    u.is_int = is_int;
    
    % Converting matrix
    u.U = U;
    u.V = V;
            
    u.params = params_s;
    u.params_hat = params_hat_s;
    
    u.etas = etas;

    u.switch_type = switch_type;
end
