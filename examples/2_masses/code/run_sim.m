% Initia conditions [m; m/s]
x0 = [0; 1; 0; 1];

m_num = sys.descrip.model_params(1);
k_num = sys.descrip.model_params(3);
omega = sqrt(k_num/m_num);

% Time [s]
tf = 2*pi/omega;
dt = tf/100;

[~, m] = size(sys.dyn.Z);

u_func = @(t, x) zeros(m, 1);

% Initial conditions [m; m/s]

% Model loading
model_name = 'simple_model';
simOut = simsys(model_name, sys, x0, tf);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
t = simOut.tout;

x = [q, p];