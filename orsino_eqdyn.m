function orsino_eqdyn(sys)
    
    % Number of a subsystem
    serials_names = fieldnames(sys.serial_sytems);
    num_subsystems = length(serials_names);

    serial_sytems = sys.serial_sytems;
        
    % Body dynamic equation
    for i = 1:num_subsystems
        bodies_names = fieldnames(serial_sytems{i});
        n_bodies = length(bodies_names);
        
        serial_system = serial_sytems{i};
        
        % Equations of each body of the subsystem
        for j = 1:n_bodies
            % Respective body
            body = serial_system.bodies{j};
            
            % Lagrange required structure
            body_sys.bodies = body;
            
            [~, body_sys_] = lagrange_eqdyn(body_sys);
            body_sys = body_sys_;
        end
        
        
    end
end