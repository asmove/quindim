delta_i_num = 0;

L = sys.descrip.syms(end-2);

delta_o_expr = atan(L*tan(tan(delta_i)/(L + w*tan(delta_i))));
sys.kin.A = subs(sys.kin.A, delta_o, delta_o_expr);
sys.kin.C = subs(sys.kin.C, delta_o, delta_o_expr);
sys.kin.Cs = {sys.kin.C};

delta_i = sys.kin.q(4);

delta_o_num = double(subs(delta_o_expr, ...
                          [delta_i; sys.descrip.syms.'], ...
                          [delta_i_num; sys.descrip.model_params.']));

m = length(sys.kin.p{end});
p_val = 5;
qs0 = [0; 0; 0; delta_i_num; delta_o_num; 0; 0; 0; 0];
ps0 = [0.1; 2; 2];

x0 = double(subs([qs0; ps0], [sys.descrip.syms.'; delta_i], ...
                 [sys.descrip.model_params.'; delta_i_num]));
             
A0 = subs(sys.kin.A, sys.kin.q, qs0);
C0 = ;