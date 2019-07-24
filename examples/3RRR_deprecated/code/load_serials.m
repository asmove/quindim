function serials = load_serials(params_type)
    serials = {};
    
    for i = 1:3
        % Serial parameters
        params_fname = sprintf('load_%s_serial_params', params_type);
        serial_i = feval(params_fname, i);
        
        % Generalized variables
        serial_i.generalized = load_generalized_serial(i);
                
        % Transformations
        serial_i = transformations_serial(serial_i);       
        
        serials{end+1} = serial_i;
    end
end