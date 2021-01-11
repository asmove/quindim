function [] = draw_bars(sys, sim)
    nR = length(sys.descrip.bodies);

    [P0s, P1s, ~] = pendula_points(sys, sim);
    
    % Required parameters
    for i = 1:nR
        P1i = P0s(i, :);
        P2i = P1s(i, :);
        
        Ps_i = [P1i; P2i];
        
        plot(Ps_i(:, 1), ...
             Ps_i(:, 2), ...
             'LineWidth', 10)

        hold on;
    end
end
