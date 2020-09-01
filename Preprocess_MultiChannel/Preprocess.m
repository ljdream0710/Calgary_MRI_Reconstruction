% generate .mat files from .7.npy data
% Train: 47 subjects - 12,032 slices
% Validation: 20 subjects - 5,120 slices
% The matrix size is 170/180 x 218 x 256.

clear
close all
clc
chn_num =12;

%=========================== Train ===================================%
% train_path = "../MultiChannel/Train/";
% train_files = dir(train_path);
% 
% for k = 3:length(train_files)
%     data = h5read(char(strcat(train_path,train_files(k).name)),'/kspace');
%     sample_kspace = [];
%     for i = 1 : chn_num
%         sample_kspace(i,:,:,:) = data((i-1)*2+1,:,:,:)+1j*data(2*i,:,:,:);
%     end
%     sample_kspace_r = permute(sample_kspace,[2,3,4,1]);
%     sample_rec_train = ifft2(sample_kspace_r); %66 116
%     sample_rec_train = permute(sample_rec_train,[3,2,1,4]);
%     cnt = 0;
%     for s = (size(sample_rec_train,3)/2-49):(size(sample_rec_train,3)/2+50)
%         images_chnl = squeeze(sample_rec_train(:,:,s,:));
%         cnt = cnt+1;
%         save(strcat('../MultiChannel/Train_slc/case_',num2str(k-2),'slc_',num2str(cnt),'.mat'),'images_chnl');
%     end
% end

%============================ Valid ===================================%
valid_path = "../MultiChannel/Val/";
valid_files = dir(valid_path);

for k = 3:length(valid_files)
    data = h5read(char(strcat(valid_path,valid_files(k).name)),'/kspace');
    sample_kspace=[];
    for i = 1 : chn_num
        sample_kspace(i,:,:,:) = data((i-1)*2+1,:,:,:)+1j*data(2*i,:,:,:);
    end
    sample_kspace_r = permute(sample_kspace,[2,3,4,1]);
    sample_rec_train = ifft2(sample_kspace_r); %66 116
    sample_rec_train = permute(sample_rec_train,[3,2,1,4]);
    cnt = 0;
    for s = (size(sample_rec_train,3)/2-49):(size(sample_rec_train,3)/2+50)
        images_chnl = squeeze(sample_rec_train(:,:,s,:));
        cnt = cnt+1;
        save(strcat('../MultiChannel/Val_slc/case_',num2str(k-2),'slc_',num2str(cnt),'.mat'),'images_chnl');
    end
end