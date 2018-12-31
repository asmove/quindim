function [RF, RM] = result_excitations(excitations, cardinality)
        % Excitations
        momenta = excitations.momenta;
        forces = excitations.forces;
        
        RM = zeros(cardinality, 1);
        RF = zeros(cardinality, 1);
        for i = 1:length(momenta.entities)
            RM = RM + momenta.entities{i};
        end

        for i = 1:length(forces.entities)
            F = forces.entities{i};
            P = forces.applications{i};
            
            RM = RM + skew(F)*P;
            RF = RF + F;
        end
end