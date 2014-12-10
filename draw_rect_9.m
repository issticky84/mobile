function draw_rect_9() %use PCA_3D to compute RGB(correct) ; don't sort the bins ; use LAP_1D for position x
    k = 100;    
    file_name = 'BigData_20141121_2315';
    %folder_name = strcat(file_name,'_location_norm_gaussian');
    folder_name = strcat(file_name,'_location_gaussian_norm'); 
    %folder_name = file_name;
    %mkdir(folder_name);
    
    histo_mat = read_csv( file_strcat( strcat( strcat(folder_name,'/histo_'),file_name),k) );
    cluster_center_mat = read_csv( file_strcat( strcat( strcat(folder_name,'/cluster_center_'),file_name),k) ) ;
    time_mat = read_csv( file_strcat( strcat( strcat(folder_name,'/time_'),file_name),k) );
    hour_file = file_strcat(strcat( strcat(folder_name,'/hour_'),file_name),k);
    RGB_file = file_strcat(strcat( strcat(folder_name,'/RGB_'),file_name),k);
    position_file = file_strcat(strcat( strcat(folder_name,'/position_'),file_name),k);    
    %lab_mat = read_csv( file_strcat(strcat( strcat(folder_name,'/LAB_raw_'),file_name),k) );
    
    img_mat = zeros(350,9000,3);  

    transMatrix = histo_position(cluster_center_mat,histo_mat,k); %MDS_1D
    %transMatrix = histo_position_LAB(lab_mat,histo_mat,k); 
    %transMatrix = histo_position_LAPBIN(cluster_center_mat,histo_mat,k); %LAP_1D
    %transMatrix = histo_position_LAPBIN_kNNMAsk(cluster_center_mat,histo_mat,k,6);
    %transMatrix = histo_position_LAPSIM_kNNMAsk(cluster_center_mat,histo_mat,k);
    csvwrite('output/transMatrix.csv',transMatrix);
    %transMatrix(:) = transMatrix(:) * 100000000000000;
    min_transMatrix = min(transMatrix);
    transMatrix(:) = transMatrix(:) - min_transMatrix + 0.1;
    %csvwrite('output/move_transMatrix.csv',transMatrix);
    max_transMatrix = max(transMatrix);
    transMatrix(:) = transMatrix(:) / (max_transMatrix - min_transMatrix);
    %transMatrix(:) = round(transMatrix(:)*1000)*10;
    transMatrix(:) = round(transMatrix(:)*1000)*10;
    csvwrite(position_file,transMatrix);

    time_step_amount = size(histo_mat,1);
    %%%%%%%%%%%%%%%%%%% time_mat -> hour_mat %%%%%%%%%%%%%%%%%%%%
    t = 1;
    hour_mat = zeros(time_step_amount,1);
    for i=1:time_step_amount
        minutes = time_mat(t);
        hour_mat(i,1) = floor(minutes/60);
        t = t + 600;
    end
    csvwrite(hour_file,hour_mat);
    %%%%%%%%%%%%%%%%%%% Compute RGB with PCA %%%%%%%%%%%%%%%%%%%%
    RGB_mat = PCA_RGB(cluster_center_mat);
    %csvwrite('RGB_mat.csv',RGB_mat);
    RGB_mat = normalized_data(RGB_mat);
    csvwrite(RGB_file,RGB_mat);

    %cluster_RGB_mat = cluster_RGB(k);%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Draw Rectangle %%%%%%%%%%%%%%%%%%%%%%%
    last_hour = 25;
    time_index = 1;
    for index = 1:time_step_amount
        if (hour_mat(index)~=last_hour)
            time_index = time_index + 5;
            %text('units','pixels','position',[100 time_index],'fontsize',1000,'string','some text') 
            for j=1:9000
                img_mat(time_index-3,j,1:3) = 1; 
            end
        end
        last_hour = hour_mat(index);        
        
        %color bar (600)
        start = transMatrix(index);
        i = start;
        j = 1;
        while(i~=start+600)
        %while(j~=k)
            number = histo_mat(index,j);
            if number==0 
                j = j + 1;
                continue;
            end
            for t=i+1:i+number
               img_mat(time_index,t,1:3) = RGB_mat(j,1:3); 
               %img_mat(time_index,t,1:3) = gray2rgb(cluster_RGB_mat(j));
            end
            i = i + number;
            j = j + 1;
        end
        
        time_index = time_index + 1;
    end    
    %%%%%%%%%%%%%%%%% Ouput image and resize %%%%%%%%%%%%%%%%%%%%
    set(0, 'DefaultFigureRenderer', 'OpenGL');
    f = figure('WindowScrollWheelFcn',@figScroll,'Name','Scroll Wheel Demo');
    x = [0:.1:40];
    y = 4.*cos(x)./(x+2);
    a = axes; 
    h = plot(x,y);
    set(gcf,'Renderer','OpenGL')

    imwrite(img_mat,'img_mat.png');
    img_mat = imread('img_mat.png');
    %resize_img = imresize(img_mat,1);
    resize_img = imresize(img_mat,[6000 3000]);
    imwrite(resize_img,'resize_img_mat.png');
    image(resize_img);
    axis image
    axis xy
    set(gca,'XTick',[]);
    set(gca,'YTick',[100:300:6000])
    time_array = char('0:00','1:00','2:00','3:00','4:00','5:00','6:00','7:00','8:00','9:00','10:00','11:00',...
               '12:00','13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00');
    start_hour = hour_mat(1) + 1;
    end_hour = hour_mat(time_step_amount) + 1;
    time = {time_array(start_hour:end_hour,:)};  
    set(gca,'YTickLabel',time)
    %axis image
    %axis xy
end
