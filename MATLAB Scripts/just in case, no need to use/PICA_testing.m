
addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;
data_inv = reshape(im,size(im,1) * size(im,2) * size(im,3), size(im,4));
data = data_inv'; %time*voxels

dim = 10;

[icasig, A, W] = fastica(data, 'lastEig', dim, 'interactivePCA', 'off' );
% note: fastica for data_inv (voxels*time) -> memory error.
components = cell(1,dim);
for iC = 1:dim
    components{iC} = reshape(icasig(iC,:), [size(im,1), size(im,2), size(im,3)]);
end

%%
iSlice = 25;
figure(1)
for iC  = 1:dim;
    subplot(2,5,iC)
    tmp = components{iC};
    imshow(tmp(:,:,iSlice),[]);
end
suptitle('10 Independent Components | slice 25')
