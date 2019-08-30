classdef my_waitbar
    properties
        time_mask = '%3.0f %% - %.1f [%%/s] [%s - %s]';
        msg = '';
        name = '';
        
        % Simulation time
        t_sim = 0;
        t_real = 0;
        
        % Real time
        t_curr_str = '';
        t_end_str = '';
        
        % Real time
        t_real_vec = [];
        
        % Real time
        tf = 0;
        tf_real_vec = [];
        
        speed = 0;
        speed_acc = [];
        
        wb = [];        
        
        previous_t = 0;
    end
    
    methods
        function obj = my_waitbar(name)
            obj.name = name;
            
            obj.t_curr_str = datestr(seconds(0), 'HH:MM:SS');
            obj.t_end_str = datestr(seconds(0), 'HH:MM:SS');
            obj.show(0);
        
            obj.previous_t = tic;
        end
        
        function h = find_handle(obj)
            h = findall(0,'type','figure','tag','TMWWaitbar');
        end
        
        function delete(obj)
            % obj is always scalar
            F = findall(0,'type','figure','tag','TMWWaitbar');
            delete(F);
        end
        
        function show(obj, perc)
            obj.msg = sprintf(obj.time_mask, perc, obj.speed, ...
                              obj.t_curr_str, obj.t_end_str);
            obj.wb = waitbar(0, obj.msg,  'Name', obj.name, ... 
                             'CreateCancelBtn', ...
                             'setappdata(gcbf,''canceling'',1)');
        
            wb_texts = findall(obj.wb, 'type', 'text');
            set(wb_texts, 'Interpreter', 'none');
        end
        
        function update_waitbar(obj, t, tf)
            dt = toc(obj.previous_t);
            
            obj.tf = tf;
            obj.t_sim = t;
            
            % Variable updates - Time, percentage, display current time, 
            % display end time, average speed
            obj.t_real = obj.t_real + dt;
            
            perc = 100*t/tf;
            obj.t_curr_str = datestr(seconds(obj.t_real), 'HH:MM:SS');
            obj.speed = perc/obj.t_real;

            obj.t_real_vec = [obj.t_real_vec, obj.t_real];    
            obj.speed_acc = [obj.speed_acc; obj.speed];

            if((perc < eps)||(obj.speed < eps))
                t_f = 0;

                obj.t_end_str = datestr(seconds(tf), 'HH:MM:SS');
                msg = sprintf(obj.time_mask, perc, ...
                              obj.speed, obj.t_curr_str, obj.t_end_str);
            else
                t_f = 100/obj.speed;

                % Smooth speed
                horizon = 5;
                if(length(obj.tf_real_vec) < horizon + 1)
                    tf_ = t_f;
                else
                    tf_ = obj.tf_real_vec(end-horizon:end);
                end

                obj.t_end_str = datestr(seconds(mean(tf_)), 'HH:MM:SS');
                msg = sprintf(obj.time_mask, perc, obj.speed, ...
                              obj.t_curr_str, obj.t_end_str); 
            end

            obj.tf_real_vec = [obj.tf_real_vec, t_f];
            
            if(~isgraphics(obj.wb))
                obj.show()
            end
            
            h = obj.find_handle();
            h = h(1);
            waitbar(t/tf, h, msg);
            
            obj.previous_t = tic;
        end
        
        function close_window(obj)
            h = obj.find_handle();
            delete(h);
        end
    end
end