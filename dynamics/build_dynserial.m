function serial = build_dynserial(serial)
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
    D = serial.D;
    
    % dD/dt = Dp
    % p = D*qp <=> pp = Dp*qp + D*qpp <=> qpp = pinv(D)*(pp - Dp*qp)
    [serial.qpp, serial.Dp] = pp2qpp(serial.D, serial.q, ...
                                     serial.qp, serial.pp);

    % Serial dynamic equations               
    serial.eqdyn = eqdyn_serial(serial);

    % Serial systems unified representation
    serial.M = serial.eqdyn.M;
    serial.nu = serial.eqdyn.nu;
    serial.g = serial.eqdyn.g;
    serial.U = serial.eqdyn.U;

end
