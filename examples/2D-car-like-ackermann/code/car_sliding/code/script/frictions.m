
F_ats = [];

for i = 1:length(t)
    F_at_s = blkdiag(rot2d(theta), 1, 1)*v*Fa(norm(delta));

    symbs = [model.q; model.p; model.v; model.a; model.symbs.'];
    params_nonideal = [qp_nonideal'; model.v_func(t(i)); model.a_func(t(i)); params_nonideal_.'];
    
    F_at = subs(F_at_s, symbs, params_nonideal);
    
    F_ats = [F_ats, double(F_at)];
end