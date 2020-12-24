function [] = draw_wheels(hfig, sys, sim)
    % Required parameters
    R = sys.descrip.model_params(end-1);
    
    [~, centers] = chassi_points(sys, sim);
    
    center_1 = centers(1, :)';
    center_2 = centers(2, :)';
    center_3 = centers(3, :)';
    
    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    wheel_width = 7;
    
    % Wheels separately
    wheels = [build_wheel(center_1, th, R, wheel_width);
              build_wheel(center_2, th + 2*pi/3, R, wheel_width);
              build_wheel(center_3, th + 4*pi/3, R, wheel_width)];
    
    t0 = tic();
    
    n_wheel = length(wheels);
    
    for i = 1:n_wheel
        hold on;
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
    plot(center(1), center(2), 'r+');
    hold on;
end