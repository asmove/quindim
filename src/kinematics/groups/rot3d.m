function R = rot3d(theta, rotvec)
    u = sym('u');
    assume(u, 'real')
    
    [~, ncols] = size(rotvec);
    if(ncols~=1)
        error('Argument 2 must be a column vector!');
    end
    
    % Equivalent quaternion
    q = quaternion(u, rotvec);
    
    % Rotation matrix by quaternion 
    R = rot_quaternion(q);
    
    R = simplify(R);
    
    R = subs(R, u, theta);
end
    