function draw_system(sys, sim)       
    % End-effector
    sys.draw_bodies(sys, sim);
    hold on;
    sys.draw_trajectory(sim);
    hold on;
    draw_points(sys, sim);
    hold off;
    
    axis square;
end
