
sol = [q, p];

wb = my_waitbar('');

n = length(tspan);

sims = {};
for i = 1:length(simOut.tout)
    q = simOut.coordinates.signals.values;
    t_i = simOut.tout(i);
    
    sims{i} = struct('t', t_i, 'q', q(i, :));
    
    wb.update_waitbar(i, n);
end

hfig = my_figure();

x_min = -10;
x_max = 10;

y_min = -10;
y_max = 10;

axs_vals = [x_min x_max y_min y_max];

for i = 1:length(simOut.tout)
    sim_ = sims{i};
    draw_2Dcar(hfig, sys, sim_);
    
    axis equal;
    axis(axs_vals);
    
    pause(dt);
    clf(hfig, 'reset');
end
