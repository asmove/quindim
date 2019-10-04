function dx = geodesic(t, vars, manifold)
    u = vars(1);
    v = vars(2);
    zeta = vars(3);
    eta = vars(4);
    
    u = sym('u');
    v = sym('v');
    zeta = sym('zeta');
    eta = sym('eta');
    
    manifold_fields = fieldnames(manifold);
    for i = 1:numel(manifold_fields)
        fieldname = manifold_fields(i);
        i_field_manifold = manifold.(manifold_fields{i});
        
        i_manifold = subs(i_field_manifold, manifold.symbs, manifold.nums);
        
        i_manifold = subs(i_field_manifold, [u; v; eta; zeta], vars);
        manifold.(manifold_fields{i}) = i_manifold;
    end
    
    Gamma_1_11 = manifold.Gamma_1_11;
    Gamma_1_12 = manifold.Gamma_1_12;
    Gamma_1_22 = manifold.Gamma_1_22;

    Gamma_2_11 = manifold.Gamma_2_11;
    Gamma_2_12 = manifold.Gamma_2_12;
    Gamma_2_22 = manifold.Gamma_2_22;
    
    dx = [zeta; 
          eta; 
          -Gamma_1_11*zeta^2 - 2*Gamma_1_11*zeta*eta - Gamma_1_11*eta^2;
          -Gamma_2_11*zeta^2 - 2*Gamma_2_11*zeta*eta - Gamma_2_11*eta^2];
    dx = subs(dx, [u; v; eta; zeta], vars);
    vars
end