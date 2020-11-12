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

fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

x_min = -10;
x_max = 10;

y_min = -5;
y_max = 20;

hfig = my_figure();
wb = my_waitbar('');

handles = [];
for i = 1:n    
    sim = sims{i};
    draw_2Dcar(hfig, sys, sim);    
    axis equal;
    axis([x_min x_max y_min y_max]);
        
    pause(dt);
    clf(hfig, 'reset');
    
    % handles = [handles; getframe(gcf)];
    % wb.update_waitbar(i, n);
end

wb.close_window();

% create the video writer with 1 fps
writerObj = VideoWriter('car.avi');
writerObj.FrameRate = 1/dt;

% set the seconds per image
% open the video writer
open(writerObj);

% write the frames to the video
for i=1:length(handles)
    % convert the image to a frame
    frame = handles(i);    
    writeVideo(writerObj, handles(i));
end

% close the writer object
close(writerObj);