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

nifti_t = load_nii('../Data/typical/12/resting/wraresting.nii'); %typical
im_typical = nifti_t.img;

nifti_d = load_nii('../Data/dyslexics/9/resting/wraresting.nii'); %dyslexics
im_dyslexic = nifti_d.img;

if isequal(type,'typical')
    im = im_typical;
else
    im = im_dyslexic;
end 
data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time   

%% Reviewing Run_02Aug results - LEM

% load data
dim_vec = [10 15]; %dimension
k_vec = 10:2:20; %nearest neighbors
for dim = dim_vec;
    for k = k_vec
        if isequal(type,'typical')
            result_struct = load(['..\Results\LEM\typical\LEM',num2str(dim),'_',num2str(k),'.mat']);
        else 
            result_struct = load(['..\Results\LEM\dyslexic\LEM',num2str(dim),'_',num2str(k),'.mat']);
        end 
        str = ['mappedA_LEM',num2str(dim),'_',num2str(k)];
        LEM_mat = result_struct.(str);
        K_vec = [15 25]; % number of clusters   
        t = 20;
        if view == 1
            % view data 1 - all clusters - one figure
            slice_vec = [15,20,25,30,35,40];
            figure()
            % original data
            i = 1;
            for slice = slice_vec
                original_data = reshape(data,size(im,1),size(im,2),size(im,3),size(im,4));
                slice_t = original_data(:,:,slice,t);
                subplot(length(K_vec) + 1,length(slice_vec),i)
                %imshow(slice_t,[]);
                imagesc(slice_t);
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
                    data_clustered = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
                    subplot(length(K_vec) + 1,length(slice_vec),j + i)
                    %imshow(data_clustered(:,:,slice),[]);
                    imagesc(data_clustered(:,:,slice));
                    if isequal(type,'typical')
                        suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
                    else
                        suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k)']);
                    end                
                    if (slice == slice_vec(1))
                        ylabel([num2str(K), ' Clusters']);
                    end
                    i = i + 1;
                end
                j = j + length(slice_vec);
            end
            set(gcf, 'Position',[381 81 1099 892]);
            %saveas(gcf,['LEM_dim' num2str(dim) '_k' num2str(k) '.png']);
            if isequal(type,'typical') && save_data
                saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '_c.png']);
            elseif isequal(type,'dyslexic') && save_data
                saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '_c.png']);
            end
        else  
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
            if isequal(type,'typical') && save_data
                saveas(gcf,'typical_original.png');
            elseif isequal(type,'dyslexic') && save_data
                saveas(gcf,'dyslexic_original.png');
            end            
            % all clusters
            for K = K_vec   %number of clusters            
                %clustering
                f = LEM_mat;
                rng(1); %for reproducibility
                [idx,~] = kmeans(f,K); %idx - clustering, C (2nd param)- centroid locations
                %view each cluster
                data_clustered = reshape(idx,size(original_data,1),size(original_data,2),size(original_data,3));
                for i = 1:K                
                    j = 1;
                    data_clustered_i = zeros(size(data_clustered));
                    data_clustered_i(data_clustered == i) = 1;
                    figure() %for each cluster                    
                    for slice = slice_vec
                        subplot(3,6,j);
                        %imshow(data_clustered_i(:,:,slice),[]); %gray scale
                        imagesc(data_clustered_i(:,:,slice)); %colored
                        title(['slice ', num2str(slice)]); 
                        j = j + 1;
                    end
                    if isequal(type,'typical')
                        suptitle(['Typical | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
                    else
                        suptitle(['Dyslexic | LEM - ',num2str(dim),' dimensions,  ',num2str(k),' nearest neighbors (k) | ',num2str(K),' Clusters | cluster #', num2str(i)]);
                    end
                    set(gcf,'Position',[386 291 1113 603]);
                    if isequal(type,'typical') && save_data
                        saveas(gcf,['typical_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);
                    elseif isequal(type,'dyslexic') && save_data
                        saveas(gcf,['dyslexic_LEM_dim' num2str(dim) '_k' num2str(k) '_' num2str(K) 'clusters_cluster' num2str(i) '.png']);
                    end
                end  
                close all
            end
        end
    end
    disp('Done.');
end 