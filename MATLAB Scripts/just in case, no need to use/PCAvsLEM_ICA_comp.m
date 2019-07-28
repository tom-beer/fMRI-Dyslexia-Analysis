close all; clc; clear;
%% Analysis options
analysisType  = 'LEM+ICA';
% analysisType  = 'PCA+ICA';
dim           = 10;
k             = 16; %number of nearest neighbors in LEM implementation
thresholdType = 'percentile'; % 'percentile' or 'value'
threshold     = 1; % z scores below this value will be zeroed
percentile    = 3;
plotResults   = true;
loadICAonLEM  = true; % true to load saved results, false to run ICA on LEM from scratch.
                      % note: ICA has convergence issues and many attempts fail.

%% Perform analysis
addpath(genpath('../Toolboxes'));

nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

switch analysisType
    case {'PCA+ICA', 'linear'}
        rawDataInv = reshape(im,size(im,1) * size(im,2) * size(im,3), size(im,4));
        data = rawDataInv'; %time*voxels
    case {'LEM+ICA', 'nonlinear'}
        result_struct = load(['..\Results\060816\LEM',num2str(dim),'_',num2str(k),'.mat']);
        str = ['mappedA_LEM',num2str(dim),'_',num2str(k)];
        LEM_mat = result_struct.(str);
        data = LEM_mat';
end
if ((loadICAonLEM) && strcmp(analysisType, 'LEM+ICA'))
    load(['..\Results\060816\ICAsig_LEM_',num2str(dim),'dim_',num2str(k),'k.mat']);
else
    [icasig, A, W] = fastica(data, 'lastEig', dim, 'interactivePCA', 'off' );
end
%% thresholding
components = cell(1,dim);
icasig_Z = transpose(zscore(icasig'));
for iC = 1:dim
    currComp = reshape(icasig_Z(iC,:), [size(im,1), size(im,2), size(im,3)]);
    if strcmp(thresholdType, 'percent')
        threshold = prctile(icasig_Z(iC,:),100-percentile);
    end
    currComp(currComp <= threshold) = 0;
    components{iC} = currComp;
end

%% all slice view
if plotResults
    for iC = 1:dim
        figure('units','normalized','outerposition',[0 0 1 1])
        slice_vec = 5:2:40;
        for iSlice = 1:numel(slice_vec)
            slice = slice_vec(iSlice);
            subplot(3,6,iSlice)
            tmp = components{iC};
            compIm = tmp(:,:,slice);
            compIm = compIm*10;
            original = im(:,:,slice,20);
            originalTmp = original;
            originalTmp = zscore(originalTmp(:));
            original = reshape(originalTmp, size(original));
            compIm(compIm == 0) = original(compIm == 0);
            imagesc(compIm);
            colormap(hot)
            title(['Slice ' num2str(slice)]);
        end
        suptitle([analysisType ' | Component ' num2str(iC) ' out of ' num2str(dim)]);
    end
    
    figure
    for iSlice = 1:numel(slice_vec)
        slice = slice_vec(iSlice);
        subplot(3,6,iSlice)
        imshow(im(:,:,slice,20),[]);
        title(['Slice ' num2str(slice)]);
    end
    suptitle('Original data');
end

