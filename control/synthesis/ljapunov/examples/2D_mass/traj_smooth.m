function [q_vals, p_vals, ...
          qp_vals, pp_vals, qpp_vals] = ...
                    traj_smooth(t_i, interval, r_t, params_syms, ...
                                params_sols, dt, points, sys)
    
    syms T t;
    
    model_params = sys.descrip.model_params;
    R = model_params(2);
    
    symbs = [t; T; params_syms];
    vals = [t_i; interval; params_sols];
    
    xp = sys.kin.qp(1);
    yp = sys.kin.qp(2);
    xpp = sys.kin.qpp(1);
    ypp = sys.kin.qpp(2);
    
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
    
    symbs = [t; T; params_syms];
    vals = [0; interval; params_sols];
    r0 = subs(r_t, symbs, vals);
    
    symbs = [t; T; params_syms];
    vals = [interval; interval; params_sols];
    rT = subs(r_t, symbs, vals);
    
    q_vals = [r_val];
    p_vals = [drdt_val];
    qp_vals = [drdt_val];
    pp_vals = [dr2dt2_val];

    C = sys.kin.C;
    Cp = sys.kin.Cp;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    q = sys.kin.q;
    qp = sys.kin.qp;
    
    qpp = Cp*p + C*pp;
    
    qpp_vals = subs(qpp, [q; p], [q_vals; p_vals]);
end