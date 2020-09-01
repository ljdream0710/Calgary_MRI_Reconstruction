% generate .mat files from .7.npy data
% Train: 25 subjects - 4,524 slices
% Validation: 10 subjects - 1,700 slices
% The matrix size is 256 x 256.

clear  
close all
clc

% Single-channel  data
% crop = [50,-50]
Nx = 256;
Ny = 256;
slc = 100;

path = "../../BrainData/SingleChannel/";
valid_path = strcat(path,'Val/');
valid_files = dir(valid_path);
gt_cpx = zeros(Nx,Ny,slc);
ref = zeros(Nx,Ny,slc,2); % 2 channels for the real and imag part of the gt_cpx

for i = 3:length(valid_files)
    sample_kspace = readNPY(strcat(valid_path,valid_files(i).name));
    sample_kspace = sample_kspace(:,:,:,1)+1j*sample_kspace(:,:,:,2);
    sample_kspace = permute(sample_kspace,[2,3,1]);
    sample_rec_train = ifft2(fftshift(sample_kspace));
    gt_cpx(:,:,1:50) =  sample_rec_train(:,:,size(sample_rec_train,3)-49:size(sample_rec_train,3));
    gt_cpx(:,:,51:100) = sample_rec_train(:,:,1:50);
    %ref(:,:,:,1) = real(gt_cpx);
    %ref(:,:,:,2) = imag(gt_cpx);
    for j = 1:slc
        images_chnl = squeeze(gt_cpx(:,:,j));
        save(strcat(path,'Val_slc/case_',num2str(i-2),'slc_',num2str(j),'.mat'),'images_chnl');
    end
end


train_path = strcat(path,'Train/');
train_files = dir(train_path);
gt_cpx = zeros(Nx,Ny,slc);
ref = zeros(Nx,Ny,slc,2); % 2 channels for the real and imag part of the gt_cpx

for i = 3:length(train_files)
    sample_kspace = readNPY(strcat(train_path,train_files(i).name));
    sample_kspace = sample_kspace(:,:,:,1)+1j*sample_kspace(:,:,:,2);
    sample_kspace = permute(sample_kspace,[2,3,1]);
    sample_rec_train = ifft2(fftshift(sample_kspace));
    gt_cpx(:,:,1:50) =  sample_rec_train(:,:,size(sample_rec_train,3)-49:size(sample_rec_train,3));
    gt_cpx(:,:,51:100) = sample_rec_train(:,:,1:50);
    %ref(:,:,:,1) = real(gt_cpx);
    %ref(:,:,:,2) = imag(gt_cpx);
    for j = 1:slc
        images_chnl = squeeze(gt_cpx(:,:,j));
        save(strcat(path,'Train_slc/case_',num2str(i-2),'slc_',num2str(j),'.mat'),'images_chnl');
    end    
end
