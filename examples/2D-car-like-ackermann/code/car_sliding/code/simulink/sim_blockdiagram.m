% Front angles
delta_i_num = 0;

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [1e-3; 2; 2];

x0 = double(subs([qs; ps], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));

% Final time
tf = 5;

% Model loading
model = 'sliding_car';

load_system(model);

simMode = get_param(model, 'SimulationMode');
set_param(model, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model);
mdl_cs = cs.copy;
set_param(mdl_cs,'AbsTol','1e-5',...
        'SaveState','on','StateSaveName','xoutNew',...
        'SaveOutput','on','OutputSaveName','youtNew');

simOut = sim(model, mdl_cs);

set_param(model, 'SimulationMode', simMode);