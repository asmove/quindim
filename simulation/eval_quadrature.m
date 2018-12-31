function [work_points, sing_points] = eval_quadrature(mechanism, ...
                                                      quadrature, n_circ) 
    [nlines, ncols] = size(quadrature);
    
    q_circ_prev = zeros(1, n_circ);
    
    work_points = [];
    sing_points = [];
    for i = 1:ncols
        point = quadrature(:, i);
        [q, ~, ~, ~, is_workspace] = q_qp_p(mechanism, ...
                                         q_circ_prev, ... 
                                         point.', ...
                                         zeros(1, nlines), ...
                                         zeros(1, nlines));
        
        if(is_workspace)
            work_points = [work_points, point];
            is_sing = is_singularity(mechanism, q);

            if(is_sing)
                points_sing = [points_sing, point];
            end
        end
        
        n_bullet = length(q) - n_circ;
        q_circ_prev = q(n_bullet+1:end);

    end
end