points = [];
is_wss = [];
is_sings = [];

xs = -0.4:0.01:0.4;
ys = -0.4:0.01:0.4;
alphas = -3:0.1:3;

f = waitbar(0,'1','Name','Calculating trajectory...',...
            'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f, 'canceling', 0);

i = 1;
m = length(xs)*length(ys)*length(alphas);

t = datetime('now','Format','HH:mm:ss.SSS');
t_ = datetime('now','Format','HH:mm:ss.SSS');
t = 0*(t_ - t);

dts = [];

for x = xs
   for y = ys
      for alpha = alphas
          % Check for clicked Cancel button
          if getappdata(f,'canceling')
              break;
          end
          
          t0 = datetime('now','Format','HH:mm:ss.SSS');
          q_bullet = [x; y; alpha];
          
          n = length(q_bullet);
          [q_circ_, is_ws] = q_circ(mechanism, zeros(n, 1), q_bullet);
          is_wss = [is_wss; is_ws];
          
          q = [q_bullet; q_circ_];
          is_sing = is_singularity(mechanism, q);
          
          is_sings = [is_sings; is_sing];
          points = [points; q_bullet.'];
          
          t1 = datetime('now','Format','HH:mm:ss.SSS');
          dt = t1 - t0;
          
          dts = [dts; dt];
          t = t + dt;
          
          dt_m = sum(dts)/length(dts);
          std(dts)
          
          [hi, mi, si] = hms(t);
          [hm, mm, sm] = hms(m*dt_m);
          si = round(si);
          sm = round(sm);
          
          % Update waitbar and message
          lod_msg = sprintf('%3d:%2d:%2.1d - %3d:%2d:%2.1d', ...
                            hi, mi, si, hm, mm, sm);
          
          waitbar(i/m, f, lod_msg); 
          i = i + 1;
      end
   end
end

ps_ws = [];
for i = q:length(is_wss)
    if(is_wss(i))
        ps_ws = [ps_ws; points(i, :)];
    end
end

figure()
plot3(ps_ws(:, 1), ps_ws(:, 2), ps_ws(:, 3), 'kx');

ps_s = [];
for i = q:length(is_sings)
    if(is_sings(i))
        ps_s = [ps_s; points(i, :)];
    end
end

figure()
plot3(ps_s(:, 1), ps_s(:, 2), ps_s(:, 3), 'mx');
