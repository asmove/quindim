function poles = request_poles(delta)
% Description: Request the poles according to delta vector
% Input:
%     - [vector]: Relative degrees of each ooutput
% Output:
%     - [cell]: poles for each output on exact linearization

    is_valid = true;
    while(is_valid)
        msg = sprintf('Provide %d poles (between brackets and separated by commas)', delta);
        poles = input(msg);

        if(length(poles) ~= delta)
            warning('prog:input', 'Provide %d poles!', delta);
        else
            is_valid = false;
        end
    end
end