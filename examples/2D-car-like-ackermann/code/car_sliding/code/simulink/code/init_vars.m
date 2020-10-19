for i = 1:length(sys.descrip.syms)
    var_name = char(sys.descrip.syms(i));
    var_val = sys.descrip.model_params(i);
    
    assignin('caller', var_name, var_val);
end

% % % Friction parameters
% Cp_1 = 1000;
% mu_1 = 1e-3;
% Fz_1 = g*(mc/4 + mi);
% 
% Cp_2 = 1000;
% mu_2 = 1e-3;
% Fz_2 = g*(mc/4 + mi);

% Friction parameters
Cp_1 = 0;
mu_1 = 1e-3;
Fz_1 = g*(mc/4 + mi);

Cp_2 = 0;
mu_2 = 1e-3;
Fz_2 = g*(mc/4 + mi);

D = 2*sys.descrip.model_params(end-4);
perc = 0.3;
a = double(perc*D);

% Initial conditions
delta_i_num = 0;

delta_o_expr = atan(L*tan(delta_i)/(L + w*tan(delta_i)));
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.Cs = {sys.kin.C};

m = length(sys.kin.p{end});
p_val = 5;
qs = [0; 0; 0; delta_i_num; delta_o_expr; 0; 0; 0; 0];
ps = [0.1; 2; 2];

x0 = double(subs([qs; ps], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));
