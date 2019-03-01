function S = catstruct(S, T)
    f = fieldnames(T);
    for i = 1:length(f)
        S.(f{i}) = T.(f{i});
    end
end