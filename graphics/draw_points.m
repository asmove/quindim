function draw_points(sim)   
    n = length(sim.points);

    for i = 1:n
       coords = sim.points{i}.coords;
       marker = sim.points{i}.marker;
       color = sim.points{i}.color;
       
       % Principal dots
       plot(coords(1), coords(2), strcat(color, marker))
       hold on;
    end
    
    hold off
end