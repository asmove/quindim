function [phat_sym, pphat_sym] = phat_pphat_sym(source_reference, C, ...
                                                q, p, xp_hat_s, xpp_hat_s)
    dxdt = dvecdt(source_reference, q, C*p);
    x_q = jacobian(source_reference, q);

    vars_reference = symvar(source_reference);
    is_state = ismember(vars_reference, q); 
    states_reference = vars_reference(is_state);

    is_reference_state = ismember(q, states_reference);
    remaining_states = q(~is_reference_state);

    states_reference = states_reference.';

    r = [states_reference; remaining_states];
    E = equationsToMatrix(r, q);
    F = inv(E);

    y_q = x_q*E;
    Cr = F*C;
    
    B = y_q*Cr;
    Bp = dmatdt(B, q, C*p);
    
    phat_sym = simplify_(pinvB*xp_hat_s);
    pphat_sym = simplify_(pinv(B)*(xpp_hat_s - Bp*p));
end