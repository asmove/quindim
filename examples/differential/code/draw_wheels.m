function [] = draw_wheels(hfig, sys, sim)
    % Required parameters
    R = sys.descrip.model_params(6);
    R_s = sys.descrip.model_params(7);
    L_c = sys.descrip.model_params(9);
    w = sys.descrip.model_params(10);
    L_f = sys.descrip.model_params(11);
    L = sys.descrip.model_params(14);
    
    [~, centers] = chassi_points(sys, sim);
    
    center_s = centers(1, :)';
    center_fl = centers(2, :)';
    center_fr = centers(3, :)';
    center_br = centers(4, :)';
    center_bl = centers(5, :)';
    center_g = centers(6, :)';
    
    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    % Wheels separately
    wheels = [build_wheel(center_s, th + beta_, R_s, 1);
              build_wheel(center_br, th, R, 1);
              build_wheel(center_bl, th, R, 1)];
    
    t0 = tic();
    
    n_wheel = length(wheels);
    
    for i = 1:n_wheel
        draw_wheel(hfig, wheels(i));
    end
end

function [] = draw_wheel(hfig, wheel)
    set(0, 'CurrentFigure', hfig);
    
    orientation = wheel.orientation;
    R = wheel.radius;
    center = wheel.center;
    width = wheel.width;
    
    A = wheel.A;
    B = wheel.B;
    
    head = [A(1); B(1)];
    tail = [A(2); B(2)];
    
    plot(head, tail, 'k', 'LineWidth', width);
    
    hold on;
    plot(center(1), center(2), 'ro');
    hold on;
end