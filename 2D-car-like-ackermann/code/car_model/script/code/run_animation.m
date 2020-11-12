
% wb = my_waitbar('');
% 
% n = length(t);
% 
% sims = {};
% for i = 1:n
%     sims{i} = gen_sim(sys, sol(i, :)', ...
%                       [0; 0; 0; 0], ...
%                       length(sys.kin.q)); 
%     
%     wb.update_waitbar(i, n);
% end

hfig = my_figure();

x_min = -10;
x_max = 10;

y_min = -10;
y_max = 10;


for i = 1:length(t)
    sim = sims{i};
    draw_2Dcar(hfig, sys, sim);
    
    axis equal;
    axis([x_min x_max y_min y_max]);
    
    pause(dt);
    clf(hfig, 'reset');
end
