function [work_points, sing_points] = eval_quadrature(mechanism, ...
                                                      quadrature) 
    [nlines, ncols] = size(quadrature);
    n_circ = length(mechanism.eqdyn.q_circ);
    q_circ_prev = zeros(n_circ, 1);
    
    f = waitbar(0,'1','Name','Updating simulation data...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');    
    
    work_points = [];
    sing_points = [];
    for i = 1:ncols
        point = quadrature(:, i);
        [q_circ_, is_workspace] = q_circ(mechanism, q_circ_prev, point);
        q = [point; q_circ_];
        
        if(is_workspace)
            work_points = [work_points; point.'];
            is_sing = is_singularity(mechanism, q);

            if(is_sing)
                points_sing = [work_points; point.'];
            end
        end
        
        n_bullet = length(q) - n_circ;
        q_circ_prev = q(n_bullet+1:end);

         % Check for clicked Cancel button
        if getappdata(f,'canceling')
            break
        end
        
        % Update waitbar and message
        waitbar(i/ncols,f,sprintf('%d/%d', i, ncols))
    end
    
    delete(f);
end