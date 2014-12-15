function rgb_mat = lab_transform_BinarySearch_convhull(rawMat)
    tic %time start
    lab_vertices = read_csv('LAB_vertices.csv');
    fprintf('Finish reading LAB vertices...\n');
    vTotal = size(lab_vertices,1);    
    %cluster_center_mat = read_csv('csv_data/output2.csv');
    k = size(rawMat,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�p��cluster center����
    rawMat_centroid = compute_centroid(rawMat);
    %�������I��h����(�N���ߥ�������I)
    for i=1:k
        for j=1:size(rawMat,2)
            rawMat(i,j) = rawMat(i,j) - rawMat_centroid(1,j);
        end
    end
    %�p��lab vertices����
    lab_vertices_centroid = compute_centroid(lab_vertices);
    %�������I��h����(�N���ߥ�������I)
    for i=1:vTotal
        for j=1:3
            lab_vertices(i,j) = lab_vertices(i,j) - lab_vertices_centroid(1,j);
        end
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PCA dimension reduction : cluster center matrix
    [eigenVector,score,eigenvalue] = princomp(rawMat);
    transMatrix(:,1:3) = eigenVector(:,1:3);
    color_mat = rawMat * transMatrix;
    %PCA���T�Ӷb:e1,e2,e3
    e1 = eigenVector(1,1:3);
    e2 = eigenVector(2,1:3);
    e3 = eigenVector(3,1:3);
    %e1_length = max(color_mat(:,1))-min(color_mat(:,1)) %1.724
    color_axis = [e1;e2;e3];
    color_axis = axis_normalized(color_axis);
    %PCA dimension reduction : LAB vertices
    [eigenVector,score,eigenvalue] = princomp(lab_vertices);
    %transMatrix2(:,1:3) = eigenVector(:,1:3);
    %lab_mat = lab_vertices * transMatrix2;
    %PCA���T�Ӷb:v1,v2,v3
    v1 = eigenVector(1,1:3);
    v2 = eigenVector(2,1:3);
    v3 = eigenVector(3,1:3);
    %v1_length = max(lab_mat(:,1))-min(lab_mat(:,1)) %258.4473
    lab_axis = [v1;v2;v3];
    lab_axis = axis_normalized(lab_axis);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    move = (-0.5:0.1:0.5);
    %flag:�P�_�O�_�J��F�@�Ӥ��X�k��LAB�I
    color_mat_const = color_mat;
    %const_invert_color_axis = eye(3)/color_axis;
    max_move = 0;
    max_scale = 0; 
    max_align_mat = color_mat;
    start = 1;
    luminance_threshold = 30;
    %%%%%%%%%%%%%%%%%%%%%% Binary Search the best scale %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:length(move)
        scale_array = (start:1:150);
        low = start;
        high = length(scale_array);
        
        while low <= high

            mid = (low + high)/2;

            color_mat(:) = ( color_mat_const(:) + move(i) ) * mid;
            color_weight = color_mat/color_axis; % p (25x3) = [x y z] (25x3) * [e1;e2;e3] (3x3)
            %color_weight = color_mat*const_invert_color_axis;
            align_mat = color_weight*lab_axis;   
            
            for j=1:3
                %�N���ߥ����^�h
                align_mat(:,j) = align_mat(:,j) + lab_vertices_centroid(1,j);
            end
            a1 = align_mat(:,1);
            a2 = align_mat(:,2);
            a3 = align_mat(:,3);
            convhull_mat = convhull(a1,a2,a3);
            
            flag = 0;
            for j=1:k
               if align_mat(j,1)<luminance_threshold
                    flag = 1;
                    break;
               end                
            end
            
            if flag==0
                for j=1:size(convhull_mat,1)
                    j1 = convhull_mat(j,1);
                    j2 = convhull_mat(j,2);
                    j3 = convhull_mat(j,3);
                    if lab_boundary_test(a1(j1),a2(j2),a3(j3))==0
                         flag = 1;
                         break;
                    end
                end
            end
            
            if high <= low
                break;
            elseif flag==0  %lab_boundary_test pass,larger the search index
                low = mid + 1;
            else            %lab_boundary_test fail,lower the search index
                high = mid - 1;                
            end
        end
        
        if low>max_scale
            max_scale = low;
            max_move = move(i);
            max_align_mat = align_mat;
            start = max_scale;
        end
    end
    
    if max_scale == 0
        for j=1:3
            %�N���ߥ����^�h
            max_align_mat(:,j) = max_align_mat(:,j) + lab_vertices_centroid(1,j);
        end
    end 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    toc %time end
    %fprintf('time elapsed : %f\n',t);
    fprintf('max_move : %f max_scale : %f\n',max_move,max_scale);
    fprintf('========================================\n');
    
    csvwrite('output/lab_color.csv',max_align_mat);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rgb_mat = LABtoRGB(max_align_mat);
    csvwrite('output/rgb_color.csv',rgb_mat);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     i = 1;
%     for j=1:k
%         color = rgb_mat(j,1:3);
%         fill([i i+1 i+1 i],[j j j+1 j+1],color); % [x1 x2 x3 x4] [y1 y2 y3 y4]
%         hold on    
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end