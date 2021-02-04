function [F, Tau] = result_excitations(excitations, n_g)
    F = zeros([n_g, 1]);
    Tau = zeros([n_g, 1]);
    
    forces = excitations.forces.entities;
    torques = excitations.momenta.entities;
    
    symbs_F = excitations.forces.symbs;
    symbs_T = excitations.momenta.symbs;
    
    n_f = length(forces);
    n_T = length(torques);
    
    if(~isempty(symbs_F))
        for i = 1:n_f
            F = F + forces;
        end
    else
        F = zeros([n_g, 1]);
    end
    
    if(~isempty(symbs_T))
        for i = 1:n_T
            Tau = Tau + torques{i};
        end
    else
        Tau = zeros([n_g, 1]);
    end
end