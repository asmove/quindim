% Time [s]
tf = tspan(end);
dt = max(tspan(2:end) - tspan(1:end-1));
t = (0:dt:tf)';

n = length(tspan);
n_q = length(sys.kin.q);
n_u = length(sys.descrip.u);

RENDERIZE = false;

wb = my_waitbar('');
sims = {};
sols = [];

if(~RENDERIZE)
    t = tspan;
end

for i = 1:length(t)
    sol_i = interp1(tspan, x, t(i));
    sols = [sols; sol_i];

    sims{i} = gen_sim(sys, sol_i', zeros([n_u, 1]), n_q); 
    wb.update_waitbar(i, n);
end

wb.close_window();

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

scaler = 1.5;
offset = scaler*sys.descrip.model_params(2);

x_min = -offset + min(x(:, 1));
x_max = offset + max(x(:, 1));

y_min = -offset + min(x(:, 2));
y_max = offset + max(x(:, 2));

draw_robot_func = @(hfig, sys, sim) ...
                  draw_omni_robot(hfig, sys, sim);

n_t = length(tspan);

% Start figure simulation
hfig = my_figure();
wb = my_waitbar('');

handles = [];
for i = 1:n_t
    sim = sims{i};
    
    hfig.Name = [char(t(i)), ' s'];
    hold on
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

save_video(handles, 'omni.avi', 1/dt);

