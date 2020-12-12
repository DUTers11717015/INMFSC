# INMFSC
# Incremental Nonnegative Matrix Factorization with Sparseness Constraint for Image Representation

  This repo implements the iterative updating process of the proposed feature extraction algorithm for "Incremental Nonnegative Matrix Factorization with Sparseness Constraint for Image Representation" by Jing Sun et al.. This code performs the clustering experiments on the face (ORL-32) and object (COIL20) datasets to obtain AC and NMI, and then verifies the clustering effectiveness of INMFSC. Besides, the code can also show the sparseness study and run time of ours to compare with other NMF-based clustering methods.

## Dependences

  The code supports Matlab.

## Run

  main.m--INMFSC/INMF
  
  main1006     -NMF
  main1024nmf  -GINMFSC
  main1027nmf  -GNMF

## Download this paper

  https://link.springer.com/chapter/10.1007%2F978-3-030-00767-6_33
  
  https://dblp.org/rec/conf/pcm/SunWLS18.html

## Citation

  If you find this code useful, please cite:

  Jing Sun, Zhihui Wang, Haojie Li*, Fuming Sun. (2018) Incremental Nonnegative Matrix Factorization with Sparseness Constraint for Image Representation. PCM (2) 2018: 351-360.
