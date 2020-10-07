function dq  = df(t, x, model, aux_syms, aux_vals)
    
    symbs = aux_syms;
    
    params = [];
    for i = 1:length(aux_syms)
        aux_vals_i = aux_vals{i};
        params = [params; aux_vals_i(t)];
    end

    dq = vpa(subs(model.plant, ...
              [model.q; model.p; model.symbs.'; symbs], ...
              [x; model.model_params.'; params]));
end