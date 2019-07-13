function T = transformations_endeffector(endeffector)
% Transformation matrices of coordinate systems
% Coordinate frame system 1 (CFS1i): Attached to motor i
% Coordinate frame system 2 (CFS2i): Attached to first bar i on motor
% shaft's center 
% Coordinate frame system 3 (CFS3i): Attached to second bar i on elbow
% Coordinate frame system e (CFSei): Attached to end-effector
    
    x = endeffector.generalized.q(1);
    y = endeffector.generalized.q(2);
    alpha = endeffector.generalized.q(3);
    
    gamma1 = endeffector.params.gamma1;
    gamma2 = endeffector.params.gamma2;
    gamma3 = endeffector.params.gamma3;

    TNe = T3d(alpha, [0; 0; 1], [x; y; 0]);
    TNe1 = TNe*T3d(gamma1, [0; 0; 1], [0; 0; 0]);
    TNe2 = TNe*T3d(gamma2, [0; 0; 1], [0; 0; 0]);
    TNe3 = TNe*T3d(gamma3, [0; 0; 1], [0; 0; 0]);
    
    T = {vpa(simplify(TNe)), ...
             vpa(simplify(TNe1)), ...
             vpa(simplify(TNe2)), ...
             vpa(simplify(TNe3))};
end