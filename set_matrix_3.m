function [OutMat] = set_matrix_3(csv_mat,cell_row,title_num,title,file_time) % add location(latitude) & location(longitude)
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
            if j~=13 & j~=14
                Mat(:,1) = normalized_mat(Mat(:,1)); %Normalize
            end
            for k=1:cell_row
                OutMat(k,j) = Mat(k,1);
            end
        end
       
    end  
    
    %csvwrite('distance.csv',OutMat(:,13:14));
    location_mat = OutMat(:,13:14);
    for k=1:cell_row
        if k==1
            OutMat(k,13) = 0;
            continue;
        end
        OutMat(k,13) = DistanceOfLontitudeAndLatitude(location_mat(k-1,1),location_mat(k,1),location_mat(k-1,2),location_mat(k,2));
    end
    
    %csvwrite('distance2.csv',OutMat(:,13));
    
    OutMat(:,13) = normalized_mat(OutMat(:,13));
    csvwrite('distance_normalized.csv',OutMat(:,13));
    csvwrite(file_time,timeMat);
end