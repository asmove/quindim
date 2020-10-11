function Fa = lin_friction(v, N, fric_symbs)
    mu_s = fric_symbs(1);
    mu_c = fric_symbs(2);
    mu_v = fric_symbs(3);
    
    omega_s = fric_symbs(4);
    v_s = fric_symbs(5);
    
    Fa = mu_s*(v/v_s)*exp(-(v/v_s)^2) + mu_c*N*sign(v) + mu_v*v;
end