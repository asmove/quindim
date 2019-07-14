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

    x = [sys.q; sys.qp];
    xp = [sys.qp; sys.qpp];
    
    n_bodies = length(sys.bodies);
    
    for i = 1:n_bodies
        body = sys.bodies(i);
        
        % Center of mass position
        p_cg = point(body.T, body.p_cg);
        sys.bodies(i).p_cg0 = p_cg;

        % Center of mass velocity
        v_cg = jacobian(p_cg, x.')*xp;
        sys.bodies(i).v_cg = v_cg;
        
        % Body angular velocity
        R = body.T(1:3, 1:3);

        sys.bodies(i).omega = omega(R, x, xp);
        
        if(i ~= n_bodies)
            sys.bodies(i+1).previous_body = sys.bodies(i); 
        end
    end
    
end
