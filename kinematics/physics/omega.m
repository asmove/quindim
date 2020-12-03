function [omega_n, omega_b] = omega(R, q, qp)
% Description: Calculates the body velocity
% Input: 
%   - R: Rotation matrix
%   - q: States
%   - qp: States derivatives
% Output: 
%   - omega_n: Angular speed on inertial coordinate system
%   - omega_b: Angular speed on body coordinate system

    Somega = skew_matrix(R, q, qp);
    omega = simplify_(unskew(Somega));
    omega_n = simplify(omega);
    omega_b = simplify_(R.'*omega_n);
end

function S = skew_matrix(R, q, qp)
    Rp = dmatdt(R, q, qp);
    S = R.'*Rp;
end