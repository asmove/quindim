function draw_2Dcar(hfig, sys, sim)
%  
%   |''s''|
%   |     |
%   |     |
%  l|.....|r
%  

    % Required parameters
    R = sys.descrip.syms(6);
    R_s = sys.descrip.syms(7);
    w = sys.descrip.syms(10);
    L_f = sys.descrip.syms(12);
    L_s = sys.descrip.syms(13);
    L = sys.descrip.syms(14);

    % Required states
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    % Wheel center in car reference frame
    C_s = [0; L_f];
    C_br = [-w/2; 0];
    C_bl = [w/2; 0];
    C_br = [-w/2; 0];
    C_bl = [w/2; 0];
    
    % Point inbetween two back wheels
    P = [x; y];
    
    % Rotation matrices
    R0c = rot2d(th);
    
    % Wheel centers
    center_r = P + R0c*C_br;
    center_l = P + R0c*C_bl;
    center_s = P + R0c*C_s;
    
    % Wheels separately
    wheels = [build_wheel(center_r, th + beta_, R_s); 
              build_wheel(center_l, th, R);
              build_wheel(center_s, th, R)];    
    
    % Car wheels
    draw_wheels(hfig, wheels);
    
    P_fr = P + R0c*C_fr;
    P_fl = P + R0c*C_fr;
    P_br = center_r;
    P_bl = center_l;
    
    % Chassi points
    points = [P_fr, P_fl, P_br, P_bl, P_fr]';
    
    % Points at each wheel
    draw_chassi(points);
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


