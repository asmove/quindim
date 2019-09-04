classdef my_waitbar
    properties
        time_mask = '%3.0f %% - %.1f [%%/s] [%s - %s]';
        msg = '';
        name = '';
        
        % Simulation time
        t_sim = 0;
        t_real = 0;
        
        hfig = [];
        
        % Real time
        t_curr_str = '';
        t_end_str = '';
        
        % Real time
        t_real_vec = [];
        
        % Real time
        tf = 0;
        tf_real_vec = [];
                
        speed = 0;
        speed_vec = [];
        
        wb = [];        
        
        previous_t = 0;
    end
    
    methods
        function obj = set.t_sim(obj, num)
            obj.t_sim = num;
        end
        
        function obj = set.t_real(obj, num)
            obj.t_real = num;
        end
        
        function obj = set.t_curr_str(obj, num)
            obj.t_curr_str = num;
        end
        
        function obj = set.t_real_vec(obj, arr)
            obj.t_real_vec = arr;
        end
        
        function obj = set.speed(obj, num)
            obj.speed = num;
        end
    
        function obj = set.speed_vec(obj, num)
            obj.speed_vec = num;
        end
        
        function obj = my_waitbar(name)
            obj.name = name;
            
            obj.t_curr_str = datestr(seconds(0), 'HH:MM:SS');
            obj.t_end_str = datestr(seconds(0), 'HH:MM:SS');
            
            obj.wb = obj.show(0);
            
            text_props = findall(obj.wb, 'type', 'text');
            set(text_props, 'Interpreter', 'none');
            
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
        
        function wb = show(obj, perc)
            obj.msg = sprintf(obj.time_mask, perc, obj.speed, ...
                              obj.t_curr_str, obj.t_end_str);
            wb = waitbar(0, obj.msg,  'Name', obj.name, ... 
                         'CreateCancelBtn', ...
                         'setappdata(gcbf,''canceling'',1)');
            
            wb_texts = findall(obj.wb, 'type', 'text');
            set(wb_texts, 'Interpreter', 'none');
        end
        
        function obj = update_waitbar(obj, t, tf)
            
            dt = toc(obj.previous_t);
            
            obj.tf = tf;
            obj.t_sim = t;
            
            % Variable updates - Time, percentage, display current time, 
            % display end time, average speed
            obj.t_real = obj.t_real + dt;
            
            perc = 100*t/tf;
            
            obj.t_curr_str = datestr(seconds(obj.t_real), 'HH:MM:SS');

            if((perc < eps))
                t_f = 0;
                obj.speed = 0;
                
                obj.t_end_str = datestr(seconds(t_f), 'HH:MM:SS');
                obj.msg = sprintf(obj.time_mask, perc, ...
                              obj.speed, obj.t_curr_str, obj.t_end_str);
            
            else                
                obj.speed = perc/obj.t_real;
                t_f = 100/obj.speed;
                
                obj.t_end_str = datestr(seconds(t_f), 'HH:MM:SS');
                obj.msg = sprintf(obj.time_mask, perc, obj.speed, ...
                                  obj.t_curr_str, obj.t_end_str); 
            end
            
           
            obj.t_real_vec = [obj.t_real_vec, obj.t_real];    
            obj.speed_vec = [obj.speed_vec; obj.speed];
            
            obj.tf_real_vec = [obj.tf_real_vec, t_f];
            
            if(~isgraphics(obj.wb))
                obj.wb = obj.show('100');
            end
            
            waitbar(t/tf, obj.wb, obj.msg);
            
            obj.previous_t = tic;
        end
        
        function close_window(obj)
            h = obj.find_handle();
            
            assignin('base', 'tf_real_vec', obj.tf_real_vec);
            assignin('base', 't_real_vec', obj.t_real_vec);
            assignin('base', 'speed_vec', obj.speed_vec);
            
            % Erase waitbar
            tf = obj.tf_real_vec(end);
            fprintf('Elapsed time is %.6f seconds.\n', tf);
            
            delete(h);
        end
    end
end