function dx = df_unhol(t, q, sys, tf, Eta, V)
    persistent wb;
    persistent u_acc;
    
    [n, m] = size(sys.dyn.Z);
    
    if((isempty(wb)) || (~isgraphics(wb.wb)))
        wb = my_waitbar('Simulate underactuated');
        u_acc = [];
    end
    
    % States and velocities
    q_ = sys.kin.q;
    
    if((length(sys.kin.p) ~= 1) && (iscell(sys.kin.p)))
        p = sys.kin.p{end};
    else
        p = sys.kin.p;
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
    
    q_p = q(1:end);      
       
    symbs = q_;
    nums = q;
    
    Vx = jacobian(V, sys.kin.q);
    
    u = -Eta*sign(C.'*Vx.');
    u = subs(u, sys.descrip.syms, sys.descrip.model_params);

    u = subs(u, q_, q);
                                
    plant = subs(C*p, p, u);
    plant = subs(plant, sys.descrip.syms, sys.descrip.model_params);
    
    u_acc = [u_acc; u];
    
    dx = double(subs(plant, symbs, nums));
    
    u_acc = [u_acc; u];
    
    assignin('base', 'u_control', u_acc);
    assignin('base', 'wb', wb);
    
    wb = wb.update_waitbar(t, tf);
end
