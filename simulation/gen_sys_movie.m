function gen_sys_movie(sims, sys, dt, ax, fname)
    n = length(sims);
    
    % Draw mechanism movement
    for i = 1:n
         clf;
         axis(ax);
         draw_system(sys, sims{i});
         frames(i) = getframe(gcf);
         pause(dt);
    end
    
    make_video(fname, frames, dt);
end