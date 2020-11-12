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

    % Required states
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
    center_1 = P + R0c*C1;
    center_2 = P + R0c*C2;
    center_3 = P + R0c*C3;
    center_4 = P + R0c*C4;
    
    norm(center_1 - center_2)
    
    % Wheels separately
    wheels = [build_wheel(center_1, -pi/2 + th + delta_i, R); 
              build_wheel(center_2, -pi/2 + th + delta_o, R);
              build_wheel(center_3, -pi/2 + th, R);
              build_wheel(center_4, -pi/2 + th, R)];    
    
    % Car wheels
    draw_wheels(hfig, wheels);
    
    % Chassi points
    points = [center_1, center_2, ...
              center_4, center_3, center_1]';
    
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


