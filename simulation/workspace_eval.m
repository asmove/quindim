function [work_points, sing_points] = workspace_eval(mechanism)
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);
    
    % Small values for iteration initialization
    deps = 1e-1;
    dborder = 0.5;
    L0 = 0.5;
    
    q0_circ = zeros(1, n_circ);
    
    % Dimension of search
    prev_num_points = n_bullet^n_bullet;

    % Initial workspace 'volume'
    quad = generate_quadrature(n_bullet, L0, deps);
    [work_points, ~] = eval_quadrature(mechanism, quad);
    
    [~, n_work] = size(work_points);
    
    i = 1;
    work_has_grown = true;
    while(work_has_grown)
        quad = generate_quadrature(n_bullet, L0 + i*deps, deps);
        [work_points, sing_points] = eval_quadrature(mechanism, quad);
        
        [~, n_work_] = size(work_points);
        
        work_has_grown = n_work_ > n_work;
    end
end