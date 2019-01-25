function serial = load_sym_serial_params(i)
% Units
%   Mass    : [Kg]
%   Inertia : [Kg*m^2]
%   Length  : [m]
%   Angle   : [rad]
    % Base parameters
    base.params.L0 = sym(sprintf('L0%d', i), 'real');
    base.params.beta = sym(sprintf('beta%d', i), 'real');
    
    % 1st link
    body1.params.L1 = sym(sprintf('L1%d', i), 'real');
    body1.params.L1g = sym(sprintf('L1%dg', i), 'real');
    body1.params.cg = [body1.params.L1g; 0; 0];
       
    body1.params.m = sym(sprintf('m1%d', i), 'real');
    body1.params.J = sym(sprintf('J1_%d', i), [3, 3], 'real');
    
    tau = sym(sprintf('tau%d', i), 'real');
    
    body1.excitations.forces.symbs = [];
    body1.excitations.momenta.symbs = [tau];
    
    body1.excitations.forces.entities = {};
    body1.excitations.momenta.entities = {[0; 0; tau]};
    
    % 2nd link
    body2.params.L2 = sym(sprintf('L2%d', i), 'real');
    body2.params.L2g = sym(sprintf('L2%dg', i), 'real');
    body2.params.cg = [body2.params.L2g; 0; 0];

    body2.params.m = sym(sprintf('m2%d', i), 'real');
    body2.params.J = sym(sprintf('J2_%d', i), [3, 3], 'real');
    
    body2.excitations.forces.symbs = {};
    body2.excitations.momenta.symbs = {};
    
    body2.excitations.forces.entities = {};
    body2.excitations.forces.applications = {};
    body2.excitations.momenta.entities = {};
    
    gravity = [0; 0; -sym('g')];
    serial.gravity = gravity;
    serial.base = base;
    serial.bodies = {body1, body2};
end