function draw_radii(hfig, sys, sim)
    set(0, 'CurrentFigure', hfig);
    
    seg_B = car_radii(hfig, sys, sim);
        
    for i = 1:length(seg_B)
        xy = seg_B{i};
        plot(xy(:, 1), xy(:, 2), '--');
    end
end