%this scrip is checking the option to run 10 slices analysis (instead if the whole brain (46 slices) 
%using: 
%LEM - 'Laplacian' - with k - *DONE*.
%LLE - 'LLE' - with k - *DONE*.
%DM -  'DM' - no k
%HLLE - Hessian LLE - 'HLLE' - with k 
%X KPCA - Kernel PCA - 'KPCA' - no k - *FAILD* too slow. 3.5 days with no result.
%X LTSA - Local tangent space alignment - 'LTSA' - with k -> *FAILED*.The shifted operator is singular. The shift is an eigenvalue.Try to use some other shift please. 

%% flags
smooth = 1; %smoothed data or not
save_data = 1;
type = 'typical'; %typical or dyslexic
algorithms = ['Laplacian'];
algorithms = cellstr(algorithms);

%% loading data
clc
close all
addpath(genpath('../Toolboxes'));

if strcmp(type,'typical') && smooth == 0
    nifti = load_nii('../Data/typical/12/resting/wraresting.nii'); %typical
    im = nifti.img;
elseif strcmp(type,'dyslexic') && smooth == 0
    nifti = load_nii('../Data/dyslexic/9/resting/wraresting.nii'); %dyslexic
    im = nifti.img;
elseif strcmp(type,'typical') && smooth == 1
    nifti = load_nii('../Data/typical/12/resting/swraresting.nii'); %typical - smoothed
    im = nifti.img;  
end

%10 slices only
im = im(:,:,21:30,:);
data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time

%% non-linear part - checking all algorithms in list
for algi = 1:length(algorithms)
    alg = algorithms(algi);
    dim = 10; k = 10;
    disp(['Calculating ' strjoin(alg) '...'])
    try
        if strcmp(alg,'DM') || strcmp(alg,'KPCA')
            name_string = strjoin(strcat('mapped_', alg, '_dim', num2str(dim)));
            [mappedA,~] = compute_mapping_mod(data,strjoin(alg),dim);
            assignin('base', name_string, mappedA)
        else
            name_string = strjoin(strcat('mapped_', alg, '_dim', num2str(dim), '_k', num2str(k)));
            [mappedA,~] = compute_mapping_mod(data,strjoin(alg),dim,k);
            assignin('base', name_string, mappedA)
        end
    catch
        disp(['Failed to run ' strjoin(alg) '.']); 
        continue;
    end
    disp(['Done calculating ' strjoin(alg) '.'])
    disp('************************************');
end

%% clustering & viewing

%alg = 'LLE';
alg = 'LEM';
% load relevant data - in here: C:\Users\chenco\Documents\MATLAB\MRI Project\Results\10Slices_rawData

if strcmp(alg,'LLE')
    result_struct = mapped_LLE_dim10_k10;
elseif strcmp(alg,'LEM') 
    result_struct = mapped_Laplacian_dim10_k10;
end

K_vec = [10 15 20 25]; % number of clusters   
t = 20;
% view1
slice_vec = 21:30;
figure()
% original data
i = 1;

for slice = slice_vec
    original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
    slice_t = original_data(:,:,i,t);
    subplot(length(K_vec) + 1,length(slice_vec),i)
    imagesc(slice_t);
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);       
    title(['slice ', num2str(slice)]);
    if (slice == slice_vec(1))
        ylabel('Original');
    end
    i = i + 1;
end

j = length(slice_vec);
for K = K_vec
    %clustered
    f = result_struct;
    rng(1); %for reproducibility
    [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
    i = 1;
    for slice = slice_vec
        data_clustered = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
        subplot(length(K_vec) + 1,length(slice_vec),j + i)
        imagesc(data_clustered(:,:,i),[min(min(min(data_clustered))) max(max(max(data_clustered)))]);
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);                
        if (slice == slice_vec(1))
            ylabel([num2str(K), ' Clusters']);
        end
        i = i + 1;
    end
    j = j + length(slice_vec);
end

if strcmp(type,'typical')
suptitle(['10 Slices - Typical | ' alg ' - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
elseif strcmp(type,'dyslexic')
suptitle(['10 Slices - Dyslexic | ' alg ' - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
elseif strcmp(type,'typical_s')
suptitle(['10 Slices - Typical Smoothed | ' alg ' - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);                        
end

set(gcf,'Position',[386 291 1113 603]);

if strcmp(type,'typical') && save_data && smooth == 0
saveas(gcf,['10slices_typical_' alg '_dim' num2str(dim) '_k' num2str(k) '_clusters.png']);
elseif strcmp(type,'dyslexic') && save_data
saveas(gcf,['10slices_dyslexic_' alg '_dim' num2str(dim) '_k' num2str(k) '_clusters.png']);
elseif strcmp(type,'typical') && save_data && smooth == 1
saveas(gcf,['10slices_typical_smooth_' alg '_dim' num2str(dim) '_k' num2str(k) '_clusters.png']);
end