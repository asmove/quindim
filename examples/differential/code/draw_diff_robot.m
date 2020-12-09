function [] = draw_diff_robot(hfig, sys, sim)
%  
%   |''s''|
%   |     |
%   |     |
%  l|.....|r
%       

    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    P = [x; y];
    
    % Points at each wheel
    [c_points, ~] = chassi_points(sys, sim);
    draw_chassi(hfig, c_points);
    
    hold on;
    
    % Car wheels
    draw_wheels(hfig, sys, sim);
    
    hold on;
    
    % Car radii
    draw_radii(hfig, sys, sim)
    
    hold on;    
    plot(P(1), P(2), 'ro');
    hold off;
end





