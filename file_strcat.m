function name = file_strcat(file_name,k)
    k_str = int2str(k);
    c_name = '_c';
    csv_name = '.csv';
    temp = strcat(file_name,c_name);
    temp = strcat(temp,k_str);
    name = strcat(temp,csv_name);    
    
end