function inv_ = invfunc(expr, x)
    n = length(expr);
    zs = sym('z', [n, 1], 'real');
    
    % Inverse transformations
    transfs_1 = solve(zs == expr, x, 'ReturnConditions', true);

    transfs_1 = rmfield(transfs_1, 'parameters');
    transfs_1 = rmfield(transfs_1, 'conditions');

    inv_ = sym([]);
    fnames_t = fieldnames(transfs_1);

    for i = 1:length(fnames_t)
        inv_(end+1) = getfield(transfs_1, fnames_t{i});
    end

    inv_ = inv_.';
end