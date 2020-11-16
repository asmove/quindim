[n_t, ~] = size(sol);

R = sys.descrip.model_params(end-4);
model_params = sys.descrip.model_params.';
sym_vars = sys.descrip.syms.';

radius_1 = w/2 + L/tan(delta_i);
radius_g = radius_1/cos(delta);
radius_l = radius_1 - w/2;
radius_r = radius_1 + w/2;
radius_i = radius_l/cos(delta_i);
radius_o = radius_r/cos(delta_o);

radius_g = subs(radius_g, sym_vars, model_params);
radius_i = subs(radius_i, sym_vars, model_params);
radius_o = subs(radius_o, sym_vars, model_params);
radius_r = subs(radius_r, sym_vars, model_params);
radius_l = subs(radius_l, sym_vars, model_params);
v_cg = subs(v_cg, sym_vars, model_params);

A = subs(A, sym_vars, model_params);
C = subs(C, sym_vars, model_params);

q_p = [sys.kin.q; sys.kin.p{end}];
symbs = [q_p; delta];

n_f = 20;

wb = my_waitbar('');

unhol_const = subs(sys.descrip.unhol_constraints, sym_vars, model_params);

w_vals = [];
unhol_consts = [];
for i = 1:n_f
    delta_val = my_subs(delta_sym, q_p, sol(i, :)');
    vals = [sol(i, :)'; delta_val];
    
    C_p = my_subs(C*sys.kin.p{end}, symbs, vals);
    
    radius_g_val = my_subs(radius_g, symbs, vals);
    radius_i_val = my_subs(radius_i, symbs, vals);
    radius_o_val = my_subs(radius_o, symbs, vals);
    radius_r_val = my_subs(radius_r, symbs, vals);
    radius_l_val = my_subs(radius_l, symbs, vals);

    u_g_val = my_subs(u_g, symbs, vals);
    v_cg_val = my_subs(v_cg, sys.kin.qp, C_p);

    v_g = dot(v_cg_val, u_g_val);
    radius_g_val = my_subs(radius_g, symbs, vals); 
    
    phip_i = C_p(end);
    phip_o = C_p(end);
    phip_r = C_p(end);
    phip_l = C_p(end);
    
    
    angular_g = v_g/radius_g_val;
    angular_i = phip_i*R/radius_i_val;
    angular_o = phip_o*R/radius_o_val;
    angular_r = phip_r*R/radius_r_val;
    angular_l = phip_l*R/radius_l_val;
    
    unhol_const_i = my_subs(unhol_const, ...
                            [sys.kin.qp; symbs], ...
                            [C_p; vals]);
    
    w_vals = [w_vals; angular_g, angular_i, angular_o, angular_r, angular_l];
    unhol_consts = [unhol_consts; unhol_const_i.'];
    
    wb.update_waitbar(i, n_f);
end


