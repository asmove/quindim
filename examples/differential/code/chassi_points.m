function [c_points, centers] = chassi_points(sys, sim)
    % Required parameters
    R = sys.descrip.model_params(6);
    R_s = sys.descrip.model_params(7);
    L_c = sys.descrip.model_params(9);
    w = sys.descrip.model_params(10);
    L_f = sys.descrip.model_params(11);
    L = sys.descrip.model_params(14);

    % Required states
    q = sim.q;
    
    x = sim.q(1);
    y = sim.q(2);
    th = sim.q(3);
    beta_ = sim.q(4);
    
    % Wheel center in car reference frame
    C_g = [L_c; 0];
    C_s = [L_f; 0];
    C_fl = [L; -w/2];
    C_fr = [L; w/2];
    C_bl = [0; -w/2];
    C_br = [0; w/2];
    
    % Point inbetween two back wheels
    P = [x; y];
    
    % Rotation matrices
    R0c = rot2d(th);
    
    % Wheel centers
    center_s = P + R0c*C_s;
    center_fl = P + R0c*C_fl;
    center_fr = P + R0c*C_fr;
    center_br = P + R0c*C_br;
    center_bl = P + R0c*C_bl;
    center_g = P + R0c*C_g;
    
    centers = [center_s, center_fl, center_fr, ...
               center_br, center_bl, center_g]';
    
    % Chassi points
    c_points = [center_fl, center_fr, center_br, center_bl, center_fl]';
end