function dvdt = dvecdt(vec, q, qp)
    dvdt = jacobian(vec, q)*qp;
end