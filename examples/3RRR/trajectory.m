function  traj = trajectory()
%     % [m]
%     R = 0.1;
%     
%     % [rad/s]
%     omega = 1;
% 
%     % End time [s]
%     tf = 2*pi/omega;
%     
%     % Time vector
%     n = 100;
%     t = linspace(0, tf, n);
%     dt = t(2) - t(1);
%     
%     q = [R*cos(omega*t); R*sin(omega*t); omega*t].';
%     qp = [-R*omega*sin(omega*t); R*omega*cos(omega*t); omega*ones(size(t))].';
%     qpp = [-R*omega^2*cos(omega*t); -R*omega^2*sin(omega*t); zeros(size(t))].';

    L0 = 0.05;
    P0 = [L0; L0];
    P1 = [-L0; L0];
    P2 = [-L0; -L0];
    P3 = [L0; -L0];
    A_max = 5;
    
    [t1, tf1, q1, qp1, qpp1] = P2P(P0, P1, A_max);
    [t2, tf2, q2, qp2, qpp2] = P2P(P1, P2, A_max);
    [t3, tf3, q3, qp3, qpp3] = P2P(P2, P3, A_max);
    [t4, tf4, q4, qp4, qpp4] = P2P(P3, P0, A_max);
    
    dt = t1(2) - t1(1);
    t = [t1; tf1+t2; tf1+tf2+t3; tf1+tf2+tf3+t4];
    q = [q1; q2; q3; q4];
    qp = [qp1; qp2; qp3; qp4];
    qpp = [qpp1; qpp2; qpp3; qpp4];
    
    traj.dt = dt;
    traj.t = t;
    traj.q = q;
    traj.qp = qp;
    traj.qpp = qpp;
end
