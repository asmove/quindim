function spring_info = build_spring(k, v_head, v_tail)
    if(nargin == 0)
        spring_info.k = 0;
        spring_info.head = [0; 0; 0];
        spring_info.tail = [0; 0; 0];
    elseif(nargin == 3)
        if(length(v_head) ~= 3 || length(v_head) ~= 3)
           error('The program works with 3D body systems!'); 
        end
        
        spring_info.k = k;
        spring_info.head = v_head;
        spring_info.tail = v_tail;
    else
        error('Provide either none or all parameters!');
    end
end