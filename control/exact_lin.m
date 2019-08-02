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
    transfs = reldeg_struct.transfs;
    phis = reldeg_struct.phis;
    Delta = reldeg_struct.Delta;
    
    % Coordinate transformations
    z = transfs;
    
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
    
    % System does not have zero dynamics
    if(sum(deltas) == n)
        zs = sym('z', [n, 1], 'real');
        
        % Symbolic for zs
        out.z_sym = zs;
        
        % Inverse transformations
        transfs_1 = solve(zs == transfs, x, 'ReturnConditions', true);

        transfs_1 = rmfield(transfs_1, 'parameters');
        transfs_1 = rmfield(transfs_1, 'conditions');

        transfs_1_values = sym([]);
        fnames_t = fieldnames(transfs_1);

        for i = 1:length(fnames_t)
            transfs_1_values(end+1) = getfield(transfs_1, fnames_t{i});
        end
        
        transfs_1_values = transfs_1_values.';
        
        out.zp_x = simplify_(jacobian(transfs, x)*(f + G*u));
        out.zp_z = simplify_(subs(out.zp_x, x, transfs_1_values));

    else
        transfs_1_values = [];
    end
        
    % Exact linearization struct
    out.ctrb_matrix = ctrb_nlin(f, G, x);
    out.obsv_matrix = obsv_nlin(f, y, x);
    
    % Output function and new input
    out.u = simplify_(u);
    out.v = v; 
    
    % Exact linearization 
    out.Delta = simplify_(Delta); 
    out.phis = simplify_(phis);
    
    % Transformations forward and inverse for linearization
    out.transfs = transfs;
    out.transfs_1 = transfs_1_values;
    
    % Relative degrees
    out.deltas = deltas;
    
    % Poles of closed loop
    out.poles = poles; 
    
    % Closed loop matrices
    out.As = As; 
    out.Bs = Bs;
    out.A_delta = A_delta; 
    out.B_delta = B_delta;
end
