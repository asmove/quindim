function sys = eqdyns(sys, method)
    % sys:
    %   Documentation   required
    % method:
    %   Lagrange [char]: Methodology developed by Lagrange on XIX century
    %   for the development of mechanical systems dynamic equations
    %   Orsino [char]: Methodology developed by Professor Orsino from
    % University from Sao Paulo for development of mechanism models
    % through serial models
    
    % Default method: Lagrange
    switch nargin
        case 1
            method = 'Lagrange';    
    end
    
    % Dynamic equations by chosen method
    switch method
        case 'Lagrange'
            [~, sys] = lagrange_eqdyn(sys);
       
        case 'Orsino'
            [~, sys] = lagrange_eqdyn(sys);
            % Add further methods futurely
    end
    
end