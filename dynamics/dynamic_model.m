function sys = dynamic_model(sys, varargin)
% sys:
%   Documentation required
% method:
%   Lagrange [char]: Methodology developed by Lagrange on XIX century
%   for the development of mechanical systems dynamic equations
%   Gibbs-Appel [char]: Methodology developed by Gibbs and Appel, 
% appropriate for constrained mechanical systems

    % Default constraint and holonomicity
    default_is_constrained = false;
    default_is_holonomic = -1;

    p = inputParser;

    % Constraint and holonomicity flags 
    addOptional(p,'is_constrained', default_is_constrained, @isboolean);
    addOptional(p,'is_holonomic', default_is_holonomic, @isboolean);

    is_constrained = p.Results.is_constrained;
    is_holonomic = p.Results.is_holonomic;

    if(is_constrained)
        sys = gibbs_appel_eqdyn(sys, is_holonomic);
    else
        sys = lagrange_eqdyn(sys);
    end

    % Main matrices
    [sys.M, sys.g, sys.friction, sys.nu, sys.U, ...
    sys.H, sys.h, sys.Z] =  dyn_matrices(sys);
end
