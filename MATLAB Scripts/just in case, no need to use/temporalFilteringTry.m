addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

dim = 10;
k   = 10; 
K   = 10;

dataInv  = reshape(im,size(im,1) * size(im,2) * size(im,3), size(im,4));
data = dataInv';

dataFiltered = zeros(size(data));
for iVoxel = 1:size(data,2)
    dataFiltered(:,iVoxel) = conv(data(:,iVoxel),BPF,'same');
end

dataFilteredInv = dataFiltered';
tic
[mappedA_LEM, mapping_LEM] = compute_mapping_mod(dataFilteredInv,'Laplacian',dim,k);
toc