function draw_endeffector(sim, mechanism)
    d = double([sim.q(1), sim.q(2)]);
    alpha = double(sim.q(1));
    scaler = 0.1;
    
    viscircles(d(1), d(2), mechanism.endeffector.params.Le1);
    
    plot(d(1), d(2), 'k+');
    quiver(d(1), d(2), scaler*cos(alpha), scaler*sin(alpha));
end