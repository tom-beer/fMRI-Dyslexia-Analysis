% checking HessianLLE, KernelPCA & Local tangent space alignment

clear
clc
addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time

%% LTSA - Local tangent space alignment
%getting the matrix: voxels X Descriptor using LTSA

dim = 10;

%0 
k = 10;
tic
[mappedA_LTSA10_10, mapping_LTSA10_10] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_10','mappedA_LTSA10_10','mapping_LTSA10_10');

%1
k = 12;
tic
[mappedA_LTSA10_12, mapping_LTSA10_12] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_12','mappedA_LTSA10_12','mapping_LTSA10_12');

%2
k = 14;
tic
[mappedA_LTSA10_14, mapping_LTSA10_14] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_14','mappedA_LTSA10_14','mapping_LTSA10_14');

%3
k = 16;
tic
[mappedA_LTSA10_16, mapping_LTSA10_16] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_16','mappedA_LTSA10_16','mapping_LTSA10_16');

%4
k = 18;
tic
[mappedA_LTSA10_18, mapping_LTSA10_18] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_18','mappedA_LTSA10_18','mapping_LTSA10_18');

%5
k = 20;
tic
[mappedA_LTSA10_20, mapping_LTSA10_20] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA10_20','mappedA_LTSA10_20','mapping_LTSA10_20');

dim = 15;

%0 
k = 10;
tic
[mappedA_LTSA15_10, mapping_LTSA15_10] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_10','mappedA_LTSA15_10','mapping_LTSA15_10');

%1
k = 12;
tic
[mappedA_LTSA15_12, mapping_LTSA15_12] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_12','mappedA_LTSA15_12','mapping_LTSA15_12');

%2
k = 14;
tic
[mappedA_LTSA15_14, mapping_LTSA15_14] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_14','mappedA_LTSA15_14','mapping_LTSA15_14');

%3
k = 16;
tic
[mappedA_LTSA15_16, mapping_LTSA15_16] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_16','mappedA_LTSA15_16','mapping_LTSA15_16');

%4
k = 18;
tic
[mappedA_LTSA15_18, mapping_LTSA15_18] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_18','mappedA_LTSA15_18','mapping_LTSA15_18');

%5
k = 20;
tic
[mappedA_LTSA15_20, mapping_LTSA15_20] = compute_mapping_mod(data,'LTSA',dim,k);
toc
save ('LTSA15_20','mappedA_LTSA15_20','mapping_LTSA15_20');

%% KPCA - Kernel PCA
%getting the matrix: voxels X Descriptor using KPCA

%1 
dim = 10;
tic
[mappedA_KPCA10, mapping_KPCA10] = compute_mapping_mod(data,'KPCA',dim);
toc
save ('KPCA10','mappedA_KPCA10','mapping_KPCA10');

%2
dim = 15;
tic
[mappedA_KPCA15, mapping_KPCA15] = compute_mapping_mod(data,'KPCA',dim);
toc
save ('KPCA15','mappedA_KPCA15','mapping_KPCA15');

%% HLLE - Hessian LLE
%getting the matrix: voxels X Descriptor using HLLE

dim = 10;

%0 
k = 10;
tic
[mappedA_HLLE10_10, mapping_HLLE10_10] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_10','mappedA_HLLE10_10','mapping_HLLE10_10');

%1
k = 12;
tic
[mappedA_HLLE10_12, mapping_HLLE10_12] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_12','mappedA_HLLE10_12','mapping_HLLE10_12');

%2
k = 14;
tic
[mappedA_HLLE10_14, mapping_HLLE10_14] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_14','mappedA_HLLE10_14','mapping_HLLE10_14');

%3
k = 16;
tic
[mappedA_HLLE10_16, mapping_HLLE10_16] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_16','mappedA_HLLE10_16','mapping_HLLE10_16');

%4
k = 18;
tic
[mappedA_HLLE10_18, mapping_HLLE10_18] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_18','mappedA_HLLE10_18','mapping_HLLE10_18');

%5
k = 20;
tic
[mappedA_HLLE10_20, mapping_HLLE10_20] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE10_20','mappedA_HLLE10_20','mapping_HLLE10_20');

dim = 15;

%0 
k = 10;
tic
[mappedA_HLLE15_10, mapping_HLLE15_10] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_10','mappedA_HLLE15_10','mapping_HLLE15_10');

%1
k = 12;
tic
[mappedA_HLLE15_12, mapping_HLLE15_12] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_12','mappedA_HLLE15_12','mapping_HLLE15_12');

%2
k = 14;
tic
[mappedA_HLLE15_14, mapping_HLLE15_14] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_14','mappedA_HLLE15_14','mapping_HLLE15_14');

%3
k = 16;
tic
[mappedA_HLLE15_16, mapping_HLLE15_16] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_16','mappedA_HLLE15_16','mapping_HLLE15_16');

%4
k = 18;
tic
[mappedA_HLLE15_18, mapping_HLLE15_18] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_18','mappedA_HLLE15_18','mapping_HLLE15_18');

%5
k = 20;
tic
[mappedA_HLLE15_20, mapping_HLLE15_20] = compute_mapping_mod(data,'HLLE',dim,k);
toc
save ('HLLE15_20','mappedA_HLLE15_20','mapping_HLLE15_20');