function test = lab_boundary_test(L,A,B)
    test = 1;
    [r,g,b] = Lab2RGB(L,A,B);
    [L1,A1,B1] = RGB2Lab(r,g,b);
    if abs(L1-L)>0.1 | abs(A1-A)>0.1 | abs(B1-B)>0.1
       test = 0; 
    end
end
% function test = lab_boundary_test(lab_mat)
%    test = 1;
%    rgb_mat = LABtoRGB(lab_mat);
%    lab_mat2 = RGBtoLAB(rgb_mat);
%    for i=1:size(lab_mat,1)
%         if abs(lab_mat(i,1)-lab_mat2(i,1))>0.1 | abs(lab_mat(i,2)-lab_mat2(i,2))>0.1 | abs(lab_mat(i,3)-lab_mat2(i,3))>0.1
%             test = 0;
%             break;
%         end
%    end
% end