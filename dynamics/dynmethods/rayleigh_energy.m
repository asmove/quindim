function F = rayleigh_energy(body)
    for damper = body.dampers    
        curr = damper.head;
        prev = damper.tail;
        b = damper.b;

        F = (1/2)*b*(curr - prev).'*(curr - prev);
    end
    
% % DOES NOT ERASE - Linear/angular friction handled
%     if body.fric_is_linear
%         if(isfield(body.previous_body, 'v_cg'))
%             F = (1/2)*b*(body.v_cg - body.previous_body.v_cg).'*...
%                         (body.v_cg - body.previous_body.v_cg);    
%         else
%             F = (1/2)*body.b*body.v_cg.'*body.v_cg;
%         end
%     else
%         if(isfield(body.previous_body, 'omega'))
%             delta_omega = body.omega - body.previous_body.omega;
%             F = (1/2)*body.b*delta_omega.'*delta_omega;
%         else
%             F = (1/2)*body.b*body.omega.'*body.omega;            
%         end
%     end
end