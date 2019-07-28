addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

threshold = 50;
dim       = 10;
k         = 10; 

dataInv  = reshape(im,size(im,1) * size(im,2) * size(im,3), size(im,4));
maxVals  = max(dataInv');
logicVec = (maxVals > threshold);
dataInvG = dataInv(logicVec,:);
tic
[mappedA_LEM, mapping_LEM] = compute_mapping_mod(dataInvG,'Laplacian',dim,k);
toc

K = 10;
f = mappedA_LEM;
rng(1); %for reproducibility
[idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations

idxRecon = zeros(1,size(dataInv,1));
idxRecon(logicVec == 1) = idx;
idxRecon(logicVec == 0) = max(idx)+1;
idx = idxRecon;

greyRecon = reshape(idxRecon,size(im,1), size(im,2), size(im,3));
imshow(greyRecon(:,:,20),[]);

% continue according to LEM_data_viewer