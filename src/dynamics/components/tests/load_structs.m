[n_Ctilde, ~] = size(Ctilde);

% Plant parameters
params_plant.Phi = Phi;
params_plant.Gamma = Gamma;
params_plant.C = C;
params_plant.Ctilde = Ctilde;

% Load delay parameters
[Phi, Gamma, C, D] = delay_io(Phi, Gamma, C, D, nds_i, nds_o);

% More plant parameters
params_plant.Phi_d = Phi;
params_plant.Gamma_d = Gamma;
params_plant.C_d = C;
params_plant.Ctilde_d = [Ctilde, ...
                         zeros(n_Ctilde, nds_i + nds_o)];

% Load control parameters
params_u.L = L;
params_u.Kp = Kp;
params_u.Ki = Ki;
params_u.nd_u = nds_i;
params_u.Ts = Ts_val;
params_u.Tpwm = Tpwm_val;
params_u.Vcc = Vcc_val;

% Initial values
x0 = [1; 0];
xhat0 = [0; 0]; 

params_plant.xhat0 = xhat0;

x0 = [x0; zeros(nds_i + nds_o)];

params_plant.x0 = x0;

dt = 1e-4;
tf = 1;