function R = rot_quaternion(q)

    % Norm of q
    s = norm(q);
    
    % q = qr + qx*i + qy*j + qz*k
    q_ = formula(sym(q));
    
    qr = q_(1);
    qx = q_(2);
    qy = q_(3);
    qz = q_(4);
    
    % Rotation matrix
    R = [1 - 2*s*(qy^.2 + qz.^2),     2*s*(qx*qy - qz*qr),     2*s*(qx*qz + qy*qr); ...
             2*s*(qx*qy + qz*qr), 1 - 2*s*(qx^.2 + qz.^2),     2*s*(qx*qz + qy*qr);  ...
             2*s*(qx*qz + qy*qr),     2*s*(qy*qz + qx*qr), 1 - 2*s*(qx^.2 + qy.^2)];
         
end