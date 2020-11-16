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

% Kinematic and dynamic model
sys = kinematic_model(sys);