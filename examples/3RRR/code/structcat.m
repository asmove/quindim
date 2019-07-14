function A = structcat(A, B)
    f = fieldnames(B);
    for i = 1:length(f)
        A.(f{i}) = B.(f{i});
    end
end