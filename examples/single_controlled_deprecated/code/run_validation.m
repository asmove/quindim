[~, params] = load_params();

% Initial conditions
x0 = [params.q0; params.qp0];
u0 = params.u0;

% Time vector, plotstates
t = 0:0.1:20;

sys_ = sys.subsystems{1};

% System validation
plot_states = @(sol) plot_single_states(sol);

sol = validate_model(sys, t, x0, u0, plot_states);

time = sol.x;
states = sol.y.';
[Kv, Pv, Fv, Tv] = plot_energies(sys_, time, states);