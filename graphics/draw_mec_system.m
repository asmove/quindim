function draw_system(sys, i, sims)       
    % End-effector
    sys.draw_bodies(sims{i}, mechanism);
    hold on;
    sys.draw_trajectory(sims);
    hold on;
    draw_points(sys, sims{i});
    hold off;
    
    axis square;
end