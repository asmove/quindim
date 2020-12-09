function draw_chassi(hfig, points)
    set(0, 'CurrentFigure', hfig);
    fill(points(:, 1), points(:, 2), 'w')
    axis square;
end
