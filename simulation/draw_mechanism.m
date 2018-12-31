function draw_mechanism(mechanism, sim)
    clf;
       
    % End-effector
    mechanism.draw_endeffector(sim, mechanism)
    hold on;
    draw_points(sim);
    hold on;
    draw_bars(sim);
    hold off;
    
    axis equal;
end