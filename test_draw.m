function test_draw()
    sort_mat = test_sort();
    img_mat = zeros(150,600,3);
    RGB_mat = zeros(25,3);
    for index = 1:size(sort_mat,1)
        test_mat = sort_mat(index,:);
        normalize_test_mat = test_mat/601;
        for i=1:25
            RGB_mat(i,1:3) = gray2rgb(normalize_test_mat(1,i));
        end
        %disp(size(test_mat,2));
        i = 0;
        j = 1;
        while(i~=600)
            number = test_mat(j);
            if number==0 
                break;
            end
            for t=i+1:i+number
               img_mat(index,t,1:3) = RGB_mat(j,1:3); 
            end
            i = i + number;
            j = j + 1;
        end
    end

    imwrite(img_mat,'img_mat.png');
    img_mat = imread('img_mat.png');
    resize_img = imresize(img_mat,1);
    image(resize_img);  
    axis image
end