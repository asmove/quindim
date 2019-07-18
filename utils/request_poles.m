function poles = request_poles(delta)
    is_valid = true;
    while(is_valid)
        msg = sprintf('Provide %d poles (necessarily lesser than 0)', delta);
        poles = input(msg);

        if(length(poles) ~= delta)
            warning('prog:input', 'Provide %d poles!', delta);
            is_valid = false;
        else
            break;
        end
    end
    poles
end