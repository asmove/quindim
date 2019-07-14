function draw_trajectory(sim, traj)
    hold on;
    x = traj.q(:, 1);
    y = traj.q(:, 2);
    plot(x, y);
    
    x = sim.q(1);
    y = sim.q(2);
    
    L = 0.1;
    u = L*cos(sim.q(3));
    v = L*sin(sim.q(3));
    quiver(x, y, u, v);
    
    hold on;
end