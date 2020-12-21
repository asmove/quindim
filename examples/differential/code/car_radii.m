function seg_B = car_radii(hfig, sys, sim)
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);

    ell2 = (L_c*sin(beta_))^2 + (L_f*cos(beta_))^2;
    
    x_part = L_f*cos(beta_);
    y_part = L_c*sin(beta_);
    beta_g = atan2(y_part, x_part);
    
    radius_1 = L_f*cos(beta_)/sin(beta_);
    radius_s = radius_1/cos(beta_);
    radius_g = sqrt(ell2)/sin(beta_);
    radius_r = radius_1 + w/2;
    radius_l = radius_1 - w/2;
    
    v_s = [-sin(th + beta_); cos(th + beta_)];
    v_r = [-sin(th); cos(th)];
    v_l = v_r;
    v_g = [-sin(th + beta_g); cos(th + beta_g)];
    
    B_s = center_s + radius_s*v_s;
    B_l = center_bl + radius_l*v_l;
    B_r = center_br + radius_r*v_r;
    B_g = center_g + radius_g*v_g;
    
    xy_s = [center_s, B_s]';
    xy_r = [center_br, B_r]';
    xy_l = [center_bl, B_l]';
    xy_g = [center_g, B_g]';
    
    if(isinf(radius_r))
        radius_r = 0;
    end
    
    if(isinf(radius_l))
        radius_l = 0;
    end
    
    if(isinf(radius_g))
        radius_g = 0;
    end
    
    radii = [radius_s, radius_g, ...
             radius_r, radius_l];
    
    dir_r = [v_s, v_r, v_l, v_g];
    center_B = [B_s, B_r, B_l, B_g];
    seg_B = {xy_s, xy_r, xy_l, xy_g};
end