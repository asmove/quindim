function [RF, RT] = result_excitations()
        % Excitations
        momenta = excitations.momenta;
        forces = excitations.forces;
        
        RT = [];
        RF = [];
        for i = 1:length(momenta)
            RM = RM + momenta{i};
        end

        for i = 1:length(forces)
            F = forces{i}.entity;
            P = forces{i}.application;
            
            RM = RM + skew(F)*P;
            RF = RF + F;
        end
end