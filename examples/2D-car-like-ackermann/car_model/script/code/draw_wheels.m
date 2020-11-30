function [] = draw_wheels(hfig, wheels)
    draw_wheel(hfig, wheels(1));
    draw_wheel(hfig, wheels(2));
    draw_wheel(hfig, wheels(3));
    draw_wheel(hfig, wheels(4));
end

function [] = draw_wheel(hfig, wheel)
    set(0, 'CurrentFigure', hfig)
    
    orientation = wheel.orientation;
    R = wheel.radius;
    center = wheel.center;
    A = wheel.A;
    B = wheel.B;
    
    plot([A(1); B(1)], ...
         [A(2); B(2)], ...
         'k', 'LineWidth', 10);
    
    hold on;
    plot(center(1), center(2), 'ro');
    hold on;
end