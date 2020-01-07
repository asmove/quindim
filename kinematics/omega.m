function [omega_b, omega_n] = omega(R, q, qp)
    Rp = simplify_(dmatdt(R, q, qp));
    Somega = simplify_(Rp*R.');
    
    omega = simplify_(unskew(Somega));
    omega_n = simplify(omega);
    omega_b = simplify_(R.'*omega_n);
end
