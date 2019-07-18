function [u, v, Delta, z, poles] = exact_lin_tracking(f, G, y, y_ref, x)
    [u, ~, Delta, phis, deltas, z, ...
     ~, A_delta, B_delta] = exact_lin(f, G, y, x);
    
    % Name reference variables as w_<output number>_<i to relative degree>
    omega = [];
    for i = 1:length(deltas)
        for j = 1:deltas(i)
            var_name = sprintf('w_%d_%d', i, j-1);
            omega = [omega; sym(var_name)];
        end
    end
 
    % Tracking law - Relative matrices
    [deltas_track, z_tilde, ...
     phis_tilde, Delta_tilde] = nreldegs(f, G, y_ref, x);
    
    % Relative degrees MUST be equal
    if(sum(deltas) ~= sum(deltas_track))
        msg = ['Provided reference output does', ...
               'not have identical relative degrees!']; 
        error(msg);
    end
    
    % Request user poles 
    poles = {};
    for delta = deltas
        poles = request_poles(delta);
        poles{end+1} = poles;
    end
    
    % Linear dynamic
    A_delta_tilde = [];
    
    i = 1;
    for poles_ = poles 
        coeffs = ctrb_coeffs(poles_);
        A_delta_tilde = direct_sum(A_delta_tilde, coeffs);
    end
    
    Delta_Delta_tilde = simplify_(Delta*simplify_(inv(Delta_tilde)));

    error_ = omega - z_tilde;
    
    % Name reference variables as w_<output number>_<i to relative degree>
    y_tilde_kappa = [];
    for delta = deltas
        var_name = sprintf('w_%d_%d', i, delta);
        y_tilde_kappa = [y_tilde_kappa; sym(var_name)];
    end
    
    aux1 = simplify_(A_delta_tilde*error_ - phis_tilde + y_tilde_kappa);
    aux2 = simplify_(Delta_Delta_tilde*aux1);
    p = simplify_(phis + A_delta*z + aux1);
    v = simplify_(pinv(B_delta)*p);
end
