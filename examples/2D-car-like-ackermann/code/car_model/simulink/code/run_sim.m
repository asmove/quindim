% Final time
tf = 5;

% Model loading
model = 'car_model';

load_system(model);

simMode = get_param(model, 'SimulationMode');
set_param(model, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model);
mdl_cs = cs.copy;
set_param(mdl_cs,'AbsTol','1e-6',...
                 'SaveState','on','StateSaveName','xoutNew',...
                 'SaveOutput','on','OutputSaveName','youtNew');

t0 = tic();
simOut = sim(model, mdl_cs);
toc(t0);

set_param(model, 'SimulationMode', simMode);

