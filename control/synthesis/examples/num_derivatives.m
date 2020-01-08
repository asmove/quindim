% Final improvement
for i = 1:length(time)-2
    theta_0 = coords(i, 1);
    theta_p1 = coords(i+1, 1);
    theta_p2 = coords(i+2, 1);

    phi_0 = coords(i, 2);
    phi_p1 = coords(i+1, 2);
    phi_p2 = coords(i+2, 2);

    omega_theta = (-1.5*theta_0 + 2*theta_p1 - 0.5*theta_p2 )/dt;
    omega_phi = (-1.5*phi_0 + 2*phi_p1 - 0.5*phi_p2 )/dt;

    accels(i, 1) = omegap_theta;
    accels(i, 2) = omegap_phi; 
end

for i = length(time):-1:3
    theta_0 = coords(i, 1);
    theta_1 = coords(i-1, 1);
    theta_2 = coords(i-2, 1);

    phi_0 = coords(i, 2);
    phi_1 = coords(i-1, 2);
    phi_2 = coords(i-2, 2);

    omega_theta = (-1.5*theta_2 + 2*theta_1 - 0.5*theta)/dt;
    omega_phi = (-1.5*phi_2 + 2*phi_1 - 0.5*phi_0)/dt;

    accels(i, 1) = omegap_theta;
    accels(i, 2) = omegap_phi;
end

for i = 1:length(time)-2
    omega_theta = speeds(i, 1);
    omega_theta_p1 = speeds(i+1, 1);
    omega_theta_p2 = speeds(i+2, 1);

    omega_phi = speeds(i, 2);
    omega_phi_p1 = speeds(i+1, 2);
    omega_phi_p2 = speeds(i+2, 2);

    omegap_theta = (omega_theta_p2 - 2*omega_theta_p1 + omega_theta_0)/dt^2;
    omegap_phi = (omega_phi_p2 - 2*omega_phi_p1 + omega_phi_0)/dt^2;

    accels(i, 1) = omegap_theta;
    accels(i, 2) = omegap_phi; 
end

for i = length(time):-1:3
    omega_theta = speeds(i, 1);
    omega_theta_1 = speeds(i-1, 1);
    omega_theta_2 = speeds(i-2, 1);

    omega_phi = speeds(i, 2);
    omega_phi_1 = speeds(i-1, 2);
    omega_phi_2 = speeds(i-2, 2);

    omegap_theta = (omega_theta_2 - 2*omega_theta_1 + omega_theta)/dt^2;
    omegap_phi = (omega_phi_2 - 2*omega_phi_1 + omega_phi)/dt^2;

    accels(i, 1) = omegap_theta;
    accels(i, 2) = omegap_phi;
end

accels(1, 1) = accels(5, 1);
accels(2, 1) = accels(5, 1);
accels(3, 1) = accels(5, 1);
accels(4, 1) = accels(5, 1);

accels(1, 2) = accels(5, 2);
accels(2, 2) = accels(5, 2);
accels(3, 2) = accels(5, 2);
accels(4, 2) = accels(5, 2);

coords = double(coords);