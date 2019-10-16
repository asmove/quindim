function linsys =  lin_sys(sys, x_WP, u_WP, Ts, ndelay)
    % States and control variables
    linvars = [sys.dyn.states; sys.descrip.u];
    WP = [x_WP; u_WP];
    
    % Workint points
    linsys.x_WP = x_WP;
    linsys.u_WP = u_WP;
    linsys.y_WP = subs(sys.descrip.y, linvars, WP);
    
    % Matrices A, B, C and D for each working-point
    linsys.linvars = sym('u%d', size(sys.dyn.states));
    
    % Linearization matrices (arbitrary)
    linsys.A0 = jacobian(sys.dyn.f + sys.dyn.G*sys.descrip.u, ...
                         sys.dyn.states);
    linsys.B0 = jacobian(sys.dyn.f + sys.dyn.G*sys.descrip.u, ...
                         sys.descrip.u);
    linsys.C0 = jacobian(sys.descrip.y, sys.dyn.states);
    linsys.D0 = jacobian(sys.descrip.y, sys.descrip.u);
        
    % Matrices on the provided working-point
    A = subs(linsys.A0, linvars, WP);
    B = subs(linsys.B0, linvars, WP);
    C = subs(linsys.C0, linvars, WP);
    D = subs(linsys.D0, linvars, WP);
    
    % Working point linearization points
    linsys.A_WP = simplify(A);
    linsys.B_WP = simplify(B);
    linsys.C_WP = simplify(C);
    linsys.D_WP = simplify(D);
    
    
    linsys.A = double(subs(linsys.A_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.B = double(subs(linsys.B_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.C = double(subs(linsys.C_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.D = double(subs(linsys.D_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
            
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
    
    % POles, zeros and controllability
    [sys1_disc.nulls, ...
     sys1_disc.poles, ...
     sys1_disc.is_ctrb, ...
     sys1_disc.is_obsv] = plant_behaviour(sys1_disc.ss);
    
    % Augmented state space representation - with input-delay
    sys2_disc.ts = Ts;
    sys2_disc.ss = inputdelay_dss(sys1_disc.ss, ndelay);
     
    linsys.continuous.systems = {sys_cont};
    linsys.discrete.systems = {sys1_disc, sys2_disc};
end