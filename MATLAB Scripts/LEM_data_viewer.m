function LEM_data_viewer (type, save_data, view)
% view saved data with deferent parameters
% type - patient type: typical or dyslexic; type = 'typical'
% view - figures configuration:
% 1 - all clusters in one figure; view = 2;
% 2 - separated figures
% save_data flag - save figures as .png; save_data = 1;

clc
close all
addpath(genpath('../Toolboxes'));

if strcmp(type,'typical')
    nifti_t = load_nii('../Data/typical/12/resting/wraresting.nii'); %typical
    im_typical = nifti_t.img;
    im = im_typical;
elseif strcmp(type,'dyslexic')
    nifti_d = load_nii('../Data/dyslexic/9/resting/wraresting.nii'); %dyslexic
    im_dyslexic = nifti_d.img;
    im = im_dyslexic;
elseif strcmp(type,'typical_s') || strcmp(type,'typical_s_corr')
    nifti_t_s = load_nii('../Data/typical/12/resting/swraresting.nii'); %typical - smoothed
    im_typical_s = nifti_t_s.img;
    im = im_typical_s;    
end

data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time

%% Reviewing Run_02Aug results - LEM

% load data
dim_vec = [10 15]; %dimension
dim_vec = 10;
k_vec = 10:2:20; %nearest neighbors
k_vec = 10;
for dim = dim_vec;
    for k = k_vec
        if strcmp(type,'typical')
            result_struct = load(['..\Results\LEM_rawData\typical\LEM',num2str(dim),'_',num2str(k),'.mat']);
        elseif strcmp(type,'dyslexic') 
            result_struct = load(['..\Results\LEM_rawData\dyslexic\dys_LEM',num2str(dim),'_',num2str(k),'.mat']);
        elseif strcmp(type,'typical_s')
            result_struct = load(['..\Results\LEM_rawData\typical_smooth\typ_s_LEM',num2str(dim),'_',num2str(k),'.mat']);
        elseif strcmp(type,'typical_s_corr')
            result_struct = load(['..\Results\LEM_rawData\typical_smooth\typ_s_LEMcorr',num2str(dim),'_',num2str(k),'.mat']);        
        end
        if strcmp(type,'typical_s_corr')
            str = ['mappedA_LEMCorr',num2str(dim),'_',num2str(k)];
            LEM_mat = result_struct.(str);
        else
            str = ['mappedA_LEM',num2str(dim),'_',num2str(k)];
            LEM_mat = result_struct.(str);
        end        
        K_vec = [10 15 20 25]; % number of clusters   
        t = 20;
        
        if view == 1 % view data 1 - all clusters - one figure
            slice_vec = [15,20,25,30,35,40];
            figure()
            % original data
            i = 1;
            for slice = slice_vec
                original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
                slice_t = original_data(:,:,slice,t);
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
                f = LEM_mat;
                rng(1); %for reproducibility
                [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
                i = 1;
                for slice = slice_vec
                    data_dimi = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
                    subplot(length(K_vec) + 1,length(slice_vec),j + i)
                    %imshow(data_clustered(:,:,slice),[]);
                    imagesc(data_dimi(:,:,slice),[min(min(min(data_dimi))) max(max(max(data_dimi)))]);            
                    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
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
                saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '.png']);
            elseif strcmp(type,'dyslexic') && save_data
                saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '.png']);
            elseif strcmp(type,'typical_s') && save_data
                saveas(gcf,['typical_smoothed_LEM_dim' num2str(dim) '_k' num2str(k) '.png']);
            elseif strcmp(type,'typical_s_corr') && save_data
                saveas(gcf,['typical_smoothed_LEMcorr_dim' num2str(dim) '_k' num2str(k) '.png']);            
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
                set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
                title(['slice ', num2str(slice)]);
                i = i + 1;
            end
            suptitle('Original Slices');
            set(gcf, 'Position',[386 291 1113 603]);            
            if strcmp(type,'typical') && save_data
                saveas(gcf,'typical_original.png');
            elseif strcmp(type,'dyslexic') && save_data
                saveas(gcf,'dyslexic_original.png');
            elseif strcmp(type,'typical_s') && save_data
                saveas(gcf,'typical_smoothed_original.png');                
            end            
            % all clusters
            for K = K_vec   %number of clusters            
                %clustering
                f = LEM_mat;
                rng(1); %for reproducibility
                [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
                %view each cluster
                data_dimi = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
                for i = 1:K                
                    j = 1;
                    data_clustered_i = zeros(size(data_dimi));
                    data_clustered_i(data_dimi == i) = 1;
                    figure() %for each cluster                    
                    for slice = slice_vec
                        subplot(3,6,j);
                        %imshow(data_clustered_i(:,:,slice),[]); %gray scale
                        imagesc(data_clustered_i(:,:,slice)); %colored
                        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
                        title(['slice ', num2str(slice)]); 
                        j = j + 1;
                    end
                    if strcmp(type,'typical')
                        suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
                    elseif strcmp(type,'dyslexic')
                        suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
                    elseif strcmp(type,'typical_s')
                        suptitle(['Typical Smoothed | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);                        
                    end
                    set(gcf,'Position',[386 291 1113 603]);
                    if strcmp(type,'typical') && save_data
                        saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);
                    elseif strcmp(type,'dyslexic') && save_data
                        saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);
                    elseif strcmp(type,'typical_s') && save_data
                        saveas(gcf,['typical_smooth_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);                   
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
                slice_t = original_data(:,:,slice,t);
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
            dim_vec = 6:10; %or 6:10
            for dimi = dim_vec
                %dimensions
                i = 1;
                for slice = slice_vec
                    data_dimi = reshape(LEM_mat(:,dimi),size(original_data,1),size(original_data,2),size(original_data,3));
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
                suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
            elseif strcmp(type,'dyslexic')
                suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
            elseif strcmp(type,'typical_s')
                suptitle(['Typical Smoothed | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);                        
            elseif strcmp(type,'typical_s_corr')
                suptitle(['Typical Smoothed | LEMcorr - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);                        
            end  
            set(gcf, 'Position',[381 81 1099 892]);
            
            %saving figure
            if strcmp(type,'typical') && save_data
                saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
            elseif strcmp(type,'dyslexic') && save_data
                saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
            elseif strcmp(type,'typical_s') && save_data
                saveas(gcf,['typical_smoothed_LEM_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
            elseif strcmp(type,'typical_s_corr') && save_data
                saveas(gcf,['typical_smoothed_LEMcorr_dim' num2str(dim) '_k' num2str(k) '_noClustering' num2str(dim_vec(1)) '-' num2str(dim_vec(end)) '.png']);
            end
        end
    end
    disp('Done.');
end 