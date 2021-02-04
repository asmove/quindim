function [c_points, centers] = chassi_points(sys, sim)
    % Required parameters
    L = sys.descrip.model_params(2);
    R = sys.descrip.model_params(end-1);
    
    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    th1 = sim.q(4);
    th2 = sim.q(5);
    th3 = sim.q(6);
    
    T0 = T3d(th, [0; 0; 1], [x; y; 0]);
    T1 = T3d(th1, [1; 0; 0], [L; 0; 0]);
    T2 = T3d(2*pi/3, [0; 0; 1], [0; 0; 0]);
    T3 = T3d(th2, [1; 0; 0], [L; 0; 0]);
    T4 = T3d(4*pi/3, [0; 0; 1], [0; 0; 0]);
    T5 = T3d(th3, [1; 0; 0], [L; 0; 0]);

    T01 = T0;
    T02 = T0*T2;
    T03 = T0*T4;
    
    % Wheel center in car reference frame
    C_1 = [L; 0; 0; 1];
    
    % Point inbetween two back wheels
    P = [x; y; 0];
    
    % Rotation matrices
    R0c = rot2d(th);
    
    % Wheel centers
    P1 = T01*C_1;
    P2 = T02*C_1;
    P3 = T03*C_1;
    
    P1 = P1(1:2);
    P2 = P2(1:2);
    P3 = P3(1:2);
    
    % Center
    centers = [P1, P2, P3]';
    
    % Chassi points
    c_points = [P, P1, P2, P3]';
    
end