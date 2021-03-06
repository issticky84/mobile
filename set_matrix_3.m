function [OutMat2] = set_matrix_3(csv_mat,cell_row,title_num,title,file_time) % add location(latitude) & location(longitude)
%先計算norm再對data做高斯平滑化跟normalize
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
            if j~=10 & j~=11
                %Mat(:,1) = normalized_mat(Mat(:,1)); %Normalize
            end
            for k=1:cell_row
                OutMat(k,j) = Mat(k,1);
            end
        end
       
    end  
    
    %csvwrite('distance.csv',OutMat(:,13:14));
    location_mat = OutMat(:,10:11);
    for k=1:cell_row
        if k==1
            OutMat(k,10) = 0;
            continue;
        end
        d = DistanceOfLontitudeAndLatitude(location_mat(k-1,1),location_mat(k,1),location_mat(k-1,2),location_mat(k,2));
        if d > 1.0
            OutMat(k,10) = 0.0;
        else
            OutMat(k,10) = d;
        end
    end
    
    %csvwrite('distance2.csv',OutMat(:,13));
    
    %OutMat(:,10) = normalized_mat(OutMat(:,10));
    
    %csvwrite('distance_normalized.csv',OutMat(:,13));
    
    %%%%%%%%%%%%%%%%%%%%vector to norm%%%%%%%%%%%%%%%%%%%%%%%%% 
    for i=1:cell_row
     OutMat(i,1) = norm(OutMat(i,1:3));  
     OutMat(i,2) = norm(OutMat(i,4:6));  
     OutMat(i,3) = norm(OutMat(i,7:9));  
    end
    
    OutMat2 = OutMat(:,1:10);
    OutMat2(:,4:9) = [];
    csvwrite('OutMat1.csv',OutMat2);
    %%%%%%%%%%%%%%Gaussian Filter to raw data%%%%%%%%%%%%%%%%%%%
    ImgMat = zeros(cell_row,size(OutMat2,2));
    ImgMat(:,:,1) = OutMat2(:,:);
    %# Create the gaussian filter with hsize = [5 5] and sigma = 2
    G = fspecial('gaussian',[5 5],2);
    %# Filter it
    Ig = imfilter(ImgMat,G,'same'); 
    OutMat2(:,:) = Ig(:,:,1);
    csvwrite('OutMat2.csv',OutMat2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:size(OutMat2,2)
        OutMat2(:,i) = normalized_mat(OutMat2(:,i));
        if i==size(OutMat2,2)
            OutMat2(:,i) = OutMat(:,10); %give "longitude & latitude" larger weighting
            OutMat2(:,i) = normalized_mat(OutMat2(:,i));
            OutMat2(:,i) = OutMat2(:,i) * 1.0;
        end
    end
    
    
    csvwrite('OutMat3.csv',OutMat2);
    csvwrite(file_time,timeMat);
end