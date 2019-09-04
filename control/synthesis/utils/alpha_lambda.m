function [alpha_a, alpha_u, ...
          lambda_a, lambda_u] = alpha_lambda(poles, m, n)
    % Convergence on the manifold
    C = eig_to_matrix(poles);

    % Lambda and alpha parameters
    CI = [C', eye(size(C))];
    null_CI = null(CI);

    alpha_n = null_CI(1:n, 1:m).';
    lambda_n = null_CI(n+1:2*n, 1:m).';
    
    alpha_a = alpha_n(1:m, 1:m);
    alpha_u = alpha_n(1:m, m+1:end);
    
    lambda_a = lambda_n(1:m, 1:m);
    lambda_u = lambda_n(1:m, m+1:end);
end