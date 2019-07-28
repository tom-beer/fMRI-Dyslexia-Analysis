clear
clc
addpath(genpath('../Toolboxes'));
nifti = load_nii('../Data/typical/12/resting/wraresting.nii');
im = nifti.img;

data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time

%% Reviewing Run_02Aug results - LEM

%% load data
dim = 10; %dimension
k = 10; %nearest neighbors
result_struct = load(['..\Results\060816 Sat\LEM',num2str(dim),'_',num2str(k),'.mat']);
str = ['mappedA_LEM',num2str(dim),'_',num2str(k)];
LEM_mat = result_struct.(str);

%% view data
K_vec = [5,7,9,12]; % number of clusters   
slice_vec = [15,20,25,30,35,40];
t = 20;
figure()
% original
i = 1;
for slice = slice_vec
    original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
    slice_t = original_data(:,:,slice,t);
    subplot(length(K_vec) + 1,length(slice_vec),i)
    imshow(slice_t,[]);
    title(['slice ', num2str(slice)]);
    i = i + 1;
end
j = length(slice_vec);
for K = K_vec
    %clustered
    f = LEM_mat;
    rng(1); %for reproducibility
    [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
    i = 1;
    for slice = slice_vec
        data_clustered = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
        subplot(length(K_vec) + 1,length(slice_vec),j + i)
        imshow(data_clustered(:,:,slice),[]);
        suptitle(['LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
        if (slice == slice_vec(1))
            ylabel([num2str(K), ' Clusters']);
        end
        i = i + 1;
    end
    j = j + length(slice_vec);
end
set(gcf, 'Position',[381 81 1099 892]);
