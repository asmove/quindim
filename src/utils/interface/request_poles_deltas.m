function poles = request_poles_deltas(deltas)
% Description: Request the poles according to delta vector
% Input:
%     - [vector]: Relative degrees of each ooutput
% Output:
%     - [cell]: poles for each output on exact linearization
    
    poles = {};
    for delta = deltas
        poles{end+1} = request_poles(delta);
    end
end

