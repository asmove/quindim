function draw_bars(mechanism, sim)
    n = length(mechanism.bars);
    
    q = [mechanism.eqdyn.q_bullet; mechanism.eqdyn.q_circ];
    
    for i = 1:n
       % Main segments
       width = mechanism.bars{i}.width;
       color = mechanism.bars{i}.color;
       bar_begin = mechanism.bars{i}.begin;
       bar_end = mechanism.bars{i}.end;
       
       P0 = [bar_begin(1), bar_begin(2)];
       Pf = [bar_end(1), bar_end(2)];
       
       P0 = subs(P0, q, sim.q);
       Pf = subs(Pf, q, sim.q);
       
       line([P0(1), Pf(1)], ...
            [P0(2), Pf(2)], 'LineWidth', width, 'color', color);
    end   
end