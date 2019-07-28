% [U,S,V] = pca2(a,10,true);
% norm(a-U*S*V')/norm(a)

[V,D] = eig(a);
a_eig = V*D*V';
imshow(a_eig,[])
% 
% [U,S,V] = svd(a);
% a_svd = U*S*V';
% imshow(a_svd,[])


k=50;

[V,D] = eigs(a,k);
a_eigs = V*D*V';
subplot 121
imshow(a_eigs,[])

[U,S,V] = pca2(a,k,true);
a_rand = U*S*V';
subplot 122
imshow(a_rand,[])


[mappedX, lambda] = eigs(L, D, no_dims + 1);

X = diag(D); 
X = X.^(-1/2); 
D_sqrt = diag(X); 
M = D_sqrt * L * D_sqrt; 
[mappedX, lambda, ~] = pca(M, no_dims + 1, true, 5,100); 
mappedX = D_sqrt * mappedX;


[V,D] = eigs(a,k);
a_eigs = V*D*V';
subplot 121
imshow(a_eigs,[])

[V,D] = eigs(a,B,k);
a_eigs = V*D*V';
subplot 122
imshow(a_eigs,[])

%%
nifti = load_nii('..\Data\typical\12\resting\wraresting.nii');
im = nifti.img;
slice20 = squeeze(im(:,:,20,:));
data = reshape(slice20,size(slice20,1)*size(slice20,2),size(slice20,3));
numDims = 20;

%%
[mappedX, mapping] = compute_mapping(data, 'Laplacian',20);
figure
for iDim = 1:numDims/2
    subplot(1,numDims/2,iDim);
    eigVec = reshape(mappedX(:,iDim),size(slice20,1),size(slice20,2));
    imshow(abs(eigVec),[]);
end