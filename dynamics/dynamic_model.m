function sys = dynamic_model(sys)
% sys:
%   Documentation required
% method:
%   Lagrange [char]: Methodology developed by Lagrange on XIX century
%   for the development of mechanical systems dynamic equations
%   Gibbs-Appel [char]: Methodology developed by Gibbs and Appel, 
% appropriate for constrained mechanical systems
    
    % TOFIX: Allow Gibbs-appel and Lagrange
    method = 'lagrange';
    
    % Dynamic equations
    sys = eqdyns(sys, method);
end
