function [u, v, Delta, phis, deltas, ...
          z, poles, A_delta, B_delta] = exact_lin(f, G, y, x)
    % Dimensions
    [~, m] = size(G);
    
    % Transformed inputs
    v = sym('v', [m, 1]);
    
    % Relative matrices
    [deltas, transformations, phis, Delta] = nreldegs(f, G, y, x);
    
    % Coordinate transformations
    z = transformations;
    
    poles = request_poles_deltas(deltas);
    
    % Linear dynamic
    A_delta = [];
    B_delta = [];
    As = [];
    Bs = [];

    i = 1;
    for poles_ = poles
        poles_
        poles_ = poles_{1};
        coeffs = ctrb_coeffs(poles_);
        
        delta_i = deltas(i);
        
        % Unitary matrices
        Ai = ctrb_canon(poles_);

        bi = rand(1, m);
        Bi = [zeros(delta_i-1, m); bi];
        
        r = rank(B_delta);
        q = rank([B_delta; bi]);
        if(~is_ctrb(Ai, Bi) || q ~= r+1 )
            bi = rand(1, m);
            Bi = [zeros(delta_i-1, m); bi];
        end
        
        A_delta = direct_sum({A_delta, coeffs});
        B_delta = [B_delta; bi];
    
        As = direct_sum({As, Ai});
        Bs = [Bs; Bi];
    end
    
    Delta = simplify_(Delta);
    u = Delta\(-A_delta*z - phis + B_delta*v);
end

function poles = request_poles_deltas(deltas)
    % Request user poles 
    poles = {};
    for delta = deltas
        pole = request_poles(delta);
        poles{end+1} = pole;
    end
end
