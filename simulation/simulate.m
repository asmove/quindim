function simulate(sims, sys, dt, axs, path)
    n_s = length(sims);
    
    hfig = my_figure();
    
    % Start figure simulation
    handles = [];
    for i = 1:n_s
        sim = sims{i};
        draw_system(sys, sim);
        
        hold on;
        sys.draw_trajectory(sims);
        
        handles = [handles; getframe(gcf)];
        
        axis(axs);
        pause(dt);
        clf(hfig, 'reset');
        
        pause(dt);
    end
    
    save_video(handles, path, 1/dt);
end