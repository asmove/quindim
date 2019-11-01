function F = rayleigh_energy(body)
    F = sym(0);
    for damper = body.dampers
        damper = damper{1};
        
        curr = damper.head;
        prev = damper.tail;
        b = damper.b;

        F = F + (1/2)*b*(curr - prev).'*(curr - prev);
    end
end