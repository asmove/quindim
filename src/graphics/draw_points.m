function draw_points(sys, sim_)
    n = length(sim_.points);
    
    for i = 1:n
       coords = sim_.points{i};
       marker = sys.points{i}.marker;
       color = sys.points{i}.color;
       
       % Principal dots
       plot(coords(1), coords(2), strcat(color, marker))
       hold on;
    end
    
    hold off
end