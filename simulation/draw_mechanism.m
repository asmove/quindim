function draw_mechanism(mechanism, i, sims)       
    % End-effector
    mechanism.draw_endeffector(sims{i}, mechanism)
    hold on;
    mechanism.draw_generalized(sims{i}, mechanism)
    hold on;
    mechanism.draw_trajectory(sims)
    hold on;
    draw_points(mechanism, sims{i});
    hold on;
    draw_bars(mechanism, sims{i});
    hold off;
    
    axis square;
end