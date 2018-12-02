function dvdt = ddt(v, q, qp) 
    dv = jacobian(v, q)*qp.';
end