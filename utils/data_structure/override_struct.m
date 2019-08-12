function A = override_struct(A, varargin)
%% OVERRIDE_STRUCT Override structure values from other structure or Name/Value
%
% Syntax:
%     A = OVERRIDE_STRUCT(A, B)
%     A = OVERRIDE_STRUCT(A, B1, B2, ...)
%     A = OVERRIDE_STRUCT(A, Name, Value, ...)
%
% Input:
%     A     - structure with fields and values to be overridden
%     B...  - structure to override A's values with if the fields match
%     Name  - fieldname in A to override
%     Value - value of fieldname Name 
%   Note, it is possible to supply multiple Name/Value pairs and mix the input
%   type between Name/Value pairs and structures.
%
% Output:
%     A     - structure A with overridden values
%
% Comments:
%     Overrides a structure with values from another structure at matching
%     fieldnames. Fieldnames in B that do not exists in A will be ignored.
%
%     Simplifies the use of [..., Name, Value] input parsing in Matlab
%     functions. 
%     Example usage in function:
%     
%     function myOut = my_fun(myData, varargin)
%     % Syntax: 
%     %  myOut = my_fun(myData)
%     %  my_fun(__, OptionStruct)
%     %  my_fun(__, Name, Value)
%     % Default option:
%     OptionStruct = struct('par1',1,'par2',2,'par3',3);
%     % Parse extra input to function:
%     OptionStruct = override_struct(OptionStruct, varargin{:});
%     % Start to compute myOut using myData and OptionStruct ...  
%
%     For more advanced input control, use the excellent inputParser object
%     to parse your input. This function is basically a lightweight alternative
%     to inputParser without any explicit error control.
%
% See also struct, fieldnames, inputParser

%   Created by: Johan Winges
%   $Revision: 1.0$  $Date: 2014-10-21 14:00:00$
%   $Revision: 1.1$  $Date: 2014-10-23 14:00:00$
%     Added Name, Value input type

%% Override structures:

% Return A if no input additional input:
if isempty(varargin)
   return
end

% Find fieldnames of A structure:
fA       = fieldnames(A);

% Loop over varargin input:
iArgin   = 1;
while true
   
   % Check if Name (i.e. string):
   if ischar(varargin{iArgin}) 
      % Check that fieldname is valid:
      if isfield(A, varargin{iArgin})
         % Add Value as the next input:
         if iArgin+1 <= length(varargin)
            A.(varargin{iArgin}) = ...
               varargin{iArgin+1};
         else
            warning('missing value field for option %s',...
               varargin{iArgin})
         end
      else
         warning('unknown name field %s',...
            varargin{iArgin})
      end
      % Jump to next input:
      iArgin = iArgin + 2;
      
   % Check if option is struct:
   elseif isstruct(varargin{iArgin})
      % Override from structure fields:
      fBn = fieldnames(varargin{iArgin});
      for ifA = 1:length(fA)   
         tf = strcmp(fA{ifA}, fBn);
         if any(tf) 
            % The field fA{ifA} exists in Bn, override values:
            A.(fA{ifA}) = varargin{iArgin}.(fA{ifA});
         end
      end
      % Jump to next input:
      iArgin = iArgin + 1;
      
   % Unknown input format
   else
      error('unknown input format')
   end
   
   % End loop when there is no more input:
   if iArgin > length(varargin)
      break
   end
end
