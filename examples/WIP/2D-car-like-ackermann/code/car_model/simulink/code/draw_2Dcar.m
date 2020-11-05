function draw_2Dcar(hfig, sys, sim)
%  
%  1|'''''|2
%   |     |
%   |     |
%  3|.....|4
%  
    
    % Required parameters
    R = sys.descrip.model_params(end-4);
    w = sys.descrip.model_params(end-3);
    L = sys.descrip.model_params(end-2);
    Lc = sys.descrip.model_params(end);
    
    % Required states
    q = sim.q;
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    delta_i = sim.q(4);
    delta_o = sim.q(5);
    
    % Wheel center in car reference frame
    C1 = [-w/2; L];
    C2 = [w/2; L];
    C3 = [-w/2; 0];
    C4 = [w/2; 0];
    
    % Point inbetween two back wheels
    P = [x; y];
    
    % Rotation matrices
    R0c = rot2d(-pi/2 + th);
    
    % Wheel centers
    center_i = P + R0c*C1;
    center_o = P + R0c*C2;
    center_r = P + R0c*C3;
    center_l = P + R0c*C4;
    
    
    % Wheels separately
    wheels = [build_wheel(center_i, -pi/2 + th + delta_i, R); 
              build_wheel(center_o, -pi/2 + th + delta_o, R);
              build_wheel(center_r, -pi/2 + th, R);
              build_wheel(center_l, -pi/2 + th, R)];
          
    % Car wheels
    draw_wheels(hfig, wheels);
    
    % Chassi points
    points = [center_i, center_o, center_l, center_r, center_i]';
    
    % Radius
    symbs = [sys.kin.q; sys.descrip.syms.'];
    vals = [q; sys.descrip.model_params.'];
    
    B_i = subs(sys.descrip.bodies{2}.p_cg0, symbs, vals);
    B_o = subs(sys.descrip.bodies{3}.p_cg0, symbs, vals);
    B_l = subs(sys.descrip.bodies{4}.p_cg0, symbs, vals);
    B_r = subs(sys.descrip.bodies{5}.p_cg0, symbs, vals);
    
    B_i = B_i(1:2);
    B_o = B_o(1:2);
    B_r = B_r(1:2);
    B_l = B_l(1:2);
    
    cot_delta = (1/tan(delta_o) + 1/tan(delta_i))/2;
    delta = acot(cot_delta);
    R1 = L*cot_delta
    Ri = L*csc(delta_i)
    Ro = L*csc(delta_o)
    
    if(isinf(Ri))
        Ri = L;
    end
    
    if(isinf(Ro))
        Ro = L;
    end
    
    v_i = [-sin(delta_i + th); cos(delta_i + th)];
    v_o = [-sin(delta_o + th); cos(delta_o + th)];
    v_r = [-sin(th); cos(th)];
    v_l = v_r;
    
    B_i = center_i + Ri*v_i;
    B_o = center_o + Ro*v_o;
    B_l = center_r + (R1 - w/2)*v_l;
    B_r = center_l + (R1 + w/2)*v_r;
    
    xy_i = [center_i, B_i]';
    xy_o = [center_o, B_o]';
    xy_r = [center_r, B_r]';
    xy_l = [center_l, B_l]';
    
    plot(xy_i(:, 1), xy_i(:, 2), '-');
    plot(xy_o(:, 1), xy_o(:, 2), '-');
    plot(xy_r(:, 1), xy_r(:, 2), '-');
    plot(xy_l(:, 1), xy_l(:, 2), '-');
    
    % Points at each wheel
%         draw_chassi(points);
end

function wheel = build_wheel(center, angle, R)
    wheel.center = center;
    wheel.orientation = angle;
    wheel.radius = R;
    wheel.A = center + rot2d(angle)*[0; R];
    wheel.B = center - rot2d(angle)*[0; R];
end

function draw_chassi(points)
    fill(points(:, 1), points(:, 2), 'w')
    axis square;
end


