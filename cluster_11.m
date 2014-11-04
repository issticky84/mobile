function cluster_11()

tic; %time start

k = 25;
file_name = 'BigData_20140319_2213';
folder_name = strcat(file_name,'');
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
% file_csv = 'BigData_20140328_2356.csv';
% file_tag = 'tag_BigData_20140328_2356_c25.csv';
% file_histo = 'histo_BigData_20140328_2356_c25.csv';
% file_time = 'time_BigData_20140328_2356.csv';
% file_center = 'cluster_center_BigData_20140328_2356_c25.csv';


output = read_sensor_file(file_csv);
fprintf('1\n');
cell_row = size(output,1);
title = [4 5 6 7 8 9 10 11 12 13 20 21 27 31]; 
title_num = length(title); %title_num = 14
%%%%%%%%%%%%%%%%%%%%%% save data in matrix %%%%%%%%%%%%%%%%%%%%%%%%%
%[AllMat] = matrix_assignment(output,cell_row,title_num,title);
[AllMat] = set_matrix_2(output,cell_row,title_num,title,file_time);
fprintf('2\n');
%disp(AllMat);
%%%%%%%%%%%%%%%%%%% K-means clustering %%%%%%%%%%%%%%%%%%%%
%[Idx,C,sumd,D] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4,'emptyaction','singleton','start','uniform');
[Idx,C,sumd,D] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4,'emptyaction','singleton');
%[Idx] = kmeans(AllMat,k,'dist','sqEuclidean','rep',4);
csvwrite(file_center,C);
csvwrite(file_tag,Idx);
csvwrite('sumd.csv',sumd);
csvwrite('D.csv',D);
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

t = toc; %time end
disp(t);


end %end of function