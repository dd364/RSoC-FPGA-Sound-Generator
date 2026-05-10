%% dat2rom
% Formats the data in a rom format.
% Input vector y must be integer from 0 to 255
function dat2rom(y)
    % Generate the memory initialisation
    fprintf(1,'\t:= (\n\t');
    for i=1:length(y)
        fprintf(1,'x"%02X"',y(i));
        if i~=length(y)
            fprintf(1,', ');
        end

        if mod(i,64)==0
            fprintf(1,'\n\t');
        end
    end
    fprintf(1,');\n');

end