import numpy as np
import matplotlib.pylab as plt
import os
import matplotlib.gridspec as gridspec
import glob
import sys
import h5py
from utils import sum_of_squares
import pdb

train_path = '../MultiChannel/Train/*.h5'
train_files = np.asarray(glob.glob(train_path))
print("Number of volumes in the train set",len(train_files))

# Displaying a specific slice from a specific volume
file_index = 25
slice_index = 178

sr = 0.85 # Sampling-rate in the slice-encode direction

# Load .h5 file
with h5py.File(train_files[file_index], 'r') as f:
    sample_kspace = f['kspace'][:] # the key to access data is 'kspace'

# Explicit zero-filling after 85% in the slice-encoded direction
print(sample_kspace.shape)
Nz = sample_kspace.shape[2]
Nz_sampled = int(np.ceil(Nz*sr))
print(Nz_sampled)
print(sample_kspace.shape)

sample_kspace[:,:,Nz_sampled:,:] = 0

print("Data format is x-ky-kz-nchannels")
print("data shape:",sample_kspace.shape)

# We just want to show one slice
sample_kspace = sample_kspace[slice_index]
# Converting to complex
sample_kspace = sample_kspace[:,:,::2] + 1j*sample_kspace[:,:,1::2]

print("\n\nChannel-wise k-space")    

# Displaying channels' k-spaces
#plt.figure(figsize = (8,6),dpi = 150)
#gs1 = gridspec.GridSpec(3, 4)
#gs1.update(wspace=0.002, hspace=0.1)

#for ii in range(12):
#    plt.subplot(gs1[ii])
#    plt.imshow(np.log(1+np.abs(sample_kspace[:,:,ii])),cmap = "gray")
#    plt.axis("off")
#plt.show()

print("Channel-wise images")    
sample_rec_train = np.fft.ifft2(sample_kspace,axes = (0,1)) # Only ky and kz are in k-space domain

# Displaying channels' images
plt.figure(figsize = (8,6),dpi = 150)
gs1 = gridspec.GridSpec(3, 4)
gs1.update(wspace=0.002, hspace=0.1)

#for ii in range(12):
#    plt.subplot(gs1[ii])
#    plt.imshow(np.abs(sample_rec_train[:,:,ii]),cmap = "gray")
#    plt.axis("off")
#plt.show()

print("Sum of squares")

sos = sum_of_squares(sample_rec_train)
plt.figure(dpi = 100)
plt.imshow(sos,cmap = "gray")
plt.axis("off")
plt.show()
