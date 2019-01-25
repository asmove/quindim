function params = load_num_endeffector_params()
% For this simulation, the geometry of the end-effector is a
% circle of side, thickness and material specified below
    params = struct();
    
    % Material: Alluminum 
    %   density [kg/m^3]
    params.rhoe = 2700;

    % Circle radius [m]
    params.Le = 5/100;

    % Center of mass position [m] [rad]
    params.Lecg = 0;
    params.deltacg = 0;
    [Xcg, Ycg, Zcg] = pol2cart(params.Lecg, params.deltacg, 0);
    params.cg = [Xcg; Ycg; Zcg];
    
    % End-effector thickness [m]
    params.he = 8/1000;
    
    % End-effector volume [m^3]
    params.Ve = params.he*pi*params.Le^2;
    
    % Mass [Kg]
    params.m = params.rhoe*params.Ve; 

    % Inertia [Kg*m^2] - Source: https://bit.ly/1DsCrVC
    Jex = (1/12)*params.m*(3*params.Le^2 + params.he);
    Jey = Jex;
    Jez = (1/2)*params.m*params.Le^2;
    
    params.J = diag([Jex, Jey, Jez]);
    
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
    params.gamma1 = 0;
    params.gamma2 = 2*pi/3;
    params.gamma3 = 4*pi/3;    
end