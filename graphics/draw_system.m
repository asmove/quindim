function draw_system(sys, sim)
    % End-effector
    sys.draw_bodies(sim, sys);
    hold on;
    sys.draw_endeffector(sim, sys);
    hold on;
    draw_points(sys, sim);
    hold on;
    sys.draw_generalized(sim);
    hold off;
    
    axis equal;
end
