function out = exact_lin(f, G, y, x)
% Description: Exact linearization algorithm
% https://www.overleaf.com/read/sgxkhqvfhpyz
% Input:
%     - [sym]: Characteristic matrix of the system
%     - [sym]: Input matrix of the system
%     - [sym]: Output matrix of the system
%     - [sym]: states
% Output:
%     - [sym]: Output of the system
%     - [sym]: New output
%     - [sym]: 
%     - [sym]: Coupling matrix
%     - [vector]: Relative degrees of each output
%     - [sym]: Coordinate change
%     - [cell]: Exact linearization poles
%     - [matrix]: Exact linearization characteristic matrix
%     - [matrix]: Exact linearization input matrix 
      
    % Dimensions
    [n, m] = size(G);
    
    % Transformed inputs
    v = sym('v', [m, 1]);
    
    % Relative matrices
    reldeg_struct = nreldegs(f, G, y, x);
    
    % Relative degree structure
    deltas = reldeg_struct.deltas; 
    transformations = reldeg_struct.transformations;
    phis = reldeg_struct.phis;
    Delta = reldeg_struct.Delta;
    
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
        poles_ = poles_{1};
        coeffs = ctrb_coeffs(poles_);
        
        delta_i = deltas(i);
        
        % Unitary matrices
        Ai = ctrb_canon(poles_);
        
        bi = canon_Rn(m, i).';
        Bi = [zeros(delta_i-1, m); bi];
        
        while(~is_ctrb(Ai, Bi))
            bi = canon_Rn(n, i);
            Bi = [zeros(delta_i-1, m); bi];
        end
        
        A_delta = direct_sum({A_delta, coeffs});
        B_delta = [B_delta; bi];
        
        As = direct_sum({As, Ai});
        Bs = [Bs; Bi];
    end
    
    Delta_inv = vpa(Delta\eye(length(Delta)));
    u = simplify_(Delta_inv*(-A_delta*z - phis + B_delta*v));
        
    % Exact linearization struct
    out.u = u; 
    out.v = v; 
    out.Delta = Delta; 
    out.phis = phis;
    out.transformations = transformations;
    out.deltas = deltas;
    out.z = z;
    out.poles = poles; 
    out.As = As; 
    out.Bs = Bs;
    out.A_delta = A_delta; 
    out.B_delta = B_delta;
end