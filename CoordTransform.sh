#!/bin/bash

set -e

#roisWeb=$(jq -r .roisWeb config.json)
#roisBL=$(jq -r .rois config.json)
rois=$(jq -r .rois config.json)
SUBBRAIN=$(jq -r .t1 config.json)

echo "$SUBBRAIN"
#if [ ! -z "$roisBL" ];
#then
#rois=roisBL
#fi

#if [ ! -z "$roisWeb" ];
#then
#rois=wget(roisWeb)
#fi

MNI=/atlas/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii

#MNI=/N/dc2/projects/lifebid/hayashis/forbrent/prf/MNI152_T1_2mm_brain_mask_dil.nii.gz
#MSK=/N/dc2/projects/lifebid/hayashis/forbrent/prf/MNI152_T1_2mm.nii.gz


#run morph command to produce coords.m.csv from coords.csv

## skull strip the T1
## (at the very least you need a brain mask)
#echo "Skull stripping brain and creating brain mask..."
#bet ${SUB}.nii.gz brain -R -B

## N4 bias correction
#antsAtroposN4.sh -d 3 -a brain.nii.gz -x brain_mask.nii.gz -c 3 -o brain_bias

## compute the registration
echo "Computing linear / non-linear alignment of input brain to MNI space..."
antsRegistration --dimensionality 3 \
		 --output [t1_to_mni_,t1_to_mni_Warped.nii.gz] \
		 --interpolation Linear \
		 --winsorize-image-intensities [0.005,0.995] \
		 --use-histogram-matching 0 \
		 --initial-moving-transform [$MNI,$SUBBRAIN,1] \
		 --transform Rigid[0.1] \
		 --metric MI[$MNI,$SUBBRAIN,1,32,Regular,0.25] \
		 --convergence [1000x500x250x100,1e-6,10] \
		 --shrink-factors 8x4x2x1 \
		 --smoothing-sigmas 3x2x1x0vox \
		 --transform Affine[0.1] \
		 --metric MI[$MNI,$SUBBRAIN,1,32,Regular,0.25] \
		 --convergence [1000x500x250x100,1e-6,10] \
		 --shrink-factors 8x4x2x1 \
		 --smoothing-sigmas 3x2x1x0vox \
		 --transform SyN[0.1,3,0] \
		 --metric CC[$MNI,$SUBBRAIN,1,4] \
		 --convergence [100x70x50x20,1e-6,10] \
		 --shrink-factors 8x4x2x1 \
		 --smoothing-sigmas 3x2x1x0vox  

## apply a transform to move coordinates to subject space (?)
mkdir -p output/rois/

for file in $rois/*.nii.gz
do
basename=$(basename $file)
## linear transform
echo "processing $basename"
#echo "Converting points from MNI space to subject space w/ linear warp..."
#antsApplyTransforms -d 3 -i file -o sub_aff_coords.csv -t [t1_to_mni_0GenericAffine.mat,1]

echo "$file"

## non-linear transform
echo "Converting rois from MNI space to subject space w/ linear and non-linear warp..."
antsApplyTransforms -d 3 -i $file -r $MNI -o output/rois/$basename -t t1_to_mni_1Warp.nii.gz -t [t1_to_mni_0GenericAffine.mat,0] -v

echo "Done."

done










