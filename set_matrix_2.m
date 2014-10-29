function [OutMat] = set_matrix_2(csv_mat,cell_row,title_num,title,file_time)
%Normalize all data except time data (index j==title_num)
OutMat = zeros(cell_row,title_num-1);
Mat = zeros(cell_row,1);
timeMat = zeros(cell_row,1);
    for j=1:title_num
        title_no = title(j);
        for i=1:cell_row   
            if j==title_num  %handle time data and convert to minutes
                data = char(csv_mat(i,title_no));
                hour = strcat(data(12),data(13));
                minute = strcat(data(15),data(16));    
                h = str2double(hour);
                m = str2double(minute);
                all_minutes = h*60 + m;  
                %Mat(i,1) = all_minutes;
                timeMat(i,1) = all_minutes;
            else 
                data = str2double(char(csv_mat(i,title_no))); %pack cell to string(char), then convert to double 
                Mat(i,1) = data;
            end
        end 
        
        if j~=title_num
            Mat(:,1) = normalized(Mat(:,1)); %Normalize
            for k=1:cell_row
                OutMat(k,j) = Mat(k,1);
            end
        end
    end  
    
    csvwrite(file_time,timeMat);
end