function sys = eqdyns(sys, method)
% sys:
%   Documentation required
% method:
%   Lagrange [char]: Methodology developed by Lagrange on XIX century
%   for the development of mechanical systems dynamic equations
%   Orsino [char]: Methodology developed by Professor Orsino from
% University from Sao Paulo for development of mechanism models
% through serial models
    
    % Default method: Lagrange
    switch nargin
        case 1
            error('Choose either lagrange or orsino methods for dynamic methods.');    
    end
    
    % Dynamic equations by chosen method
    switch method
        case 'lagrange'
            sys = lagrange_eqdyn(sys);
       
        case 'orsino'
            sys = orsino_eqdyn(sys);
    
        otherwise
            % Add further methods futurely
    end
    
    [sys.f, sys.g] = state_space(sys);
end