function traj =  rect(props)
    L0 = props.L0;
    P0 = props.P0;
    P1 = props.P1;
    P2 = props.P2;
    P3 = props.P3;
    orient = props.orient;
    A_max = props.A_max;
    delta = props.delta;

    [t1, tf1, q1, qp1, qpp1] = P2P(P0, P1, A_max, delta);
    [t2, tf2, q2, qp2, qpp2] = P2P(P1, P2, A_max, delta);
    [t3, tf3, q3, qp3, qpp3] = P2P(P2, P3, A_max, delta);
    [t4, tf4, q4, qp4, qpp4] = P2P(P3, P0, A_max, delta);
    
    traj.dt = t1(2) - t1(1);
    traj.t = [t1; tf1+t2; tf1+tf2+t3; tf1+tf2+tf3+t4];
    
    traj.q = [q1; q2; q3; q4];
    
    q1(end, :)
    q2(1, :)
    
    traj.q = [traj.q, orient*ones(length(traj.q), 1)];
    
    traj.qp = [qp1; qp2; qp3; qp4];
    traj.qp = [traj.qp, zeros(length(traj.qp), 1)];
    
    traj.qpp = [qpp1; qpp2; qpp3; qpp4];
    traj.qpp = [traj.qpp, zeros(length(traj.qpp), 1)];    
end