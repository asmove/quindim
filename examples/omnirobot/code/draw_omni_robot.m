function [] = draw_omni_robot(hfig, sys, sim)
%      1
%   |'''''|
%   |     |
%   |.....|
%  3       2

    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    L = sys.descrip.model_params(2);
    
    P = [x; y];
    
    % Points at each wheel
    viscircles(P', L, 'Color', 'k');
    axis square;
    hold on;
    
    
    uv = L*[cos(th); sin(th)];
    quiver(P(1), P(2), uv(1), uv(2));
    
    hold on;
    
    % Car wheels
    draw_wheels(hfig, sys, sim);
    
    hold on;    
    plot(P(1), P(2), 'ro');
    hold off;
end

