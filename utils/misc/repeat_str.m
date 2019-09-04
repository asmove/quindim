function repeated_cell = repeat_str(str_, num_repeat)
    
    repeated_cell = {};
    for i = 1:num_repeat
        repeated_cell{end+1} = str_;
    end
end