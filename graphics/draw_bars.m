function draw_bars(sys, sim)
    n = length(mechanism.bars);
    
    q = [v.eqdyn.q_bullet; sys.eqdyn.q_circ];
    
    for i = 1:n
       % Main segments

       % Bars characteristics
       width = sys.bars{i}.width;
       color = sys.bars{i}.color;

       % Bar head and tail
       bar_begin = sys.bars{i}.begin;
       bar_end = sys.bars{i}.end;
       
       P0 = [bar_begin(1), bar_begin(2)];
       Pf = [bar_end(1), bar_end(2)];
       
       P0 = subs(P0, q, sim.q);
       Pf = subs(Pf, q, sim.q);
       
       % Bar drawing
       line([P0(1), Pf(1)], ...
            [P0(2), Pf(2)], 'LineWidth', width, 'color', color);
    end   
end