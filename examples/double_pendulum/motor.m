function sys = motor()
    % Electrical part - motor 
    % Remarks: Inductance neglected
    syms Kt Ke Ra real;
    syms xp F real;
    syms Vcc u PWM real;

    % Mechanical part - motor 
    % Remarks: Inertia neglected
    syms wm Tau;
    
    % Shaft torque
    Vt = Ke*wm;
    V_pwm = Vcc*PWM;
    Tau_ = (Kt/Ra)*(V_pwm - Vt);
    sys.i = Tau_/Kt;
       
    % Tension on armature
    sys.u = PWM;
    sys.transform = @(u, wm_) subs(Tau_, [wm, sys.u], [wm_, u]);
    sys.y = Tau;
        
    sys.states = [];
    
    % Electrical and mechanical system
    sys.syms = [Kt, Ke, Ra, Vcc];
end