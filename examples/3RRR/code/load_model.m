% Closed chain
mechanism = load_mechanism('num');

% Implicit attributes
mechanism.eqdyn = orsino_eqdyn(mechanism); 
toc(t0)