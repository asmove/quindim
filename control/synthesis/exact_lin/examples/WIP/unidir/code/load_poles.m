% Unitary matrices
poles_ = {};
deltas = reldeg_struct.deltas;

for i = 1:length(deltas)
    deltas(i) = deltas(i) + 1;
end

n_delta = length(deltas);

for i = 1:n_delta
    delta_i = reldeg_struct.deltas(i);
    
    pole_0 = -5;
    poles__ = [];
    for i = 1:delta_i
        pole_0 = pole_0 + 1;
        poles__(end + 1) = pole_0;
    end
    
    poles_{end + 1} = poles__;
end
