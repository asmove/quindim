function [As, Bs, A_delta, B_delta] = lindyn(poles)

    % Linear dynamic
    A_delta = [];
    B_delta = [];
    As = [];
    Bs = [];

    m = length(poles);

    i = 1;
    for poles_ = poles
        poles_ = poles_{1};
        coeffs = ctrb_coeffs(poles_);

        n_p = length(poles_);

        % Unitary matrices
        Ai = ctrb_canon(poles_);

        bi = canon_Rn(m, i).';
        Bi = [zeros(n_p - 1, m); bi];

        while(~is_ctrb(Ai, Bi))
            bi = canon_Rn(n, i);
            Bi = [zeros(delta_i-1, 1); bi];
        end

        A_delta = direct_sum({A_delta, coeffs});
        B_delta = [B_delta; bi];

        As = direct_sum({As, Ai});
        Bs = [Bs; Bi];
        
        i = i + 1;
    end

end