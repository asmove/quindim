if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

syms g real;

n_R = input('Insert the number of R arms:');

previous_i = struct('');

Ts_prev = {};
x_prev = [];
xp_prev = [];
xpp_prev = [];

sys.descrip.syms = [];
sys.descrip.model_params = [];
sys.descrip.bodies = {};

for i = 1:n_R
    % Body 1
    m_i = sym(sprintf('m%d', i));
    b_i = sym(sprintf('b%d', i));
    k_i = sym(sprintf('k%d', i));
    d_i = sym(sprintf('d%d', i));
    Lg_i = sym(sprintf('Lg%d', i));
    L_i = sym(sprintf('L%d', i));
    L_i1 = sym(sprintf('L%d', i-1));
    
    th_i = sym(sprintf('th_%d', i));
    thp_i = sym(sprintf('thp_%d', i));
    thpp_i = sym(sprintf('thpp_%d', i));
    
    I_i = inertia_tensor(num2str(i), true);
    
    I_i_flatten = diag(I_i);
    
    x_prev = [x_prev; th_i];
    xp_prev = [xp_prev; thp_i];
    xpp_prev = [xpp_prev; thpp_i];
    
    is_friction_linear1 = true;

    % Previous body - Inertial, in this case
    % CG position relative to body coordinate system
    Lg = [Lg_i; 0; 0];
    
    if(i == 1)
        Ts_i = T3d(th_i, [0; 0; 1], [0; 0; 0]);
    else
        Ts_i = T3d(th_i, [0; 0; 1], [L_i1; 0; 0]); 
    end
    
    Ts_prev = [Ts_prev, {Ts_i}];
    
    % Bodies inertia
    damper_i = build_damper(b_i, [0; 0; 0], [thp_i; 0; 0]);
    spring_i = build_spring(k_i, [0; 0; 0], [th_i; 0; 0]);
    
    symbs_i = [m_i, b_i, k_i, Lg_i, L_i, I_i_flatten.'];
    
    % Paramater of the system
    if(i == 1)
        params_i = [1, 0.01, 1, 0.5, 1, 0.1, 0.1, 0.1];
    else
        params_i = [1, 0.01, 1, 0.5, 1, 0.1, 0.1, 0.1];
    end
    
    body_i = build_body(m_i, I_i, Ts_prev, Lg, ...
                        {damper_i}, {spring_i}, ...
                        x_prev, xp_prev, xpp_prev, ...
                        previous_i, symbs_i);
    
    previous_i = body_i;
    
    % Symbolics of the system
    sys.descrip.syms = [sys.descrip.syms; symbs_i.'];
    
    % System parameters
    sys.descrip.model_params = [sys.descrip.model_params; params_i.'];
    
    sys.descrip.bodies{end+1} = body_i;
end

sys.descrip.syms = [sys.descrip.syms; g];
sys.descrip.model_params = [sys.descrip.model_params; 9.8];

% Gravity utilities
sys.descrip.gravity = [0; -g; 0];
sys.descrip.g = g;

% Generalized coordinates
sys.kin.q = x_prev;
sys.kin.qp = xp_prev;
sys.kin.qpp = xpp_prev;

% Quasi-velocities
sys.kin.p = xp_prev;
sys.kin.pp = xpp_prev;

% External excitations
n_q = length(sys.kin.q);
tau_sym = sym('tau_', [n_R, 1]);
sys.descrip.Fq = tau_sym;
sys.descrip.u = tau_sym;

% Sensors
sys.descrip.y = x_prev;

% State space representation
sys.dyn.states = [x_prev; xp_prev];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);


