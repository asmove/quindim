% Initial conditions [m; m/s]
x0 = [0; 0; 0; 0; 0; 0; 5; 5; 5];
u0 = [0; 0; 0];

% Time [s]
tf = 5;

% System modelling
model_name = 'simple_model';
gen_scripts(sys, model_name);

    load_system(model_name);

    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;
    set_param(mdl_cs, 'SolverType','Variable-step', ...
                      'SaveState','on','StateSaveName','xoutNew', ...
                      'SaveOutput','on','OutputSaveName','youtNew');

    save_system();

    t0 = tic();
    simOut = sim(model_name, mdl_cs);
    toc(t0);

q = simOut.coordinates.signals.values;
p = simOut.p_speeds.signals.values;
x = [q, p];

states = simOut.states.signals.values;
q_speeds = simOut.q_speeds.signals.values;
tspan = simOut.tout;
