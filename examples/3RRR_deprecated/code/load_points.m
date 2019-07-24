function mechanism = load_points(mechanism)
    mechanism.endeffector.Be = {};

    mechanism.points = {};
    
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
    end
end
