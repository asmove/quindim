function u = ljapunov_based(t, q_p, x_hat, x_hat_1, Q, P, ...
                        zeta, eta, source_reference, sys)
    persistent u_control tu_s u_s counter phat_t;
    
    if(isempty(phat_t))
        phat_t = [];
        assignin('base', 'phat_t', phat_t);
    end
    
    if(isempty(u_s))
        u_s = [];
        assignin('base', 'u_s', u_s);
    end
    
    if(isempty(tu_s))
        tu_s = [];
        assignin('base', 'tu_s', tu_s);
    end
    
    if(isempty(counter))
        counter = 0;
    end
    
    is_positive(Q);
    is_positive(P);
    
    if(zeta <= 0)
        error('Zeta MUST be greater than 0!');
    end
    
    if(isempty(u_control))
        u_control = control_calc(sys, Q, P, eta, source_reference);
    end
    
    delta_x = x_hat - x_hat_1;
    
    p = sys.kin.p{end};
    q = sys.kin.q;

    model_params = sys.descrip.model_params;
    syms_plant = sys.descrip.syms;
    
    u_control = subs(u_control, syms_plant, model_params);

    x = subs(source_reference, [q; p], q_p);
    
    x_tilde = x - x_hat;
    
    x_hat_s = sym('xhat_', size(x));
    p_hat_s = sym('phat_', size(p));
    
    syms_params = [q.', p.', x_hat_s.', p_hat_s.'];
    num_params = [q_p', x_hat', zeta*delta_x.'];
    
    u = double(subs(u_control, syms_params, num_params));
    
    counter = counter + 1;
    
    % Avoid runge-kutta repetitions
    if(counter == 1)
        u_s = [u_s; u'];
        tu_s = [tu_s; t];
        phat_t = [phat_t; zeta*delta_x.'];
    
        assignin('base', 'phat_t', phat_t);
        assignin('base', 'u_s', u_s);
        assignin('base', 'tu_s', tu_s);
    elseif(counter == 4)
        counter = 0;
    else
        % Do nothing
    end
end