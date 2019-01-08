function simulate(sims, mechanism, dt, ax, fname)
    n = length(sims);
    
    % Draw mechanism movement
    for i = 1:n
         clf;
         draw_mechanism(mechanism, sims{i});
         axis(ax);
         frames(i) = getframe(gcf);
         pause(dt);
    end
    
    make_video(fname, frames, dt);
end