lsymb = {'m0', 'm1', 'm2', 'b0', 'b1', 'b2',...
        '\mathrm{L1}_{c}g', '\mathrm{L2}_{c}g', ...
        '\mathrm{L1}', '\mathrm{L1}', ...
        '\mathrm{th1}\!\left(t\right)', '\mathrm{th2}\!\left(t\right)', ...
        '\mathrm{xp}\!\left(t\right)', '\mathrm{th1p}\!\left(t\right)', '\mathrm{th2p}\!\left(t\right)', ...
        '\mathrm{I1}_{3}3', '\mathrm{I2}_{3}3'};
latexvar = {'m_0', 'm_1', 'm_2', ...
            '\mathrm{b_0}', '\mathrm{b_1}', '\mathrm{b_2}',...
            '\ell_{1}^g', '\ell_{2}^g', ...
            '\mathrm{\ell_1}', '\\mathrm{\ell_2}', ...
            '\theta_1', '\theta_2', ...
            '\mathrm{\dot x}', '\mathrm{\dot \theta_1}', '\mathrm{\dot \theta_2}', ...
            '\mathrm{I_1}', '\mathrm{I_2}'};

% Latex pretty model
sys.mass_matrix = simplify(sys.mass_matrix);
sys.coriolis = simplify(sys.coriolis);
sys.A = simplify(sys.A);
sys.B = simplify(sys.B);

pretty_mass11 = latex_model(sys.mass_matrix(1,1), symb, latexvar);
pretty_mass12 = latex_model(sys.mass_matrix(1,2), symb, latexvar);
pretty_mass13 = latex_model(sys.mass_matrix(1,3), symb, latexvar);
pretty_mass21 = latex_model(sys.mass_matrix(2,1), symb, latexvar);
pretty_mass22 = latex_model(sys.mass_matrix(2,2), symb, latexvar);
pretty_mass23 = latex_model(sys.mass_matrix(2,3), symb, latexvar);
pretty_mass31 = latex_model(sys.mass_matrix(3,1), symb, latexvar);
pretty_mass32 = latex_model(sys.mass_matrix(3,2), symb, latexvar);
pretty_mass33 = latex_model(sys.mass_matrix(3,3), symb, latexvar);

A = formula(sys.A);

pretty_A42 = latex_model(A(4,2), symb, latexvar);
pretty_A43 = latex_model(A(4,3), symb, latexvar);
pretty_A44 = latex_model(A(4,4), symb, latexvar);
pretty_A45 = latex_model(A(4,5), symb, latexvar);
pretty_A46 = latex_model(A(4,6), symb, latexvar);

pretty_A52 = latex_model(A(5,2), symb, latexvar);
pretty_A53 = latex_model(A(5,3), symb, latexvar);
pretty_A54 = latex_model(A(5,4), symb, latexvar);
pretty_A55 = latex_model(A(5,5), symb, latexvar);
pretty_A56 = latex_model(A(5,6), symb, latexvar);

pretty_B = latex_model(sys.B, symb, latexvar);

pretty_coriolis = latex_model(sys.coriolis, symb, latexvar);
pretty_friction = latex_model(sys.friction, symb, latexvar);
pretty_gravitational = latex_model(sys.gravitational, symb, latexvar);

% Save on file
% fid = fopen('pretty_model.txt','wt');
% fprintf(fid, '%s', pretty_str);
% fclose(fid);