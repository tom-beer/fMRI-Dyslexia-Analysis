function Group_meanEigen(type,its,l)

addpath(genpath('../Toolboxes'));

switch type
    case 'typical'
        studies = [11 12 16 17 18 24 25 30 31 40 41 42 43 63 66 67 77]; %17 cases
        str = 'control';
    case 'dyslexic'
        studies = [1 2 4 5 8 9 13 15 28 29 32 46 50 51 56 60 62 65 69 71 104]; %21 cases
        str = 'dys';
end

N = length(studies);
dim = 20;
k = 10;
allG = cell(1,N);

%calculating L&D for each study
for s = 1:N
    nifty = load_nii(['F:\ChenCo\MRI Project\Data\aligned data\resting_' str '\' num2str(studies(s)) '\resting\swuresting.nii']);
    im = nifty.img;    
    %partial volume
    im = im(:,:,25:70,:);    
    data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time
    disp(['starting G calculation for s = ' num2str(s)]);
    tic
    [G] = compute_mapping_mod(data,'LEM1',dim,k);
    if s == 1
        sumG = G;
    else
        sumG = sumG + G;
    end
    allG{s} = G;
    toc
    disp(['Done G calculation for s = ' num2str(s)]);
end

save(['sumG_' str],'sumG','-v7.3');
%load(sumG_dys);
meanG = sumG./N;

try
    tic
    disp('starting LEM');
    [mappedA_LEM20_10, mapping_LEM20_10]  = compute_mapping_mod(meanG,'LEM2',dim,k,1,its,l);
    toc
    disp('Done LEM2. saving...');
    save (['LEM20_10_' str '_meanEigen_' num2str(its) 'its_l' num2str(l)],'mappedA_LEM20_10','mapping_LEM20_10','-v7.3');
    disp('Done meanEigen!');  
catch 
    disp ('couldnt calculate LEM2');
end

end