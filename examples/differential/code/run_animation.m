tspan = simOut.tout;

% Time [s]
scaler = 10;

tf = tspan(end);
t = (0:dt:tf)';
dt = scaler*(tspan(2) - tspan(1));

n = length(tspan);
n_q = length(sys.kin.q);
n_u = length(sys.descrip.u);

dts = scaler*(tspan(2:end) - tspan(1:end-1));

wb = my_waitbar('');

sims = {};
sols = [];
for i = 1:length(tspan)
    sol_i = interp1(tspan, x, t(i));
    sols = [sols; sol_i];
    
    sims{i} = gen_sim(sys, sol_i', zeros([n_u, 1]), n_q); 
    wb.update_waitbar(i, n);
end

wb.close_window();

draw_robot_func = @(hfig, sys, sim) draw_diff_robot(hfig, sys, sim);

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

scaler_x = 4;
scaler_y = 4;

x_min = min(sols(:, 1));
x_max = scaler_x*L_n + max(sols(:, 1));

y_min = -scaler_y*w_n/2 + min(sols(:, 2));
y_max = scaler_y*w_n/2 + max(sols(:, 2));

% Start figure simulation
hfig = my_figure();
wb = my_waitbar('');

handles = [];
for i = 1:n    
    sim = sims{i};
    draw_robot_func(hfig, sys, sim);

    hold on
    plot(sols(:, 1), sols(:, 2), '--')
    
    axis equal;
    axis([x_min x_max y_min y_max]);
    
    handles = [handles; getframe(gcf)];
    
    pause(dt);
    clf(hfig, 'reset');
    
    wb.update_waitbar(i, n);
end

save_video(handles, 'car.avi', 1/dt);
