function mechanism = load_bodies(mechanism)
    scaler = 10;
    
    mechanism.bodies = {};
    
    for i = 1:3
        Oi = mechanism.points{i+1}; 
        Ai = mechanism.points{i+2};
        Bi = mechanism.points{i+3};
        
        % Motor bar
        bar1.begin = Oi;
        bar1.end = Ai;
        bar1.color = 'k';
        bar1.width = scaler*mechanism.serials{i}.bodies{1}.params.W1;

        % End-effector bar
        bar2.begin = Ai;
        bar2.end = Bi;
        bar2.color = 'k';
        bar2.width = scaler*mechanism.serials{i}.bodies{2}.params.W2;

        mechanism.bodies{end+1} = bar1; 
        mechanism.bodies{end+1} = bar2;
    end
    
    mechanism.draw_bodies = @draw_bodies;
end

function draw_bodies(mechanism, sim, q)
    for body = mechanism.bodies 
        draw_body(body, sim, q);
    end
end

function draw_body(body, sim, q)
   % Bars characteristics
   width = body.width;
   color = body.color;

   % Bar head and tail
   bar_begin = body.begin;
   bar_end = body.end;

   P0 = [bar_begin.coords(1), bar_begin.coords(2)];
   Pf = [bar_end.coords(1), bar_end.coords(2)];

   P0 = subs(P0, q, sim.q);
   Pf = subs(Pf, q, sim.q);

   % Bar drawing
   x0 = [P0(1), Pf(1)];
   y0 = [P0(2), Pf(2)];
   
   line(x0, y0, 'LineWidth', width, 'color', color);
end

function draw_endeffector(sim, mechanism)
    x0 = double([sim.q(1), sim.q(2)]);
    R = mechanism.endeffector.params.Le1;
    
    viscircles(x0, R); 
end