wb = my_waitbar('');

tspan = simOut.tout;

% Time [s]
scaler = 10;
dt = scaler*(tspan(2) - tspan(1));
t = 0:dt:tf;

n = length(t);
n_q = length(sys.kin.q);

sims = {};
for i = 1:length(tspan)
    sol_i = interp1(tspan, x, t(i));
    sims{i} = gen_sim(sys, sol_i', [0; 0; 0; 0], n_q); 
    wb.update_waitbar(i, n);
end

wb.close_window();

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

x_min = min(x(:, 1));
x_max = max(x(:, 1));

y_min = min(x(:, 2));
y_max = max(x(:, 2));

% Start figure simulation
hfig = my_figure();
wb = my_waitbar('');

handles = [];
for i = 1:n    
    sim = sims{i};
    draw_2Dcar(hfig, sys, sim);    
    hold on
    plot(sol(:, 1), sol(:, 2), '--')
    
    axis equal;
    axis([x_min x_max y_min y_max]);
    
    handles = [handles; getframe(gcf)];
    
    pause(dt);
    clf(hfig, 'reset');
    
    wb.update_waitbar(i, n);
end

save_video(handles, 'car.avi', 1/dt);
