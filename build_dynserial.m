function build_dynserial(serial)
    q = serial.generalized.q;
    qp = serial.generalized.qp;
    p = serial.generalized.p;
    pp = serial.generalized.pp;
    
    serial.q = q;
    serial.qp = qp;
    serial.p = p;
    serial.pp = pp;
    
    % p = D*qp
    serial.D = equationsToMatrix(qp, p);

    % dD/dt = Dp
    % p = D*qp <=> pp = Dp*qp + D*qpp <=> qpp = pinv(D)*(pp - Dp*qp)
    [serial.qpp, serial.Dp] = pp2qpp(D, q, qp, pp);

    % Serial dynamic equations               
    serial.eqdyn = eqdyn_serial(serial);

    % Serial systems unified representation
    serial.M_i = eqdyn_s.M;
    serial.nu_i = eqdyn_s.nu;
    serial.g_i = eqdyn_s.g;
    serial.U_i = eqdyn_s.U;
end