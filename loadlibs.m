which -all pathdef.m

PATHS = {'source_seek', 'quindim', 'matlab-utils', 'baryopt'};

GITPATH = '/home/brunolnetto/github/';

for i = 1:3
	libpath_i = [GITPATH, PATHS{i}];

	addpath(libpath_i);
	addpath(genpath(libpath_i));
end
