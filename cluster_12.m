function cluster_12() % add location(latitude) & location(longitude)

tic %time start

k = 100;
k_str = int2str(k);
file_name = 'BigData_20141213_1350';
folder_name = strcat(file_name,'_c');
folder_name = strcat(folder_name,k_str);
folder_name = strcat(folder_name,'_location_gaussian_norm');
%folder_name = strcat(folder_name,'_location_norm_gaussian');
mkdir(folder_name);

csv_name = '.csv';
file_csv = strcat('csv_data/',file_name);
file_tag = 'output/tag.csv';
file_histo = strcat( strcat(folder_name,'/histo_') ,file_name);
file_time = strcat( strcat(folder_name,'/time_'), file_name);
file_center = strcat( strcat(folder_name,'/cluster_center_'),file_name);
file_raw_data_3D = strcat( strcat(folder_name,'/raw_data_3D_'),file_name);

file_csv = strcat(file_csv,csv_name);

file_histo = file_strcat(file_histo,k);
file_time = file_strcat(file_time,k);
file_center = file_strcat(file_center,k);
file_raw_data_3D = file_strcat(file_raw_data_3D,k);


output = read_sensor_file(file_csv);
fprintf('1\n');
cell_row = size(output,1);
%title = [4 5 6 7 8 9 10 11 12 13 20 21 27 31];  %for old file 
%title = [4 5 6 7 8 9 10 11 12 13 20 21 22 23 28 32];  %for new file (Satellites in range)
                                                      %22:latitude,23:longitude
%title = [4 5 6 7 8 9 10 11 12 22 23 32];    
title = [4 5 6 7 8 9 10 11 12 22 23 31];  %for new file (google-atitude,no voltage and so one)
title_num = length(title); %title_num = 14
%%%%%%%%%%%%%%%%%%%%%% save data in matrix %%%%%%%%%%%%%%%%%%%%%%%%%
%[AllMat] = matrix_assignment(output,cell_row,title_num,title);
[AllMat] = set_matrix_4(output,cell_row,title_num,title,file_time);

csvwrite('AllMat.csv',AllMat);
fprintf('2\n');
%disp(AllMat);
%%%%%%%%%%%%%%%%%%% K-means clustering %%%%%%%%%%%%%%%%%%%%
%[Idx,C,sumd,D] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4,'emptyaction','singleton','start','uniform');
[Idx,C,sumd,D] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4,'emptyaction','singleton');
%[Idx] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4);
csvwrite(file_center,C);
csvwrite(file_tag,Idx);
%csvwrite('sumd.csv',sumd);
%csvwrite('D.csv',D);
fprintf('3\n');
%%%%%%%%%%%%%%%%%%% Histogram Voting %%%%%%%%%%%%%%%%%%%%
Tmat = read_csv(file_tag); %read tag_mat so that K-means clustering result stay fixed
%cluster_histogram = sampling_2(Tmat,k,cell_row);
cluster_histogram = voting(Tmat,k,cell_row);
csvwrite(file_histo,cluster_histogram);
%cluster_histogram = normalized(cluster_histogram);
%cluster_histogram(:,:) = cluster_histogram(:,:)/600;
%csvwrite('normalized4_histo_BigData_20140319_2213.csv',cluster_histogram);

raw_data_3D = PCA_RGB(AllMat);
raw_data_3D = normalized_data(raw_data_3D);
csvwrite(file_raw_data_3D,raw_data_3D);
fprintf('4\n');

toc %time end

end %end of function