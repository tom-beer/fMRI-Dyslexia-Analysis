%exploring LLE
clear 
addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;
% 
% spatial_data = reshape(im,size(im,4),[]); % size is 53*63*46*180
% temporal_data = spatial_data';

partial_spatial_data = reshape(im(:,:,1:30,:),size(im,4),[]);
partial_temporal_data = partial_spatial_data';

[mappedA, mapping] = compute_mapping_mod(partial_temporal_data, 'LLE', 10,16);

% [mappedA, mapping] = compute_mapping(partial_temporal_data, 'LLE', 25);
% comp1 = reshape(mappedA(:,1),);