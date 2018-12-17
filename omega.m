function omega = omega(R, q, qp)
    Rp = dmatdt(R, q, qp);
    Somega = Rp*R.';
    omega = unskew(Somega);
    omega = simplify(omega);
end
