path = [pwd, '/../videos/multibody.avi'];

axs = [-0.5, 0.8, -0.8, 0.8];
simulate(sims, mechanism, traj.dt, axs, path);