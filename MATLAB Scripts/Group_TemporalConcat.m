function Group_TemporalConcat(type,sigma)

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

%generating concatinated data
for s = 1:N
    nifty = load_nii(['F:\ChenCo\MRI Project\Data\aligned data\resting_' str '\' num2str(studies(s)) '\resting\swuresting.nii']);
    im = nifty.img;
    %partial volume
    im = im(:,:,25:70,:);
    if s == 1
        concatData = zeros(size(im,1)*size(im,2)*size(im,3),size(im,4)*N);
    end
    data = reshape(im,size(im,1)*size(im,2)*size(im,3),size(im,4)); %voxels X time
    concatData(:,(1+(s-1)*size(im,4)):s*(size(im,4))) = data;
end

%LEM on concatinated data
dim = 20;
k = 10;

tic
[mappedA_LEM20_10, mapping_LEM20_10] = compute_mapping_mod(concatData,'Laplacian',dim,k,sigma);
toc

save (['LEM20_10_' str '_TemporalConcat_sigma' num2str(sigma)],'mappedA_LEM20_10','mapping_LEM20_10','-v7.3');

disp('Done temporal concatination!');

end