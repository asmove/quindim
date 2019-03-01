% Time delays for the system
ndelay = 1;

% Sample time for the system
Ts = 1/100;

% Plant parameters
sys = double_pendulum(Ts, ndelay);

% Time delays for the system
ndelay = 0;

% Sample time for the system
Ts = 1/100;

% Plant parameters
dsys = sys.lin_sys.discrete.systems{1}.ss;

% Continuous paramters of plant
A = sys.lin_sys.continuous.systems{1}.ss.a;
B = sys.lin_sys.continuous.systems{1}.ss.b;
C = sys.lin_sys.continuous.systems{1}.ss.c;
D = sys.lin_sys.continuous.systems{1}.ss.d;

Ts = dsys.ts;

% Plant matrices
Phi = dsys.a;
Gamma = dsys.b;
C = dsys.c;

params.Phi = Phi;
params.Gamma = Gamma;
params.C = C;

% Sample time
params.ts = dsys.ts;