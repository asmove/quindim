function [dz, u] = compute_control(t, q_p, refs, qp_symbs, refs_symbs)
    persistent control_law comp_law;
    
    if(isempty(comp_law))
        [comp_law, control_law] = calc_control_2DRobot(sys, poles_);
    end
    
    u = subs(control_law, state_symbs);
    dz = subs(comp_law, state_symbs);
end