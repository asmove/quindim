function linsys =  lin_sys(sys, WP, Ts, ndelay)
    linvars = [sys.states; sys.u];
    
    % Matrices A, B, C and D for each working-point
    linsys.linvars = sym('u%d', size(sys.states));
    
    linsys.A0 = jacobian(sys.f, sys.states);
    linsys.B0 = jacobian(sys.f, sys.u);
    linsys.C0 = jacobian(sys.g, sys.states);
    linsys.D0 = jacobian(sys.g, sys.u);
        
    % Matrices on the provided working-point
    A = subs(linsys.A0, linvars, WP);
    B = subs(linsys.B0, linvars, WP);
    C = subs(linsys.C0, linvars, WP);
    D = subs(linsys.D0, linvars, WP);
       
    linsys.A_WP = simplify(A);
    linsys.B_WP = simplify(B);
    linsys.C_WP = simplify(C);
    linsys.D_WP = simplify(D);
        
    linsys.A = double(subs(linsys.A_WP, sys.syms, sys.model_params));
    linsys.B = double(subs(linsys.B_WP, sys.syms, sys.model_params));
    linsys.C = double(subs(linsys.C_WP, sys.syms, sys.model_params));
    linsys.D = double(subs(linsys.D_WP, sys.syms, sys.model_params));
            
    % State space representation
    sys_cont.ss = ss(linsys.A, linsys.B, linsys.C, linsys.D);
    
    % Poles, nulls, controlability and observability
    [sys_cont.nulls, ...
     sys_cont.poles, ...
     sys_cont.is_ctrb, ...
     sys_cont.is_obsv] = plant_behaviour(sys_cont.ss);
        
    % Discretized system
    sys1_disc.ts = Ts;
    
    sys1_disc.ss = c2d(sys_cont.ss, Ts, 'zoh');
    
    [sys1_disc.nulls, ...
     sys1_disc.poles, ...
     sys1_disc.is_ctrb, ...
     sys1_disc.is_obsv] = plant_behaviour(sys1_disc.ss);
    
    % Augmented state space representation - with input-delay
    sys2_disc.ts = Ts;
    sys2_disc.ss = inputdelay_dss(sys1_disc.ss, ndelay);
    
    % Poles, nulls, controlability and observability
    [sys2_disc.nulls, ...
     sys2_disc.poles, ...
     sys2_disc.is_ctrb, ...
     sys2_disc.is_obsv] = plant_behaviour(sys2_disc.ss);
 
    linsys.continuous.systems = {sys_cont};
    linsys.discrete.systems = {sys1_disc, sys2_disc};
end