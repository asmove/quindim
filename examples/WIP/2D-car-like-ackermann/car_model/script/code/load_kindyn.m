% Generalized coordinates
sys.kin.q = [x_pos; y_pos; theta; 
             delta_i; delta_o; 
             phi_i; phi_o; 
             phi_r; phi_l];
sys.kin.qp = [xp; yp; thetap; 
              deltap_i; deltap_o; 
              phip_i; phip_o; 
              phip_r; phip_l];
sys.kin.qpp = [xpp; ypp; thetapp; 
               deltapp_i; deltapp_o; 
               phipp_i; phipp_o; 
               phipp_r; phipp_l];

% External excitations
sys.descrip.Fq = [0; 0; 0; 0; 0; f_phi_i; f_phi_o; f_phi_r; f_phi_l];
sys.descrip.u = [f_phi_i; f_phi_o; f_phi_r; f_phi_l];

% State space representation
sys.descrip.states = [x_pos; y_pos; theta; delta_i; delta_o; phi_i; phi_o; phi_r; phi_l];

% Quick hack: Obtain unconstrained velocity of each wheel 
sys.descrip.is_constrained = false;
sys = kinematic_model(sys);

% Constraint condition
sys.descrip.is_constrained = true;

run('./consts_gen.m');

% Kinematic and dynamic model
sys = kinematic_model(sys);

sys = calculate_jacobians(sys);
sys = update_jacobians(sys, sys.kin.C);

sys = dynamic_model(sys);
