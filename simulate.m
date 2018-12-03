function mechanism = simulate(mechanism, trajectory)
    n = length(t);
    u = zeros(size(t));
    
    % Cumbersome first case scenario
    % Nummeric evaluation
    C_0 = coupling_matrixC();
    C_1 = coupling_matrixC();
    
    for i = 1:n
        q = trajectory.q(:, i);
        qp = trajectory.qp(:, i);
        qpp = trajectory.qpp(:, i);
        
        if i == 1
            mechanism.simulation = ;
        else
            mechanism.simulation = ;
        end
        
    end
end