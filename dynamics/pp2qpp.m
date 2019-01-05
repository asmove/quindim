function [qpp, Dp] = pp2qpp(D, q, qp, pp)
    % dD/dt = Dp
    Dp = dmatdt(D, q, qp);

    % p = D*qp <=> pp = Dp*qp + D*qpp <=> qpp = pinv(D)*(pp - Dp*qp)
    qpp = simplify(pinv(D)*(pp - Dp*qp));
end