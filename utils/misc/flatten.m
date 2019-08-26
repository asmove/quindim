function flat_mat = flatten(matrix)
    flat_mat = reshape(matrix, [1, numel(matrix)]);
end