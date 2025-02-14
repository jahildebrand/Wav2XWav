function outchar = charnum(inchar, number)
% CHARNUM Adjusts a character string to a specified length.
%   outchar = CHARNUM(inchar, number) ensures that inchar is exactly
%   'number' characters long by either truncating or padding with spaces.

% Ensure input is a character array or string
inchar = char(inchar); 

% Get the length of the input string
len = length(inchar);

if len > number
    % Truncate the string if it's too long
    outchar = inchar(1:number);
elseif len < number
    % Pad with spaces if it's too short
    outchar = [inchar repmat(' ', 1, number - len)];
else
    % Return as is if already the correct length
    outchar = inchar;
end
end
