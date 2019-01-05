function draw_points(mechanism, sim)
    n = length(sim.points);

    for i = 1:n
       coords = sim.points{i};
       marker = mechanism.points{i}.marker;
       color = mechanism.points{i}.color;
       
       % Principal dots
       plot(coords(1), coords(2), strcat(color, marker))
       hold on;
    end
    
    hold off
end