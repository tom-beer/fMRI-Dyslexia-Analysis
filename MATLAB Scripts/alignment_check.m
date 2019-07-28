clc
close all
addpath(genpath('../Toolboxes'));

nifti = load_nii('../Data/typical/12/resting/swraresting.nii'); %typical - smoothed
im = nifti.img;

%one specific slice - one study
slice = 25;
for t = 1:180
    figure(1)
    imagesc(im(:,:,slice,t));
    title(['t = ' num2str(t)]);
    pause(0.2)
end

%specific slice - 5 studies

nifti = load_nii('../Data/Alignment Check/swrresting24.nii');
im1 = nifti.img;
nifti = load_nii('../Data/Alignment Check/swrresting25.nii');
im2 = nifti.img;

nifti = load_nii('../Data/Alignment Check/swrresting9.nii');
im9 = nifti.img;
nifti = load_nii('../Data/Alignment Check/swrresting12.nii');
im12 = nifti.img;


nifti = load_nii('../Data/Alignment Check/wmanatomical9.nii');
im9_ana = nifti.img;
nifti = load_nii('../Data/Alignment Check/wmanatomical12.nii');
im12_ana = nifti.img;


slice_vec = [20 30 40];
t = 20;

% figure(3)
% imagesc(im1(:,:,slice,t));
% title(['Typical 24 Slice ' num2str(slice)]);
% figure(4)
% imagesc(im2(:,:,slice,t));
% title(['Typical 25 Slice ' num2str(slice)]);

i=1;
figure(1)
for slice = slice_vec
    subplot(3,2,i)
    imagesc(im9(:,:,slice,t));
    title(['Study 9 Slice ' num2str(slice)]);
    subplot(3,2,i+1)
    imagesc(im12(:,:,slice,t));
    title(['Study 12 Slice ' num2str(slice)]);
    i = i+2;
end


i=1;
figure(2)
for slice = slice_vec
    subplot(3,2,i)
    imagesc(im9_ana(:,:,slice));
    title(['Study 9 - Anatomical Slice ' num2str(slice)]);
    subplot(3,2,i+1)
    imagesc(im12_ana(:,:,slice));
    title(['Study 12 - Anatomical Slice ' num2str(slice)]);
    i = i+2;
end

slice_vec = [1:10:156 156];
i=1;
figure(1)
for slice = slice_vec
    subplot(2,length(slice_vec),i)
    imagesc(im9(:,:,slice,t));
    title(['Slice ' num2str(slice)]);
    if i == 1 
        ylabel('Study 9');
    end
    subplot(2,length(slice_vec),i+length(slice_vec))
    imagesc(im12(:,:,slice,t));
    title(['Slice ' num2str(slice)]);
    if i == 1 
        ylabel('Study 12');
    end
    i = i+1;
end


i=1;
figure(2)
for slice = slice_vec
    subplot(3,length(slice_vec),i)
    imagesc(im9_ana(:,:,slice));
    title(['Slice ' num2str(slice)]);
    if i == 1 
        ylabel('Study 9');
    end
    subplot(3,length(slice_vec),i+length(slice_vec))
    imagesc(im12_ana(:,:,slice));
    title(['Slice ' num2str(slice)]);
    if i == 1 
        ylabel('Study 12');
    end 
    subplot(3,length(slice_vec),i+2*length(slice_vec))
    imagesc(im12_ana(:,:,slice)-im9_ana(:,:,slice));
    title(['Slice ' num2str(slice)]);
    if i == 1 
        ylabel('diff');
    end       
    i = i+1;
end

%control - new data from Tzipi
control_vec1 = [11 12 16 17 18 24 25 30 31];
control_vec2 = [38 40 41 42 43 63 66 67 77 101];
slice_vec = [10 20 30 40 50]; 
figure()
for i = 1:length(control_vec1)
    nifty = load_nii(['F:\new DATA from Tzipi\Test1\control\'...
            num2str(control_vec1(i)) '\resting\swrresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(control_vec1),length(slice_vec),j + (i-1)*length(slice_vec));        
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(control_vec1(i))]);
        end
    end
end
suptitle('Control Studies 1');

figure()
for i = 1:length(control_vec2)
    nifty = load_nii(['F:\new DATA from Tzipi\Test1\control\'...
            num2str(control_vec2(i)) '\resting\swrresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(control_vec2),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(control_vec2(i))]);
        end
    end
end
suptitle('Control Studies 2');

%%

%dyslexics - new data from Tzipi
dys_vec1 = [1 2 4 5 8 9 13 15 28 29];
dys_vec2 = [32 46 50 51 56 60 62 65 69 71 104];
slice_vec = [10 20 30 40 50]; 
figure()
for i = 1:length(dys_vec1)
    nifty = load_nii(['F:\new DATA from Tzipi\Test1\dys\'...
            num2str(dys_vec1(i)) '\resting\swrresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));
    for j = 1:length(slice_vec)
        subplot(length(dys_vec1),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(dys_vec1(i))]);
        end
    end
end
suptitle('Dyslexics Studies 1');

figure()
for i = 1:length(dys_vec2)
    nifty = load_nii(['F:\new DATA from Tzipi\Test1\dys\'...
            num2str(dys_vec2(i)) '\resting\swrresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(dys_vec2),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
        if j == 1
            ylabel(['#' num2str(dys_vec2(i))]);
        end
    end
end
suptitle('Dyslexics Studies 2');

%% new aligned data 
%control - new data from Tzipi
control_vec1 = [11 12 16 17 18 24 25 30 31];
control_vec2 = [38 40 41 42 43 63 66 67 77];
slice_vec = [25 30 40 50 60 70]; 
figure()
for i = 1:length(control_vec1)
    nifty = load_nii(['D:\aligned data\resting_control\'...
            num2str(control_vec1(i)) '\resting\swuresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(control_vec1),length(slice_vec),j + (i-1)*length(slice_vec));        
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(control_vec1(i))]);
        end
    end
end
suptitle('Control Studies 1');

figure()
for i = 1:length(control_vec2)
    nifty = load_nii(['D:\aligned data\resting_control\'...
            num2str(control_vec2(i)) '\resting\swuresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(control_vec2),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(control_vec2(i))]);
        end
    end
end
suptitle('Control Studies 2');

%dyslexics - new data from Tzipi
dys_vec1 = [1 2 4 5 8 9 13 15 28 29];
dys_vec2 = [32 46 50 51 56 60 62 65 69 71 104];
slice_vec = [25 30 40 50 60 70]; 
figure()
for i = 1:length(dys_vec1)
    nifty = load_nii(['D:\aligned data\resting_dys\'...
            num2str(dys_vec1(i)) '\resting\swuresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));
    for j = 1:length(slice_vec)
        subplot(length(dys_vec1),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end        
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);        
        if j == 1
            ylabel(['#' num2str(dys_vec1(i))]);
        end
    end
end
suptitle('Dyslexics Studies 1');

figure()
for i = 1:length(dys_vec2)
    nifty = load_nii(['D:\aligned data\resting_dys\'...
            num2str(dys_vec2(i)) '\resting\swuresting.nii']);
    im = nifty.img;
    im = squeeze(mean(im,4));    
    for j = 1:length(slice_vec)
        subplot(length(dys_vec2),length(slice_vec),j + (i-1)*length(slice_vec));
        imagesc(im(:,:,slice_vec(j)));
        if i == 1
            title(['Slice ' num2str(slice_vec(j))]);
        end
        set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', [], 'YTickLabelMode', 'manual', 'YTickLabel', []);
        if j == 1
            ylabel(['#' num2str(dys_vec2(i))]);
        end
    end
end
suptitle('Dyslexics Studies 2');