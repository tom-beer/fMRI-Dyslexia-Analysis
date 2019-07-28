%%testing spatial ICA on nii files

%% functional data
mat = load_nii('NIFTI_Original_typical_12_resting\20120814.12.1_WIP_Resting_State_SENSE_9_1.nii');

% mat.img size: 64 64 37 180
% each image has 64*64 pixles, 37 slices, 180 time points.
% actually: 64*64*37 voxels or time series.
% to get 2D image for a specific slice s in a specific time point t:

% each time series for each voxel whould be:
% mat.img(m,n,s,:)

% all time series - 
% reshape the 64*64*37*180 4D matrix into 151552*180 2D matrix - 
% each row for each voxel.

%% Anatomic data

anatomic = load_nii('NIFTI_Original_typical_12_resting\20120814.12.1_WIP_T1W_3D_IRCstandard32_SENSE_3_1.nii');
%anatomic dimensions: 192 256 256 ; (256 slices) 

%% Data presentation 
close all
figure(1)
imshow(anatomic.img(:,:,200),[]);
suptitle('Structural image');
title('slice 200/256');

im18 = mat.img(:,:,18,90);
im18(38,46) = 1;
figure(2)
subplot(1,3,1)
imshow(im18,[]);
suptitle('Functional image - time point 90/180');
title('slice 18/37'); 

im21 = mat.img(:,:,21,90);
im21(38,46) = 1;
subplot(1,3,2)
imshow(im21,[]);
title('slice 21/37'); 

im25 = mat.img(:,:,25,90);
im25(38,46) = 1;
subplot(1,3,3)
imshow(im25,[]);
title('slice 25/37'); 

time1 = squeeze(mat.img(38,46,18,:));
time2 = squeeze(mat.img(38,46,21,:));
time3 = squeeze(mat.img(38,46,25,:));

figure(3)
subplot(3,1,1)
plot(time1);
ylim([400 1100]);
title('slice 18')
subplot(3,1,2)
plot(time2);
ylim([400 1100]);
title('slice 21')
subplot(3,1,3)
plot(time3);
ylim([400 1100]);
title('slice 25')

c18_25 = corr(time1,time3)
c18_21 = corr(time1,time2)
c21_25 = corr(time2,time3)

%% more exmaples for fMRI data

corr_mat1 = ones(64,64);
S1 = 27; 
for i = 1:64
    for j = 1:64
       corr_mat1(i,j) = corr(squeeze(mat.img(35,24,S1,:)),squeeze(mat.img(i,j,S1,:)));
    end
end
corr_mat1=abs(corr_mat1);
corr_mat1((corr_mat1 < 0.1) | isnan(corr_mat1))=0;
figure(4)
imshow(mat.img(:,:,S1,90),[])
figure(5)
surf(corr_mat1)
xlim([0 64]);
ylim([0 64]);

corr_mat2 = ones(64,64);
S2 = 18; %27
for i = 1:64
    for j = 1:64
       corr_mat2(i,j) = corr(squeeze(mat.img(35,24,S2,:)),squeeze(mat.img(i,j,S2,:)));
    end
end
corr_mat2=abs(corr_mat2);
corr_mat2((corr_mat2 < 0.1) | isnan(corr_mat2))=0;
figure(6)
imshow(mat.img(:,:,S2,90),[])
figure(7)
surf(corr_mat2)
xlim([0 64]);
ylim([0 64]);