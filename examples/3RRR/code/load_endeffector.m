function endeffector = load_endeffector(params_type)
    endeffector = struct();

    % Parameters
    params_fname = sprintf('load_%s_endeffector_params', params_type);
    endeffector.params = feval(params_fname);
    
    % Gravity
    if strcmp(params_type, 'sym')
        endeffector.gravity = [0; 0; -sym('g')];
    else
        endeffector.gravity = [0; 0; -9.8];        
    end
    
    % Generalized variables
    endeffector.generalized = load_generalized_endeffector();
    
    % External excitations
    endeffector.excitations.forces.symbs = {};
    endeffector.excitations.momenta.symbs = {};
    
    endeffector.excitations.forces.entities = {};
    endeffector.excitations.forces.applications = {};
    endeffector.excitations.momenta.entities = {};
    
    % End-effector
    endeffector.T = transformations_endeffector(endeffector);
end