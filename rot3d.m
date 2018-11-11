function R = rot3d(theta, rotvec)
    % Equivalent quaternion
    q = quaternion(theta, rotvec);
    
    % Rotation matrix by quaternion 
    R = rot_quaternion(q);
end
    