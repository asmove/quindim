function serial = load_num_serial_params(i)
% Units
%   Mass    : [Kg]
%   Inertia : [Kg*m^2]
%   Length  : [m]
%   Angle   : [rad]
    
    meq = @(L, W, H, rho) L*W*H*rho;
    Jcgeq = @(m, a, b) m*(a^2 + b^2)/12;
    
    % Base parameters
    base.params.L0 = 40/100;
    base.params.beta = (i-1)*2*pi/3;
    
    % 1st link
    body1.params.rho1 = 2700;
    body1.params.W1 = 10/100;
    body1.params.H1 = 5/1000;
    body1.params.L1 = 25/100;
    body1.params.L1g = body1.params.L1/2;
    body1.params.cg = [body1.params.L1g; 0; 0];
    
    m1 = meq(body1.params.L1, ...
             body1.params.W1, ...
             body1.params.H1, ...
             body1.params.rho1);
    
    body1.params.m = m1;
    
    J1x = Jcgeq(m1, body1.params.W1, body1.params.H1);
    J1y = Jcgeq(m1, body1.params.L1, body1.params.H1);
    J1z = Jcgeq(m1, body1.params.L1, body1.params.W1);

    body1.params.J = diag([J1x, J1y, J1z]);
    
    tau = sym(sprintf('tau%d', i), 'real');
    
    body1.excitations.forces.symbs = [];
    body1.excitations.momenta.symbs = tau;
    
    body1.excitations.forces.entities = {};
    body1.excitations.momenta.entities = {[0; 0; tau]};
    
    % 2nd link
    body2.params.rho2 = 2700;
    body2.params.W2 = 10/100;
    body2.params.H2 = 5/1000;
    body2.params.L2 = 50/100;
    body2.params.L2g = body2.params.L2/2;
    body2.params.cg = [body2.params.L2g; 0; 0];
       
    m2 = meq(body2.params.L2, ...
             body2.params.W2, ...
             body2.params.H2, ...
             body2.params.rho2);
    
    body2.params.m = m2;
    
    J2x = Jcgeq(m2, body2.params.W2, body2.params.H2);
    J2y = Jcgeq(m2, body2.params.L2, body2.params.H2);
    J2z = Jcgeq(m2, body2.params.L2, body2.params.W2);

    body2.params.J = diag([J2x, J2y, J2z]);

    body2.excitations.forces.symbs = {};
    body2.excitations.momenta.symbs = {};
    
    body2.excitations.forces.entities = {};
    body2.excitations.forces.applications = {};
    body2.excitations.momenta.entities = {};
    
    gravity = [0; 0; -9.8];
    serial.gravity = gravity;
    serial.base = base;
    serial.bodies = {body1, body2};
end