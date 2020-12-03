clear all
close all 
clc

filepath = '~/github/Robotics4fun/examples';
filenames_code_ = genpath_code(filepath);

% Clear slprj projects
for i = 1:length(filenames_code_)
    fname = filenames_code_{i};
    
    kwds = {'slprj', 'WIP'};
    
    is_kwd = false;
    for j = 1:length(kwds)
        is_kwd = is_kwd|contains(fname, kwds{j});
    end
    
    if(is_kwd)
        filenames_code_{i} = [];
    end
end

filenames_code = {};
for i = 1:length(filenames_code_)
    fname = filenames_code_{i};
    
    if(~isempty(fname))
        filenames_code{end+1} = fname;
    end
end

CLEAR_ALL = false;

title = sprintf('Loading %d files...', length(filenames_code));
wb = my_waitbar(title);

n = length(filenames_code);

for i = 1:n
    t0 = tic;
    fname = filenames_code{i};
    saved_progress = findstr(fname, 'slprj');
    
    split_fname = strsplit(filenames_code{i}, '/');
    
    example_fname = split_fname{5};
    
    wb.change_title(example_fname);
    
    if(isempty(saved_progress))
        
        try
            run([fname, '/main.m']);
        catch error
            disp([fname, ': ERROR']);
            disp(error.message);
        end
    end
    
    close all;
    
    wb.update_waitbar(i, n);

    toc(t0)
end
