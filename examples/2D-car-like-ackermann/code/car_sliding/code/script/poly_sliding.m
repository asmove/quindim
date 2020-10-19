clear all
close all
clc

dx = 1e-2;
x = 0:dx:1;

[X0, X1] = meshgrid(x, x);
Y1 = X0.^2 + 2*X0.*X1 - 2*X0 + X1.^2;
Y2 = X1.^2 - 2*X1 + 1;
Y3 = Y1 + Y2;

hfig = my_figure();

% Plot 1
subplot(1, 3, 1);
[C, h] = contour(X0, X1, Y1);
set(h,'ShowText','on', 'TextStep', 0.05)
colormap cool

% surf(X0, X1, Y1);
% hold on
% surfc(X0, X1, Y1);

titletxt = '$p_1(\alpha_0, \, \alpha_1) = \alpha_0^2 + 2\,\alpha_0\,\alpha_1 - 2\,\alpha_0 + \alpha_1^2$';
title(titletxt, 'interpreter', 'latex', 'Fontsize', 15);
xlabel('$\alpha_0$', 'interpreter', 'latex', 'Fontsize', 15);
ylabel('$\alpha_1$', 'interpreter', 'latex', 'Fontsize', 15);
%zlabel('$p_1(\alpha_0, \, \alpha_1)$', 'interpreter', 'latex', 'Fontsize', 15);

axis square;
axis equal;

% shading interp
% v = [-5 -2 5];
% view(v)

% Plot 2
subplot(1, 3, 2);
% surf(X0, X1, Y2);
% hold on
% surfc(X0, X1, Y2);
[C, h] = contour(X0, X1, Y2);
set(h,'ShowText','on', 'TextStep', 0.05)
colormap cool

titletxt = '$p_2(\alpha_0, \, \alpha_1) = \alpha_1^2 + 2 \alpha_1 + 1$';
title(titletxt, 'interpreter', 'latex', 'interpreter', 'latex', 'Fontsize', 15);
xlabel('$\alpha_0$', 'interpreter', 'latex', 'Fontsize', 15);
ylabel('$\alpha_1$', 'interpreter', 'latex', 'Fontsize', 15);
%zlabel('$p_2(\alpha_0, \, \alpha_1)$', 'interpreter', 'latex', 'Fontsize', 15);

% shading interp
% v = [-5 -2 5];
% view(v)

axis square;
axis equal;

% Plot 2
subplot(1, 3, 3);
% surf(X0, X1, Y2);
% hold on
% surfc(X0, X1, Y2);
[C, h] = contour(X0, X1, Y3);
set(h,'ShowText','on', 'TextStep', 0.05)
colormap cool

titletxt = '$p_3 = p_1 + p_2$';
title(titletxt, 'interpreter', 'latex', 'interpreter', 'latex', 'Fontsize', 15);
xlabel('$\alpha_0$', 'interpreter', 'latex', 'Fontsize', 15);
ylabel('$\alpha_1$', 'interpreter', 'latex', 'Fontsize', 15);
%zlabel('$p_2(\alpha_0, \, \alpha_1)$', 'interpreter', 'latex', 'Fontsize', 15);

% shading interp
% v = [-5 -2 5];
% view(v)

axis square;
axis equal;

saveas(hfig, ['../imgs/surfaces', '.eps'], 'epsc');
