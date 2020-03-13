function [q_vals, p_vals, ...
          qp_vals, pp_vals, qpp_vals] = ...
                    rolling_smooth(t_i, interval, ...
                                   r_t, params_syms, params_sols, ...
                                   dt, points, sys)
    
    persistent phi_prev;
    syms T t;
    
    model_params = sys.descrip.model_params;
    R = model_params(2);
    
    symbs = [t; T; params_syms];
    vals = [t_i; interval; params_sols];
    
    % States derivatives
    drdt_t = diff(r_t, t);    
    dr2dt2_t = diff(drdt_t, t);
    d3rdt3_t = diff(dr2dt2_t, t);
    
    r_val = double(subs(r_t, symbs, vals));
    
    drdt_val = double(subs(drdt_t, symbs, vals));
    dr2dt2_val = double(subs(dr2dt2_t, symbs, vals));
    dr3dt3_val = double(subs(d3rdt3_t, symbs, vals));
        
    dxdt = drdt_val(1);
    dydt = drdt_val(2);
    
    dx2dt2 = dr2dt2_val(1);
    dy2dt2 = dr2dt2_val(2);
    
    dx3dt3 = dr3dt3_val(1);
    dy3dt3 = dr3dt3_val(2);
    
    theta = atan2(dydt, dxdt);
    
    v = dxdt*cos(theta) + dydt*sin(theta);

    omega_theta = (-dx2dt2*sin(theta) + dy2dt2*cos(theta))/v;

    vp = dx2dt2*cos(theta) + dy2dt2*sin(theta);

    omegap_theta = (-omega_theta*vp - ...
                     dx3dt3*sin(theta) + ...
                     dy3dt3*cos(theta) - ...
                     dx2dt2*omega_theta*cos(theta) - ...
                     dy2dt2*omega_theta*sin(theta))/v;

    omega_phi = v/R;
    omegap_phi = vp/R;
    
    symbs = [t; T; params_syms];
    vals = [0; interval; params_sols];
    r0 = subs(r_t, symbs, vals);
    
    symbs = [t; T; params_syms];
    vals = [interval; interval; params_sols];
    rT = subs(r_t, symbs, vals);

    if(t_i == 0)
        phi = points(1).coords(4);
    else
        phi = phi_prev + dt*v/R;
    end
    
    phi_prev = phi;
    
    q_vals = [r_val; theta; phi];
    p_vals = [omega_theta; omega_phi];
    qp_vals = [drdt_val; omega_theta; omega_phi];
    pp_vals = [omegap_theta; omegap_phi];

    C = sys.kin.C;
    Cp = sys.kin.Cp;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    q = sys.kin.q;
    qp = sys.kin.qp;
    
    qpp = Cp*p + C*pp;
    
    qpp_vals = subs(qpp, [q; p], [q_vals; p_vals]);
end