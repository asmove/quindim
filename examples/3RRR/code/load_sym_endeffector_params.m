function params = load_sym_endeffector_params()
% For this simulation, the geometry of the end-effector is an equilater 
% triangle of side, thickness and material specified below
    % Circle radius [m]
    params.Le = sym('Le');
    
    % Angle relative to body
    params.deltacg = sym('deltacg');
    
    [Xcg, Ycg, Zcg] = pol2cart(params.Le, params.deltacg, 0);
    params.cg = [Xcg; Ycg; Zcg];
    
    % Mass [Kg]
    params.m = sym('me'); 

    % Inertia [Kg*m^2] - Source: https://bit.ly/1DsCrVC
    params.J = diag([sym('Jex'), sym('Jey'), sym('Jez')]);
    
    % Joint relative position 
    % By symmetry, the reference point is baricenter of the projected 
    % circle
    
    % End-effector distance between reference frame and  [m] 
    % Geometrically, the radius of an equilater triangle MUST a*sqrt(3)/3
    params.Le1 = params.Le;
    params.Le2 = params.Le;
    params.Le3 = params.Le;
    
    % Angles relative to coordinate frame system attached to the
    % end-effector
    params.gamma1 = sym('gamma1');
    params.gamma2 = sym('gamma2');
    params.gamma3 = sym('gamma3');
end