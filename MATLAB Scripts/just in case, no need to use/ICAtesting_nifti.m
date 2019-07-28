%%testing spatial ICA on nii files

%% functional data
mat = load_nii('NIFTI_Original_typical_12_resting\20120814.12.1_WIP_Resting_State_SENSE_9_1.nii');

% mat.img size: 64 64 37 180
% each image has 64*64 pixles, 37 slices, 180 time points.
% actually: 64*64*37 voxels or time series.
% to get 2D image for a specific slice s in a specific time point t:

% each time series for each voxel whould be:
% mat.img(m,n,s,:)

% lets take 2 time series for 2 different voxels:
a = squeeze(mat.img(32,32,15,:));
b = squeeze(mat.img(32,32,1,:));

data = [a b]';

% all time series - 
% reshape the 64*64*37*180 4D matrix into 151552*180 2D matrix - 
% each row for each voxel.
voxels_time = reshape(mat.img, 64*64*37,180); % 151522 X 180
all_data = voxels_time;

partial = all_data(150000:150010,:);
%fasticag;
%[ICs, A, W] = fastica(data);

%% Anatomic data

anatomic = load_nii('NIFTI_Original_typical_12_resting\20120814.12.1_WIP_T1W_3D_IRCstandard32_SENSE_3_1.nii');
%anatomic dimensions: 192 256 256 ; (256 slices) 

%% FastICA (data according to convention observation=row)

data = squeeze(mat.img(:,:,15,:));
nTRs = 180; %number of timepoints in the fMRI timecourse
nComps = 80; %number of groundtruth components
iS = 64; %image size
[icasig, A, W] = fastica(reshape(data,[iS*iS nTRs]), ...
 'lastEig', 10,'numOfIC', nComps);

%show recovered components
for iter = 1:nComps,
    C{iter} = reshape(icasig(iter,:),[iS iS]);
    C{iter} = (C{iter} - min(min(C{iter})))/(max(max(C{iter})) - min(min(C{iter})));
end
figure();   
set(gcf,'Name','ICA results');
subplot(1,3,1); imagesc(C{1});
title('IC #1');
subplot(1,3,2); imagesc(C{2});
title('IC #2');
subplot(1,3,3); imagesc(C{3});
title('IC #3');
