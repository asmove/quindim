function [q_vals, p_vals, ...
          qp_vals, pp_vals, qpp_vals] = ...
                traj_smoothstep(t_i, interval, dt, degree_interp, ...
                                   symbs, model_params, points, sys)
    
    % Begin and end points
    head = points(1).coords(1:2);
    tail = points(2).coords(1:2);
    
    points(1).coords
    points(2).coords
    
    % States derivatives
    r_val = smoothstep(t_i, interval, head, tail, degree_interp);
    drdt_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 1);
    dr2dt2_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 2);
    dr3dt3_val = ndsmoothstep(t_i, interval, head, tail, degree_interp, 3);
    
    q_vals = double([r_val]);
    p_vals = double([drdt_val]);
    qp_vals = double([drdt_val]);
    pp_vals = double([dr2dt2_val]);
    
    C = sys.kin.C;
    Cp = sys.kin.Cp;
    q = sys.kin.q;
    p = sys.kin.p{end};
    pp = sys.kin.pp{end};
    qp = sys.kin.qp;
    
    qpp = Cp*p + C*pp;
    
    symbs = [q; p; symbs.'];
    vals = [q_vals; p_vals; model_params'];
    
    qpp_vals = subs(qpp, symbs, vals);
end