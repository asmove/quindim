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
    
    sys = calculate_jacobians(sys);
    
    % Constrain the system by provided constraints
    sys = constraints_props(sys);
end
