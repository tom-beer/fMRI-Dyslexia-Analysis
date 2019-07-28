function LEM_groupAnalysis_viewer (type, method, save_data, view, folder)
% view saved data with deferent parameters
% type - patient type: typical or dyslexic; type = 'typical'
% view - figures configuration:
% 1 - all clusters in one figure; view = 2;
% 2 - separated figures
% save_data flag - save figures as .png; save_data = 1;
% folder = '..\Results\GroupAnalysis_Results';

clc
close all
addpath(genpath('../Toolboxes'));

%% Reviewing group results - LEM

% load data
nifti = load_nii([folder '\swuresting_' type '_original.nii']); %typical
im = nifti.img;
data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time

dim = 20;
k = 10;
if strcmp(type,'typical') && strcmp (method,'TC')
    result_struct = load([folder '\LEM20_10_control_TemporalConcat.mat']);
    %result_struct = load([folder '\LEM20_10_control_TemporalConcat_sigma15.mat']);
    %result_struct = load([folder '\LEM20_10_control_TemporalConcat_sigma05.mat']);    
elseif strcmp(type,'dyslexic') && strcmp (method,'TC')
    result_struct = load([folder '\LEM20_10_dys_TemporalConcat.mat']);  
elseif strcmp(type,'typical') && strcmp (method,'ME')
    %result_struct = load([folder '\LEM20_10_control_meanEigen_10its_l100.mat']); 
    %result_struct = load([folder '\LEM20_10_control_meanEigen_10its_l500.mat']);     
    result_struct = load([folder '\LEM20_10_control_meanEigen_10its_l1000.mat']);     
elseif strcmp(type,'dyslexic') && strcmp (method,'ME')
    %result_struct = load([folder '\LEM20_10_dys_meanEigen_10its_l100.mat']); 
    %result_struct = load([folder '\LEM20_10_dys_meanEigen_10its_l500.mat']);     
    result_struct = load([folder '\LEM20_10_dys_meanEigen_10its_l1000.mat']); 
end

str = ['mappedA_LEM',num2str(dim),'_',num2str(k)];
LEM_mat = result_struct.(str);   
K_vec = [10 15 20 25 30 35]; % number of clusters   
t = 20;

% view data 1 - all clusters - one figure
if view == 1 
    slice_vec = [15,20,25,30,35,40];
    figure()
    % original data
    i = 1;
    for slice = slice_vec
        original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
        slice_t = original_data(:,:,slice + 25,t);
        subplot(length(K_vec) + 1,length(slice_vec),i)
        %imshow(slice_t,[]);
        imagesc(slice_t);
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        title(['slice ', num2str(slice+25)]);
        if (slice == slice_vec(1))
            ylabel('Original');
        end
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
            data_dimi = reshape(idx,size(original_data,1),size(original_data,2),46);
            subplot(length(K_vec) + 1,length(slice_vec),j + i)
            imagesc(data_dimi(:,:,slice),[min(min(min(data_dimi))) max(max(max(data_dimi)))]);
            set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
            colormap jet;
            if (slice == slice_vec(1))
                ylabel([num2str(K), ' Clusters']);
            end
            i = i + 1;
        end
        j = j + length(slice_vec);
    end
    set(gcf, 'Position',[381 81 1099 892]);
    if strcmp(type,'typical')
        suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
    elseif strcmp(type,'dyslexic')
        suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
    elseif strcmp(type,'typical_s')
        suptitle(['Typical_smoothed | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);       
    elseif strcmp(type,'typical_s_corr')
        suptitle(['Typical_smoothed | LEMcorr - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);       
    end  

    %saveas(gcf,['LEM_dim' num2str(dim) '_k' num2str(k) '.png']);
    if strcmp(type,'typical') && save_data
        saveas(gcf,['typical_groupLEM_dim' num2str(dim) '_k' num2str(k) '.png']);
    elseif strcmp(type,'dyslexic') && save_data
        saveas(gcf,['dyslexic_groupLEM_dim' num2str(dim) '_k' num2str(k) '.png']);         
    end
    
elseif view == 2  
    % view2 - separated clusters 
    % (figure for each cluster - containing all slices)
    slice_vec = 5:2:40;
    figure()
    % original data
    i = 1;
    for slice = slice_vec
        original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
        slice_t = original_data(:,:,slice,t);
        subplot(3,6,i) % length(slice_vec) = 18
        %imshow(slice_t,[]);
        imagesc(slice_t);
        title(['slice ', num2str(slice)]);
        i = i + 1;
    end
    suptitle('Original Slices');
    set(gcf, 'Position',[386 291 1113 603]);            
    if strcmp(type,'typical') && save_data
        saveas(gcf,'typical_original.png');
    elseif strcmp(type,'dyslexic') && save_data
        saveas(gcf,'dyslexic_original.png');            
    end            
    % all clusters
    for K = K_vec   %number of clusters            
        %clustering
        f = LEM_mat;
        rng(1); %for reproducibility
        [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
        %view each cluster
        data_dimi = reshape(idx,53,63,52);
        for i = 1:K                
            j = 1;
            data_clustered_i = zeros(size(data_dimi));
            data_clustered_i(data_dimi == i) = 1;
            figure() %for each cluster                    
            for slice = slice_vec
                subplot(3,6,j);
                %imshow(data_clustered_i(:,:,slice),[]); %gray scale
                imagesc(data_clustered_i(:,:,slice)); %colored
                title(['slice ', num2str(slice)]); 
                j = j + 1;
            end
            if strcmp(type,'typical')
                suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
            elseif strcmp(type,'dyslexic')
                suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
            end
            set(gcf,'Position',[386 291 1113 603]);
            if strcmp(type,'typical') && save_data
                saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);
            elseif strcmp(type,'dyslexic') && save_data
                saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);                 
            end
        end  
        close all
    end
    
elseif view == 3 %no clustering, only voxels values after dimension reduction
    slice_vec = [15,20,25,30,35,40];
    figure()
    % original data
    i = 1;
    for slice = slice_vec
        original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
        slice_t = original_data(:,:,slice + 25,t);
        subplot(length(K_vec) + 1,length(slice_vec),i)
        imagesc(slice_t);
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
        title(['slice ', num2str(slice+25)]);
        if (slice == slice_vec(1))
            ylabel('Original');
        end
        i = i + 1;
    end
    j = length(slice_vec);
    dim_vec = 16:20; %up to 20
    for dimi = dim_vec
        %dimensions
        i = 1;
        for slice = slice_vec
            data_dimi = reshape(LEM_mat(:,dimi),79,95,46);
            subplot(5 + 1,length(slice_vec),j + i)
            imagesc(data_dimi(:,:,slice),[min(min(min(data_dimi))) max(max(max(data_dimi)))]);
            set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);            
            colormap hsv(32);
            if (slice == slice_vec(1))
                ylabel(['dim #' num2str(dimi)]);
            end
            i = i + 1;
        end
        j = j + length(slice_vec);
    end
    if strcmp(type,'typical')
        suptitle(['Typical - Group Analysis (18 studies) | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
    elseif strcmp(type,'dyslexic')
        suptitle(['Dyslexic - Group Analysis (18 studies) | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);                    
    end  
    set(gcf, 'Position',[381 81 1099 892]);

    %saving figure
    if strcmp(type,'typical') && save_data
        saveas(gcf,['typical_' method '_groupLEM_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
    elseif strcmp(type,'dyslexic') && save_data
        saveas(gcf,['dyslexic_' method '_groupLEM_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
    end

    elseif view == 4 %no clustering, only voxels values after dimension reduction
    slice = 50;    
    %dim_vec = 1:20; %all
    %dim_vec = [4 6 10 11 12 15 16 18]; %typical TC
    %dim_vec = [5 7 9 10 12 11 15 18]; %dyslexic TC
    dim_vec = [5 6 9 10 11 15 17 18]; %typical&dyslexic ME

    figure()
    % original data
        original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
        slice_t = original_data(:,:,slice,t);
        subplot(1,1+length(dim_vec),1)
        imagesc(slice_t);
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
        ylabel('Original');
        title(['slice ', num2str(slice)]);
    i = 1;
    for dimi = dim_vec
        %dimensions
            data_dimi = reshape(LEM_mat(:,dimi),79,95,46);
            subplot(1,1+length(dim_vec),1 + i)
            imagesc(data_dimi(:,:,slice-25),[min(min(min(data_dimi))) max(max(max(data_dimi)))]);
            set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);            
            colormap hsv(32);
            title(['dim #' num2str(dimi)]);
            i = i+1;
    end

    set(gcf,'Position',[339 201 1224 154]);
    if strcmp(type,'typical')
        suptitle(['Typical  |  Slice ' num2str(slice)]);
    elseif strcmp(type,'dyslexic')
        suptitle(['Dyslexic  |  Slice ' num2str(slice)]);
    end  
    
    %saving figure
    if strcmp(type,'typical') && save_data
        saveas(gcf,['typical_' method '_groupLEM_dim' num2str(dim) '_k' num2str(k) '_Slice' num2str(slice) '.png']);
    elseif strcmp(type,'dyslexic') && save_data
        saveas(gcf,['dyslexic_' method '_groupLEM_dim' num2str(dim) '_k' num2str(k) '_Slice' num2str(slice) '.png']);
    end    
end
disp('Done.');
