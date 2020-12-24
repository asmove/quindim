function wheel = build_wheel(center, angle, R, width)
    wheel.center = center;
    wheel.orientation = angle;
    wheel.width = width;
    wheel.radius = R;
    wheel.A = center + rot2d(pi/2 + angle)*[R; 0];
    wheel.B = center - rot2d(pi/2 + angle)*[R; 0];
end