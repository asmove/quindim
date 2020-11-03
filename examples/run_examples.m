clear all
close all 
clc

filepath = '~/github/Robotics4fun/examples';
filenames_code = genpath_code(filepath);

CLEAR_ALL = false;

title = sprintf('Loading %d files...', length(filenames_code));
wb = my_waitbar(title);

n = length(filenames_code);

for i = 1:n
    disp(filenames_code{i});
    
    saved_progress = findstr(filenames_code{i}, 'slprj');
    
    if(isempty(saved_progress))
        run([filenames_code{i}, '/main.m']); 
        
        preload_file = [filenames_code{i}, '/slprj'];
        has_preload = exist(preload_file);
        
        try
            rmdir(has_preload);
        catch error
            disp(error.message);
        end
    end
    
    close all;
    
    wb.update_waitbar(i, n);
end
