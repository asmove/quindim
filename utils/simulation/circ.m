function traj = circ(props)
    % [m]
    R = props.R;

    % [rad/s]
    omega = props.omega;

    % End time [s]
    tf = 2*pi/omega;
    
    orient = props.orient;

    % Time vector
    n = 100;
    t = linspace(0, tf, n);
    dt = t(2) - t(1);
       
    q = [R*cos(omega*t); R*sin(omega*t); orient*ones(1, length(t))].';
    qp = [-R*omega*sin(omega*t); R*omega*cos(omega*t); zeros(1, length(t))].';
    qpp = [-R*omega^2*cos(omega*t); -R*omega^2*sin(omega*t); zeros(1, length(t))].';

    traj.dt = dt;
    traj.t = t;
    traj.q = q;
    traj.qp = qp;
    traj.qpp = qpp;
end