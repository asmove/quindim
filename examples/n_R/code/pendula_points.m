function [P0s, P1s, Pgs] = pendula_points(sys, sim)
    n_R = length(sys.descrip.bodies);
    
    % Required states
    q = sim.q;
    
    th_i = 0;
    
    symbs = sys.descrip.syms;
    model_params = sys.descrip.model_params;
    
    P0s = [];
    Pgs = [];
    P1s = [];
    
    for i = 1:n_R
        % Required parameters
        L_i = sys.descrip.syms(5 + (i-1)*8);
        Lg_i = sys.descrip.syms(4 + (i-1)*8);
        
        th_i = th_i + sim.q(i);
        
        L1 = [L_i; 0; 0; 1];
        Lg = [Lg_i; 0; 0; 1];
        
        symb_vars = [sys.kin.q; symbs];
        val_vars = [sim.q; model_params];
        
        T_i = sys.descrip.bodies{i}.T;
        P0_i = T_i(1:2, 4);
        P0_i = my_subs(P0_i, symb_vars, val_vars);        
        
        P1_i = T_i*L1;
        P1_i = my_subs(P1_i, symb_vars, val_vars);
        P1_i = P1_i(1:2);
        
        Pg_i = T_i*Lg;
        Pg_i = my_subs(Pg_i, symb_vars, val_vars);
        Pg_i = Pg_i(1:2);
        
        P0s = [P0s, P0_i];
        P1s = [P1s, P1_i];
        Pgs = [Pgs, Pg_i];
    end
    
    P0s = P0s.';
    P1s = P1s.';
    Pgs = Pgs.';
end