function inertia_tensor = inertia_tensor(label)
% Creates a symmetric inertia tensor
% Input: Label [int]: Label to the tensor
% Ourpur: inertia_tensor [matrix]: symbolic tensor

    name = sprintf('I%d_', label);
    inertia_tensor = sym([name, '%d%d'], [3, 3]);
    
    for m = 1:3
        for n = m:3
            inertia_tensor(m, n) = inertia_tensor(n, m);
        end
    end

end