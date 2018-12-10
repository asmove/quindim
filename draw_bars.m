function draw_bars(sim)
    n = length(sim.bars);

    for i = 1:n
       % Main segments
       width = sim.bars{i}.width;
       color = sim.bars{i}.color;
       bar_begin = sim.bars{i}.begin;
       bar_end = sim.bars{i}.end;
       
       P0 = [, bar_begin(2)];
       Pf = [bar_end(1), bar_end(2)];
              
       line([bar_begin(1), bar_end(1)], ...
            [bar_begin(2), bar_end(2)], 'LineWidth', width, 'color', color);
    end   
end