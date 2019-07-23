function damper_info = build_damper(b, head, tail)
    if(nargin == 0)
        damper_info.b = 0;
        damper_info.head = [0; 0; 0];
        damper_info.tail = [0; 0; 0];
    elseif(nargin == 3)
        damper_info.b = b;
        damper_info.head = head;
        damper_info.tail = tail;
    else
        error('Provide either none or all parameters!');
    end
end