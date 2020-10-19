% Front angles
delta_i_num = 0;

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0; 4; 2];

x0 = double(subs([qs; ps], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

% Final time
tf = 6;

% Model loading
model = 'sliding_car';

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

