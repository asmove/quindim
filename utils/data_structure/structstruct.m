% structstruct(S) takes in a structure variable and displays its structure. 
% 
% INPUTS: 
% 
% Recursive function 'structstruct.m' accepts a single input of any class. 
% For non-structure input, structstruct displays the class and size of the 
% input and then exits. For structure input, structstruct displays the 
% fields and sub-fields of the input in an ASCII graphical printout in the 
% command window. The order of structure fields is preserved. 
% 
% OUTPUTS: 
% 
% (none yet!)

function structstruct(S)

% Figure the type and class of the input 
whosout = whos('S'); 
sizes = whosout.size; 
sizestr = [int2str(sizes(1)),'x',int2str(sizes(2))]; 
by=whosout.bytes; 
if by <1024 
bystr=sprintf(' %d B',by); 
elseif by<1024*1024 
bystr=sprintf(' %.2f kB',by/1024); 
elseif by<1024*1024*1024 
bystr=sprintf(' %.2f MB',by/1024/1024); 
else 
bystr=sprintf(' %.2f GB',by/1024/1024/1024); 
end

endstr = [': [' sizestr '] ' whosout.class bystr];

% Print out the properties of the input variable 
disp(' '); 
disp([inputname(1) endstr]);

% Check if S is a structure, then call the recursive function 
if isstruct(S) 
f.recursor(S,0,''); 
end

% Print out a blank line 
disp(' ');

end

function recursor(S,level,recstr)

recstr = [recstr ' |'];

fnames = fieldnames(S);

for i = 1:length(fnames) 

%% Print out the current fieldname 

% Take out the i'th field 
tmpstruct = S.(fnames{i}); 

% Figure the type and class of the current field 
whosout = whos('tmpstruct'); 
sizes = whosout.size; 
ss=size(sizes); 
sizestr = int2str(sizes(1)); 
for j=2:length(sizes); 
sizestr=strcat(sizestr,'x',num2str(sizes(j))); 
end 
sizestr=['[' sizestr ']']; 

by=whosout.bytes; 
if by <1024 
bystr=sprintf(' %3.0f B',by); 
elseif by<1024*1024 
bystr=sprintf(' %3.2f kB',by/1024); 
elseif by<1024*1024*1024 
bystr=sprintf(' %3.2f MB',by/1024/1024); 
else 
bystr=sprintf(' %3.2f GB',by/1024/1024/1024); 
end 

endstr = [': [' sizestr '] ' whosout.class bystr]; 
endstr =sprintf(': %17s %6s %10s ',sizestr,whosout.class, bystr); 

% Create the strings 
if i == length(fnames) % Last field in the current level 
startstr=[recstr(1:(end-1)) '''--' fnames{i}]; 
recstr(end) = ' '; 
else % Not the last field in the current level 
startstr=[recstr '--' fnames{i}]; 
end 
str=sprintf('%-20s %s',startstr, endstr); 
% Print the output string to the command line 
disp(str); 

%% Determine if each field is a struct 

% Check if the i'th field of S is a struct 
if isstruct(tmpstruct) % If tmpstruct is a struct, recursive function call 
f.recursor(tmpstruct,level+1,recstr); % Call self 
end 

end

Sugato