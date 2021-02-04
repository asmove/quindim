function [] = draw_nR(hfig, sys, sim)
%   o
%    \
%     º
%    /
%   ...
%   /    
%  º 
%   \

    % Required states
    q = sim.q;
    th = sim.q(1);
    
    draw_bars(sys, sim);
    hold on;
    
    % Points at each wheel
    [P0s, P1s, Pgs] = pendula_points(sys, sim);
    
    n_R = length(sys.descrip.bodies);
    
    for i = 1:n_R
        hold on;
        plot(P0s(i, 1), P0s(i, 2), 'ro');
        
        hold on;
        plot(Pgs(i, 1), Pgs(i, 2), 'k*');
    end
    
    hold off;
end





