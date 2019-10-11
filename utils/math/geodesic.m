function dx = geodesic(t, vars, manifold, tf, iters)
    persistent wb_;
    
    if(isempty(wb_))
        wb_ = my_waitbar('Calculating geodesic...');
    end
    
    u_s = sym('u');
    v_s = sym('v');
    zeta_s = sym('zeta');
    eta_s = sym('eta');
    
    u = vars(1);
    v = vars(2);
    eta = vars(3);
    zeta = vars(4);
    
    vars_s = [u_s; v_s; eta_s; zeta_s];
    
    Gamma_1_11 = subs(manifold.Gamma_1_11, vars_s, vars);
    Gamma_1_12 = subs(manifold.Gamma_1_12, vars_s, vars);
    Gamma_1_22 = subs(manifold.Gamma_1_22, vars_s, vars);

    Gamma_2_11 = subs(manifold.Gamma_2_11, vars_s, vars);
    Gamma_2_12 = subs(manifold.Gamma_2_12, vars_s, vars);
    Gamma_2_22 = subs(manifold.Gamma_2_22, vars_s, vars);
    
    dx = [zeta; 
          eta; 
          -Gamma_1_11*zeta^2 - 2*Gamma_1_12*zeta*eta - Gamma_1_22*eta^2;
          -Gamma_2_11*zeta^2 - 2*Gamma_2_12*zeta*eta - Gamma_2_22*eta^2];
    
    wb_ = wb_.update_waitbar(t, tf);
end