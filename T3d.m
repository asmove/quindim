function [T] = T3d(theta, rot_vec, d)
    R = rot3d(theta, rot_vec);
    R = formula(sym(R));
    T = [R, d; zeros(1, 3), 1];
end