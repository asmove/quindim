function traj =  rect(props)
    L0 = props.L0;
    P0 = props.P0;
    P1 = props.P1;
    P2 = props.P2;
    P3 = props.P3;
    A_max = props.A_max;
    delta = props.delta;

    [t1, tf1, q1, qp1, qpp1] = P2P(P0, P1, A_max, delta);
    [t2, tf2, q2, qp2, qpp2] = P2P(P1, P2, A_max, delta);
    [t3, tf3, q3, qp3, qpp3] = P2P(P2, P3, A_max, delta);
    [t4, tf4, q4, qp4, qpp4] = P2P(P3, P0, A_max, delta);

    traj.dt = dt;
    traj.t = t;
    traj.q = q;
    traj.qp = qp;
    traj.qpp = qpp;
end