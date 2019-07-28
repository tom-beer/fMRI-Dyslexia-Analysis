clear all
addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;
% 
gift