function plot_qpu(sims)
    n = length(sims);
    
    t = zeros(1, n);
    q = zeros(n, 6);
    p = zeros(n, 6);
    constraints_error = zeros(n, 1);
    q_error = zeros(n, 1);
    
    % Constraints error
    for i = 1:n
        constraints_error(i) = sims{i}.constraints_error;
    end
    
    % q-error
    for i = 1:n
        q_error(i) = sims{i}.q_error;
    end
    
    % q, p
    for i = 1:n
        for j = 1:6
            q(i,j) = sims{i}.q(j+3);
            p(i,j) = sims{i}.p(j+3);
        end
    end
    
    u = zeros(n, 3);
    
    % Motors
    for i = 1:n
        t(i) = sims{i}.t;
        
        u(i,1) = sims{i}.u(1);
        u(i,2) = sims{i}.u(2);
        u(i,3) = sims{i}.u(3);
    end
    
    e_const = zeros(n, 3);
    e_q = zeros(n, 3);
    
    % Motors
    for i = 1:n
        t(i) = sims{i}.t;
        
        e_const = sims{i}.constraints_error;
        e_q = sims{i}.constraints_error;
    end
    
    hfig_t = figure('units','normalized', 'outerposition', [0 0 1 1]);
    subplot(3, 1, 1);
    plot(t, u(:,1));
    title('$\tau_1$', 'interpreter', 'latex')
    ylabel('[N.m]');
    xlabel('t [s]');
    
    subplot(3, 1, 2);
    plot(t, u(:,2));
    title('$\tau_2$', 'interpreter', 'latex')    
    ylabel('[N.m]');
    xlabel('t [s]');
    
    subplot(3, 1, 3);
    plot(t, u(:,3));
    title('$\tau_3$', 'interpreter', 'latex')    
    ylabel('[N.m]');
    xlabel('t [s]');
    
    hfig_q = figure('units','normalized', 'outerposition', [0 0 1 1]);
    subplot(3, 2, 1);
    plot(t, q(:,1));
    title('${}^1 q_1$', 'interpreter', 'latex');
    ylabel('[rad]');
    xlabel('t [s]');
    
    subplot(3, 2, 2);
    plot(t, q(:,2));
    title('${}^1 q_2$', 'interpreter', 'latex');
    ylabel('');
    xlabel('t [s]');
    
    subplot(3, 2, 3);
    plot(t, q(:,3));
    title('${}^2 q_1$', 'interpreter', 'latex');
    ylabel('[rad]');
    xlabel('t [s]');
    
    subplot(3, 2, 4);
    plot(t, q(:,1));
    title('${}^2 q_2$', 'interpreter', 'latex');
    ylabel('[rad]');
    xlabel('t [s]');
    
    subplot(3, 2, 5);
    plot(t, q(:,2));
    title('${}^3 q_1$', 'interpreter', 'latex');
    ylabel('[rad]');
    xlabel('t [s]');

    subplot(3, 2, 6);
    plot(t, q(:,3));
    title('${}^3 q_2$', 'interpreter', 'latex');
    ylabel('[rad]');
    xlabel('t [s]');
    
    hfig_p = figure('units','normalized', 'outerposition', [0 0 1 1]);
    subplot(3, 2, 1);
    plot(t, p(:,1));
    title('${}^1 p_1$', 'interpreter', 'latex');
    ylabel('[rad/s]');
    xlabel('t [s]');
    
    subplot(3, 2, 2);
    plot(t, p(:,2));
    title('${}^1 p_2$', 'interpreter', 'latex');
    ylabel('[rad/s]');
    xlabel('t [s]');
    
    subplot(3, 2, 3);
    plot(t, p(:,3));
    title('${}^2 p_1$', 'interpreter', 'latex');
    ylabel('[rad/s]');
    xlabel('t [s]');
    
    subplot(3, 2, 4);
    plot(t, p(:,1));
    title('${}^2 p_2$', 'interpreter', 'latex');
    ylabel('[$rad/s$]');
    xlabel('t [s]');
    
    subplot(3, 2, 5);
    plot(t, p(:,2));
    title('${}^3 p_1$', 'interpreter', 'latex');
    ylabel('[$rad/s]$');
    xlabel('t [s]');
    
    subplot(3, 2, 6);
    plot(t, p(:,3));
    title('${}^3 p_2$', 'interpreter', 'latex');
    ylabel('[rad/s]');
    xlabel('t [s]');
    
    hfig_phi = figure('units','normalized', 'outerposition', [0 0 1 1]);
    plot(t, constraints_error);
    title('$|\varphi(\mathbf{q})|_{\infty} = \epsilon_\varphi$', 'interpreter', 'latex');
    
    hfig_e = figure('units','normalized', 'outerposition', [0 0 1 1]);
    plot(t, q_error);
    title('$|\mathbf{q}_{k} - \mathbf{q}_{k-1}|_2 = \epsilon_{\Delta q}$', 'interpreter', 'latex');
    
    saveas(hfig_t, [pwd, '/../images/torques'], 'fig');
    saveas(hfig_t, [pwd, '/../images/torques'], 'epsc');
    saveas(hfig_q, [pwd, '/../images/coordinates'], 'fig');
    saveas(hfig_q, [pwd, '/../images/coordinates'], 'epsc');
    saveas(hfig_p, [pwd, '/../images/speeds'], 'fig');
    saveas(hfig_p, [pwd, '/../images/speeds'], 'epsc');
    saveas(hfig_e, [pwd, '/../images/error'], 'fig');
    saveas(hfig_e, [pwd, '/../images/error'], 'epsc');
    saveas(hfig_phi, [pwd, '/../images/constraints'], 'fig');
    saveas(hfig_phi, [pwd, '/../images/constraints'], 'epsc');
end
