function traj = bezier_path(t, T, A, B, thetaA, alphaA, alphaB)
    AB = double(B - A);
    thetaB = cart2pol(AB(1), AB(2));

    % []
    r0 = [cos(thetaA); sin(thetaA)];
    r1 = [cos(thetaB); sin(thetaB)];

    C = A + r0*alphaA;
    D = B - r1*alphaB;

    Ps = {A, C, D, B};
    
    t = t/T;
    
    traj = recursive_bezier(t, Ps);
end