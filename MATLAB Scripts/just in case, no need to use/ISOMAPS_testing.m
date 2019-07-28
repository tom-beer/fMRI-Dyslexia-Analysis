clear all
clc

addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

%% Isomap
%getting the matrix: voxels X Descriptor using Isomap

%data = reshape(im,size(im,4),[]); %time X voxels
%data_inv = data'; %voxels X time
partial_data = reshape(im(:,:,25,:),size(im,1)*size(im,2),size(im,4)); %voxels X time
partial_data_inv = partial_data';

figure(1)
subplot(121)
original_slice = im(:,:,25,20); %t = 20;
imshow(original_slice,[]);
subplot(122)
imshow(reshape(partial_data(:,20),size(original_slice,1),size(original_slice,2)),[])

% the rows stays the same - voxels
dim = 10;
k = 10;
[mappedA_Isomap, mapping_Isomap] = compute_mapping_mod(partial_data,'DM',dim,k);

%% K means - our data -  slice 25 (t=20)
f = mappedA_Isomap;
vox = 1:1:3339;
rng(1); %for reproducibility
[idx,C] = kmeans(f,7); %idx - clustering, C - centroid locations

%data = [vox' f];
figure(10)
subplot(121)
imshow(reshape(partial_data(:,20),size(original_slice,1),size(original_slice,2)),[]);
title('Original image','FontSize',20,'FontName','garamond');

im_clustered = reshape(idx,size(original_slice,1),size(original_slice,2));
subplot(122)
imshow(im_clustered,[]);
suptitle('slice 25 | t = 20');
title('Isomap (10 dim) + K-means (7 clusters)','FontSize',20,'FontName','garamond');