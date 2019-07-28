clear all
clc

addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

%% LLE
%getting the matrix: voxels X Descriptor using LLE

data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time
%partial_data = reshape(im(:,:,25,:),size(im,1)*size(im,2),size(im,4)); %voxels X time

figure(1)
subplot(121)
original_slice = im(:,:,25,20); %t = 20;
imshow(original_slice,[]);
subplot(122)
imshow(reshape(partial_data(:,20),size(original_slice,1),size(original_slice,2)),[])

% the rows stays the same - voxels
dim = 10;
k = 10;
[mappedA, mapping] = compute_mapping_mod(partial_data,'LLE',dim,k);
%[mappedA] = lle_Yochai(data,k,dim);

%% K means
% K means - our data -  slice 25 (t=20)
f = mappedA';
vox = 1:1:3339;
rng(1); %for reproducibility
[idx,C] = kmeans(f,7); %idx - clustering, C - centroid locations

%data = [vox' f];
figure(2)
subplot(121)
imshow(reshape(partial_data(:,20),size(original_slice,1),size(original_slice,2)),[]);
title('Original image','FontSize',20,'FontName','garamond');

im_clustered = reshape(idx,size(original_slice,1),size(original_slice,2));
subplot(122)
imshow(im_clustered,[]);
suptitle('slice 25 | t = 20');
title('LLE (10 dim) + K-means (7 clusters)','FontSize',20,'FontName','garamond');

%% all data
load K30_LLE;
f_all = mappedA_LLE30;
rng(1); %for reproducibility
[idx_all,~] = kmeans(f_all,7); %idx - clustering, C - centroid locations

%view results
%data = reshape(im,size(im,4),[]); %the original code line

%slice 25
original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
slice_25_t20 = original_data(:,:,25,20);
figure(10)
subplot(121)
imshow(slice_25_t20,[]);
title('Original image','FontSize',20,'FontName','garamond');
data_clustered = reshape(idx_all,size(original_data,1),size(original_data,2),size(original_data,3));
subplot(122)
imshow(data_clustered(:,:,25),[]);
suptitle('slice 25 | t = 20');
title('LLE (10 dim) + K-means (7 clusters)','FontSize',20,'FontName','garamond');