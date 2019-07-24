function  traj = trajectory(type, props)
    if(strcmp(type, 'rect'))
        traj = rect(props);
    elseif(strcmp(type, 'circ'))
        traj = circ(props);
    else
        error('Just circle and rectangle are implemented');
    end
    
end
