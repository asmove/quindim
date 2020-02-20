function val = hyst_sign(actual, phi_min, phi_max)
    persistent past;
    
    if(isempty(past))
        past = actual;
    end
    
    val = terop((past > phi_min) && (actual < phi_min), -1, ...
          terop((past < phi_max) && (actual > phi_max), 1, ...
          terop((past < phi_min) && (actual < phi_min), -1, ...
          terop((past > phi_max) && (actual > phi_max), 1, past))));
    past = val;
end