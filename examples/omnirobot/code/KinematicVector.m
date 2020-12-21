function qp = KinematicVector(in1)

%    This function was generated by the Symbolic Math Toolbox version 7.2.

%    20-Dec-2020 21:28:32



p1 = in1(7,:);

p2 = in1(8,:);

p3 = in1(9,:);

th = in1(3,:);

t2 = pi.*(1.0./3.0);

t3 = t2+th;

qp = [p2.*cos(th+pi.*(1.0./6.0)).*(-4.3e1./7.5e2)+p3.*sin(t3).*(4.3e1./7.5e2)-p1.*sin(th).*(4.3e1./7.5e2);p3.*cos(t3).*(-4.3e1./7.5e2)+p1.*cos(th).*(4.3e1./7.5e2)-p2.*cos(-t2+th).*(4.3e1./7.5e2);p1.*(1.0./3.0)+p2.*(1.0./3.0)+p3.*(1.0./3.0);p1;p2;p3];

end