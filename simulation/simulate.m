function simulate(sims, mechanism, ax, fname)
    n = length(sims);
       
    % Draw mechanism movement
    for i = 1:n
         draw_mechanism(mechanism, sims{i});
         
         dt = sims{i}.curr_t - sims{i}.prev_t;
         axis(ax);
         
         pause(dt);
         
         frames(i) = getframe(gcf);
    end
    
    make_video(fname, frames, dt);
end