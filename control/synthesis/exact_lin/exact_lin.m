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
    
    y_refs = {};
    y_pps = [];
    
    % Coordinate transformations
    for i = 1:length(deltas)
        diff_n = '';
        
        y_refs_ = [];
        for j = 1:deltas(i)
            output_ij = ['y', diff_n, num2str(i), '_ref'];
            
            y_refs_ = [y_refs_; sym(output_ij)];
            diff_n = [diff_n, 'p'];
        end
        
        y_refs{end+1} = y_refs_;
        
        output_ij = ['y', diff_n, num2str(i), '_ref'];
        
        y_pps = [y_pps; sym(output_ij)];
    end
    
    ref_vals = [];
    for i = 1:length(y_refs)
        ref_vals = [ref_vals; y_refs{i}];
    end
    
    z_tilde = transfs - ref_vals;
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
            Bi = [zeros(delta_i-1, 1); bi];
        end
        
        A_delta = direct_sum({A_delta, coeffs});
        B_delta = [B_delta; bi];
        
        As = direct_sum({As, Ai});
        Bs = direct_sum({Bs, Bi});
    end
    
    I_n = eye(length(Delta));
    Delta_inv = vpa(Delta\I_n);
    
    u = simplify_(Delta_inv*(-A_delta*z_tilde + B_delta*v - phis + y_pps));
    
    % System does not have zero dynamics
    if(sum(deltas) == n)
        transfs_1_values = invfunc(transfs, x);
        
        out.zp_x = simplify_(jacobian(transfs, x)*(f + G*u));
        out.zp_z = simplify_(subs(out.zp_x, x, transfs_1_values));

    else
        transfs_1_values = [];
    end
    
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
    
    refs = [];
    for i = 1:length(y_refs)
        y_refs{i} = [y_refs{i}; y_pps(i)];
        refs = [refs; y_refs{i}];
    end
    
    out.y_ref_sym = refs;
    out.z_tilde = z_tilde;
end
