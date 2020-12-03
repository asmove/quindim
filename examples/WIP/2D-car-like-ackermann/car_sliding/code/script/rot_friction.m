function Ta = rot_friction(w, fric_symbs)
    mu_s = fric_symbs(1);
    mu_c = fric_symbs(2);
    mu_v = fric_symbs(3);
    
    omega_s = fric_symbs(4);
    v_s = fric_symbs(5);

    Ta = mu_s*(w/omega_s)*exp(-(w/omega_s)^2) + mu_c*sign(w) + mu_v*w;
end