function sys = kinematic_model(sys)
% Requirements:
% Input:
%     - [struct]: Multibody characteristics
%     bodies: [3×1 struct] : m I q qp qpp previous_body T p_cg b 
%     fric_is_linear params
%           q: [5×1 sym]   : generalized coordinates
%          qp: [5×1 sym]   : generalized velocities
%         qpp: [5×1 sym]   : generalized accelerations
%     gravity: [3×1 sym]   : Gravity vector
%           g: [1×1 sym]   : gravity symbol
%      states: [10×1 sym]  : States
%          Fq: [5×1 sym]   : Generalized forces 
%           u: [2×1 sym]   : External active forces 
%           y: [2×1 sym]   : Sensor readings of the system
% Output: 
%    - [struct]: Multibody characteristics (Same as input) plus
%       bodies: p_cg0 v_cg omega
    
    % System jacobian
    Jv = [];
    Jw = [];
    
    % States and its derivatives
    q = sys.kin.q;
    qp = sys.kin.qp;
    
    x = [sys.kin.q; sys.kin.qp];
    xp = [sys.kin.qp; sys.kin.qpp];
    
    n_bodies = length(sys.descrip.bodies);
    
    for i = 1:n_bodies
        body_curr = sys.descrip.bodies{i};
        
        % Center of mass position
        sys.descrip.bodies{i}.p_cg0 = point(body_curr.T, body_curr.p_cg);
        
        % Center of mass velocity
        p_cg = sys.descrip.bodies{i}.p_cg0;

        sys.descrip.bodies{i}.v_cg = simplify_(jacobian(p_cg, x.')*xp);
        
        v_cg = sys.descrip.bodies{i}.v_cg;
        
        % Body angular velocity
        R = body_curr.T(1:3, 1:3);
        omega_ = omega(R, x, xp);
        
        sys.descrip.bodies{i}.omega = simplify_(omega_);
        
        if(i ~= n_bodies)
            sys.descrip.bodies{i+1}.previous_body = sys.descrip.bodies{i}; 
        end
        
        % Jacobians for each body
        Jvi = equationsToMatrix(v_cg, qp);
        Jwi = equationsToMatrix(omega_, qp);
        
        sys.descrip.bodies{i}.Jv = Jvi;
        sys.descrip.bodies{i}.Jw = Jwi;
        
        % System jacobian
        Jv = [Jv; Jvi];
        Jw = [Jw; Jwi];
    end
    
    % System jacobian
    sys.dyn.Jv = simplify_(Jv);
    sys.dyn.Jw = simplify_(Jw);
    
    % Constrain the system by provided constraints
    sys = constraints_props(sys);
end
