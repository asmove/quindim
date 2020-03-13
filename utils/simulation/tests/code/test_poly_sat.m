clear all
close all
clc

multiplots = [];

xs = -2:0.01:2;
degrees = 2:10;

for degree = degrees
    vals = [];
    for x = xs
        val = poly_sat(x, 1, degree);
        vals = [vals; val];
    end
    multiplots = [multiplots, vals];
end

hfig = my_figure();
plot(xs, multiplots);

filepath = '../imgs/';
img_path = 'polysat';
saveas(hfig, [filepath, img_path, '.eps'], 'epsc');