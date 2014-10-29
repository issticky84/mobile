function [data] = read_sensor_file(file_name)

f=fopen(file_name);
%f=fopen('sensor_data.csv');

fgets(f); %ignore sep=
fgets(f); %ignore title
%data = cell(0,0); %using cell
tline = fgets(f);
row = 0;
while ischar(tline)
    raw = (regexp (tline, ';', 'split'));
    %data = [data;raw];
    tline = fgets(f);
    row = row + 1;
end

frewind(f); %rewind to the beginning of the file

fgets(f); %ignore sep=
fgets(f); %ignore title
tline = fgets(f);
data = cell(row,length(raw));

i = 1;
while ischar(tline)
    raw = (regexp (tline, ';', 'split'));
    %data = [data;raw];
    for j=1:length(raw)
        data(i,j) = raw(1,j);
    end
    i = i + 1;
    
    tline = fgets(f);    
end

%disp(data);
%disp(size(data,1));

fclose(f);

% f = fopen(file_name);
% %f=fopen('sensor_data.csv');
% 
% fgets(f); %ignore sep=
% fgets(f); %ignore title
% data = cell(0,0); %using cell
% tline = fgets(f);
% 
% while ischar(tline)
%     raw = (regexp (tline, ';', 'split'));
%     data = [data;raw];
%     tline = fgets(f);
% end
% 
% %data
% %disp(data);
% %disp(size(data,1));
% 
% 
% fclose(f);

end

