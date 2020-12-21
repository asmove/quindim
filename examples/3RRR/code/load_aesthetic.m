function mechanism = load_aesthetic(mechanism)
    mechanism.endeffector.Be = {};

    mechanism.points = {};
    mechanism.bars = {};
    
    for i = 1:3
        serial = mechanism.serials{i};
        endeffector = mechanism.endeffector;
        
        L1 = serial.bodies{1}.params.L1;
        L2 = serial.bodies{2}.params.L2;
        Le = getfield(endeffector.params, sprintf('Le%d', i));
        
        TN0 = serial.base.T;
        TN1 = serial.bodies{1}.T;
        TN2 = serial.bodies{2}.T;
        TNe = endeffector.T{i+1};
               
        Oi = point(TN0, [0; 0; 0]);
        Ai = point(TN1, [L1; 0; 0]);
        Bi = point(TNe, [Le; 0; 0]);
        
        mechanism.serials{i}.O = Oi;
        mechanism.serials{i}.A = Ai;
        mechanism.endeffector.B{i} = Bi;
        
        markers = ['o', 'x', '*'];
        colors = ['m', 'k', 'b'];
        
        % Motor point
        O.coords = Oi; 
        O.marker = markers(1);
        O.color = colors(1);
        
        % Elbow point
        A.coords = Ai; 
        A.marker = markers(2);
        A.color = colors(2);
        
        % End-effector
        B.coords = Bi; 
        B.marker = markers(3);
        B.color = colors(3);
        
        mechanism.points{end+1} = O; 
        mechanism.points{end+1} = A;
        mechanism.points{end+1} = B;
        
        scaler = 10;
        
        % Motor bar
        bar1.begin = Oi;
        bar1.end = Ai;
        
        color1 = 'k';
        bar1.color = 'k';
        
        width1 = scaler*mechanism.serials{i}.bodies{1}.params.W1;
        bar1.width = width1;
        
        % End-effector bar
        bar2.begin = Ai;
        bar2.end = Bi;
        
        color2 = 'k';
        bar2.color = color2;
        
        width2 = scaler*mechanism.serials{i}.bodies{2}.params.W2;
        bar2.width = width2;
        
        mechanism.bars{end+1} = bar1; 
        mechanism.bars{end+1} = bar2;
        
        mechanism.draw_endeffector = @(sim_, mec) draw_endeffector(sim_, mec);
    end
    
    mechanism.draw_bodies = @(sim_, mec) draw_bodies(sim_, mechanism);
    mechanism.draw_generalized = @(sim_) draw_generalized(sim_);
    mechanism.draw_trajectory = @(sims) draw_trajectory(sims);
end

function draw_bodies(sim_, sys)
    vals = sim_.q;
    
    symbs = sys.q;
    
    for i = 1:length(sys.bars)
        A = sys.bars{i}.begin;
        B = sys.bars{i}.end;
        width = sys.bars{i}.width;
        color = sys.bars{i}.color;
        
        points = [A, B]';
        
        idx_s = find_elems(symvar(points), symbs);
        
        symbs_i = symbs(idx_s);
        vals_i = vals(idx_s);
        
        AB = double(subs(points, symbs_i, vals_i));
        AB = AB(:, 1:2);
        
        plot(AB(:, 1), AB(:, 2), ...
             'Linewidth', width, 'Color', color);
         
         hold on;
    end
end

function draw_bar(sims)
    n = length(sim_s);
    
    for i = 1:n-1
        x = [sims{i}.q(1); sims{i+1}.q(1)];
        y = [sims{i}.q(2); sims{i+1}.q(2)];
        plot(x, y)
        hold on
    end
end

function draw_trajectory(sims)
    n = length(sims);
    
    for i = 1:n-1
        x = [sims{i}.q(1); sims{i+1}.q(1)];
        y = [sims{i}.q(2); sims{i+1}.q(2)];
        plot(x, y)
        hold on
    end
end

function draw_generalized(sim_)
    plot(sim_.q(1), sim_.q(2), '*');

    hold on;
    
    dvec = 0.1;
    alpha = sim_.q(3);
    u = dvec*cos(alpha);
    v = dvec*sin(alpha);
    
    quiver(sim_.q(1), sim_.q(2), u, v);
end

function draw_endeffector(sim_, mechanism)
    points = double([sim_.q(1), sim_.q(2)]);
    viscircles(points, mechanism.endeffector.params.Le1); 
end