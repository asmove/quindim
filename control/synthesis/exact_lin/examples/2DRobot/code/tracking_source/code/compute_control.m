function [dz, u] = compute_control(t, q_p, refs, qp_symbs, ...
                                   refs_symbs, sys, poles_)
    persistent control_law comp_law;
    
    if(isempty(comp_law))
        [comp_law, control_law] = calc_control_2DRobot(sys, poles_);
    end
    
    [m, n] = size(sys.kin.C);
    states_symbs = [qp_symbs; refs_symbs; sys.descrip.syms.'];
    states_vals = [q_p; refs; sys.descrip.model_params'];
    
    u = subs(control_law, states_symbs, states_vals);
    dz = subs(comp_law, states_symbs, states_vals);
end