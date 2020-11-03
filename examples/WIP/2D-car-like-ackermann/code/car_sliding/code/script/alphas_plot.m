clear all
close all
clc

syms alpha_0 alpha_1;

alphas = [2*alpha_1 - 1, 1 - alpha_0 - alpha_1; ...
          -1 + alpha_0 + alpha_1, 2*alpha_1 - 1]/(1 - alpha_1);
f_alpha = det(alphas);

dalpha = 1e-2;
alpha_ = 0:dalpha:1-dalpha;

[alpha0, alpha1] = meshgrid(alpha_, alpha_);

wb = my_waitbar('Evaluating Zs');

n_alpha = length(alpha_);
Z = zeros(n_alpha, n_alpha);
for i = 1:length(alpha_)
    for j = 1:length(alpha_)
        Z(i, j) = subs(f_alpha, [alpha_0, alpha_1], ...
                                [alpha_(i), alpha_(j)]);
    
        wb.update_waitbar(j + (i-1)*n_alpha, n_alpha^2);
    end
end

hfig = my_figure();

surfc(alpha0, alpha1, Z);
titletxt = '';
title(titletxt, 'interpreter', 'latex', 'Fontsize', 15);
xlabel('$\alpha_1$', 'interpreter', 'latex', 'Fontsize', 15);
ylabel('$\alpha_0$', 'interpreter', 'latex', 'Fontsize', 15);
zlabel('$p(\alpha_0, \, \alpha_1)$', 'interpreter', 'latex', 'Fontsize', 15);

axis square;

shading interp
v = [-5 -2 5];
view(v)

saveas(hfig, ['../imgs/det_sliding_coupling', '.eps'], 'epsc');
