function R = rot3d(theta, rotvec)
    u = sym('u');
    assume(u, 'real')

    % Equivalent quaternion
    q = quaternion(u, rotvec);
    
    % Rotation matrix by quaternion 
    R = rot_quaternion(q);
    
    R = simplify(R);
    
    R = subs(R, u, theta);
end
    