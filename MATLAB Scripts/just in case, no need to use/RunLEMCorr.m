clear
clc
addpath(genpath('../Toolboxes'));

nifti = load_nii('../Data/typical/12/resting/wraresting.nii'); %typical
im = nifti.img;
str = 'typ';

data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time   

%% LEM
dim = 10;

%0 
k = 10;
tic
[mappedA_LEMCorr10_10, mapping_LEMCorr10_10] = compute_mapping_mod(data,'LaplacianCorr',dim,k);
toc
save ([str '_LEMCorr10_10'],'mappedA_LEMCorr10_10','mapping_LEMCorr10_10');

% 
% %1
% k = 12;
% tic
% [mappedA_LEM10_12, mapping_LEM10_12] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM10_12'],'mappedA_LEM10_12','mapping_LEM10_12');
% 
% %2
% k = 14;
% tic
% [mappedA_LEM10_14, mapping_LEM10_14] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM10_14'],'mappedA_LEM10_14','mapping_LEM10_14');
% 
% %3
% k = 16;
% tic
% [mappedA_LEM10_16, mapping_LEM10_16] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM10_16'],'mappedA_LEM10_16','mapping_LEM10_16');
% 
% %4
% k = 18;
% tic
% [mappedA_LEM10_18, mapping_LEM10_18] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM10_18'],'mappedA_LEM10_18','mapping_LEM10_18');
% 
% %5
% k = 20;
% tic
% [mappedA_LEM10_20, mapping_LEM10_20] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM10_20'],'mappedA_LEM10_20','mapping_LEM10_20');
% 
% %Done - data saved
% %%
% dim = 15;
% 
% %0 
% k = 10;
% tic
% [mappedA_LEM15_10, mapping_LEM15_10] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_10'],'mappedA_LEM15_10','mapping_LEM15_10');
% 
% %1
% k = 12;
% tic
% [mappedA_LEM15_12, mapping_LEM15_12] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_12'],'mappedA_LEM15_12','mapping_LEM15_12');
% 
% %2
% k = 14;
% tic
% [mappedA_LEM15_14, mapping_LEM15_14] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_14'],'mappedA_LEM15_14','mapping_LEM15_14');
% 
% %3
% k = 16;
% tic
% [mappedA_LEM15_16, mapping_LEM15_16] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_16'],'mappedA_LEM15_16','mapping_LEM15_16');
% 
% %4
% k = 18;
% tic
% [mappedA_LEM15_18, mapping_LEM15_18] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_18'],'mappedA_LEM15_18','mapping_LEM15_18');
% 
% %5
% k = 20;
% tic
% [mappedA_LEM15_20, mapping_LEM15_20] = compute_mapping_mod(data,'Laplacian',dim,k);
% toc
% save ([str '_LEM15_20'],'mappedA_LEM15_20','mapping_LEM15_20');
% %Done - data saved