wb = my_waitbar('');

% Time [s]
scaler = 10;
dt = scaler*(tspan(2) - tspan(1));
t = 0:dt:tf;

n = length(t);
n_q = length(sys.kin.q);

sims = {};
for i = 1:n
    sol_i = interp1(tspan, sol, t(i));
    sims{i} = gen_sim(sys, sol_i', [0; 0; 0; 0], n_q); 
    wb.update_waitbar(i, n);
end

wb.close_window();

x_min = -10;
x_max = 10;

y_min = -20;
y_max = 20;

hfig = my_figure();

for i = 1:n
    sim = sims{i};
    draw_2Dcar(hfig, sys, sim);
    
    axis equal;
    axis([x_min x_max y_min y_max]);
        
    pause(dt);
    clf(hfig, 'reset');

end
