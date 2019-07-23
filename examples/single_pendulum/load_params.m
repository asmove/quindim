function [params, params_str] = load_params()

    % Mechanical parameters
    % Distances between shafts
    L1 = 0.18;
    
    % Distance to center of mass
    L1_cg = 0.16404822;
    
    % Body masses
    m0 = 0.440;
    m1 = 0.153;
    
    % Viscuous friction
    b0 = 0.01;
    b1 = 0.01;
    
    % Inertia
    I1 = 0.00068267;
    
    % Gravity
    g = 9.8;
    
    % Electrical params
    % Source voltage
    Vcc = 12;
    
    % Armature voltage
    Ra = 12/20;
    
    % Eletromechanical parameters
    Ke = 12/(2*pi*437/60);
    Kt = 2.157304/20;
    
    % Pulley's radius
    D = 2*0.0226;

    % Model parameters
    params = [g, m0, b0, ...
              m1, I1, b1, L1, L1_cg, ...
              Kt, Ke, Ra, Vcc, D];
          
    % Structure system parameters
    params_str.g = g;
    params_str.m0 = m0;
    params_str.b0 = b0;
    params_str.m1 = m1;
    params_str.I1 = I1;
    params_str.b1 = b1;
    params_str.L1 = L1;
    params_str.L1_cg = L1_cg;
    params_str.Kt = Kt; 
    params_str.Ke = Ke; 
    params_str.Ra = Ra;
    params_str.Vcc = Vcc;
    params_str.D = D;
    
    % Linearization parameters
    params_str.x0 = [0, pi, 0, 0];
    params_str.u0 = 0;
    
    % Initial values
    eps_ = 10*pi/180;
    
    params_str.q0 = [0, pi+eps_];
    params_str.qp0 = [0, 0];
    params_str.xhat0 = [0; 0; ...
                        0; 0];
    
    % Simulation setup
    params_str.tf = 10;
    params_str.step_amplitude = 0.2;
    params_str.nbits = 10;
end
