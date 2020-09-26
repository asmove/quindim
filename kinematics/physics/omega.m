function [omega_b, omega_n] = omega(R, q, qp)
    Somega = skew_matrix(R, q, qp);
    omega = simplify_(unskew(Somega));
    omega_n = simplify(omega);
    omega_b = simplify_(R.'*omega_n);
end

function S = skew_matrix(R, q, qp)
    Rp = dmatdt(R, q, qp);
    S = Rp.'*R;
end