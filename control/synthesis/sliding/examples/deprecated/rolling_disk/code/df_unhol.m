function dx = df_unhol(t, q, sys, tf, Eta)
    persistent wb;
    persistent u_acc;
    
    [n, m] = size(sys.dyn.Z);
    
    if((isempty(wb)) || (~isgraphics(wb.wb)))
        wb = my_waitbar('Control of wheel');
        u_acc = [];
    end 
    
    if((length(sys.kin.C) ~= 1) && (iscell(sys.kin.p)))
    [m, ~] = size(sys.kin.C{1});

    C = eye(m);
    for i = 1:length(sys.kin.C)
        C = C*sys.kin.C{i};
    end
    else
        C = sys.kin.C;
    end

    syms rho gamma_;
    syms x y;
    
    % States and velocities
    sys.kin.q
    q_ = [rho; gamma_; sys.kin.q(3); sys.kin.q(4)];
    
    transf = [rho*cos(gamma_); rho*sin(gamma_)];
    J = jacobian(transf);
    
    sys.kin.q = [rho; gamma_; sys.kin.q(3); sys.kin.q(4)];
    
    Cc = C(1:2, :);
    Ca = C(3:end, :);

    C = [inv(J)*Cc; Ca];
    C = simplify_(subs(C, [x; y], transf));

    q_p = q(1:end);      
    
    V = 0.5*sys.kin.q(1)^2;
    
    Vx = jacobian(V, sys.kin.q);
    
    p = -Eta*C.'*Vx.';
    plant = simplify_(C*p);
    
    plant = subs(plant, sys.descrip.syms, sys.descrip.model_params);
    dx = subs(plant, q_, q);
    
    u = subs(p, sys.descrip.syms, sys.descrip.model_params);
    u
    
    u_acc = [u_acc, u];
    
    assignin('base', 'u_control', u_acc);
    assignin('base', 'wb', wb);
    
    wb = wb.update_waitbar(t, tf);
end
