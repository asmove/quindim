function sys = double_pendulum_mechanics()
    % --- Plant parameters ---
    % Inertial
    syms m0 m1 m2 real;
    I0 = zeros(3, 3);
    I1 = inertia_tensor(1);
    I2 = inertia_tensor(2);   
    
    % Viscuous friction
    syms b0 b1 b2 real;
    
    % Spring constant
    syms k0 k1 k2 real;
          
    % Gravity
    syms g;
    gravity = [0; -g; 0];
    
    % Dimensional
    syms L1 L2 L1_cg L2_cg real; 
    
    % Extern excitations
    syms F;
    
    % Pulley radius
    syms D;

    % Generalized variables
    syms x th1 th2 real;
    syms xp  th1p th2p real;
    syms xpp th1pp th2pp real;
    
    states = [x; th1; th2];
    dstates = [xp; th1p; th2p];
    
    % Transformations
    T0 = {T3d(0, [0, 0, 1].', [x; 0; 0])};
    
    T11 = T0{1};
    
    T12 = T3d(-pi/2, [0, 0, 1].', [0; 0; 0]);
    T13 = T3d(th1, [0, 0, 1].', [0; 0; 0]);
    T1 = {{T11}, {T12}, {T13}};

    T21 = T1;
    T22 = T3d(0, [0, 0, 1].', [L1; 0; 0]);
    T23 = T3d(th2, [0, 0, 1].', [0; 0; 0]);
    T2 = {{T11}, {T12}, {T13}, {T22}, {T23}};
        
    T1 = cat(2, T1{:});
    T2 = cat(2, T2{:});
    
    T01 = collapse_transformations(T1);
    T02 = collapse_transformations(T2);

    
    % Pulley, trolley, bar 1 and bar 2 points
    p_A = [0; 0; 0];
    p_B = [x; 0; 0];
    p_C = point(T01, [L1; 0; 0]);
        
    % Pulley, trolley, bar 1 and bar 2 speeds
    v_A = [xp*2/D; 0; 0];
    v_B = [xp; 0; 0];
    
    T02p = dmatdt(T02, states, dstates);
    v_C = velocity(T02p, p_C);
    
    % Bodies
    % Car
    L0cg = [0; 0; 0];
    
    spring0 = build_spring(k0, v_A, v_B);
    damper0 = build_damper(b0, [0;0;0], v_B);
    
    car = build_body(m0, I0, T0, L0cg, damper0, spring0,...
                     x, xp, xpp, struct(''), [m0, b0, k0, D]);
    
    % Bar 1
    L1cg = [L1_cg; 0; 0];
    
    spring1 = build_spring(k1, [0; 0; 0], [0; 0; th1]);
    damper1 = build_damper(b1, [0; 0; 0], [0; 0; th1p]);
    
    bar1 = build_body(m1, I1, T1, L1cg, damper1, spring1, ...
                      th1, th1p, th1p, car, [m1, b1, k1, L1, L1cg]);

    % Bar 2    
    L2cg = [L2_cg; 0; 0];
    
    spring2 = build_spring(k2, [0; 0; 0], [0; 0; th2]);
    damper2 = build_damper(b2, [0; 0; 0], [0; 0; th2p]);
    
    bar2 = build_body(m2, I2, T2, L2cg, damper2, spring2, ...
                      th2, th2p, th2pp, bar1, [m2, b2, k2, L2, L2cg]);

    % System
    sys.bodies = [car, bar1, bar2];
    sys.gravity = gravity;
    sys.g = g;

    sys.q = [x; th1; th2];
    sys.qp = [xp; th1p; th2p];
    sys.p = [xp; th1p; th2p];
    sys.qpp = [xpp; th1pp; th2pp];
    sys.pp = [xpp; th1pp; th2pp];
    
    sys.Fq = [F; 0; 0];
    sys.u = F;
    sys.y = [x; th1; th2];
    
    sys.states = [sys.q; sys.qp];
    
    sys.is_constrained = false;
    
    % System symbolics
    sys.syms = [g];
    sys.syms = [sys.syms, m0, b0, k0];
    sys.syms = [sys.syms, m1, k1, I1(3, 3), b1, L1, L1_cg];
    sys.syms = [sys.syms, m2, k2, I2(3, 3), b2, L2, L2_cg]; 
    
    % Movement formalism
    sys = kinematic_model(sys);
    sys = dynamic_model(sys);
end
