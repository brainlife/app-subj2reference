[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.169-blue.svg)](https://doi.org/10.25663/brainlife.app.169)

# app-subj2reference
This app warps your [input set of ROIS](https://brainlife.io/datatypes/5be9ea0315a8683a39a1ebd9) to a reference space.  As it is currently set up, the master branch of this app warps to MNI space.

NOTE: This app can easily be repurposed by changing the target nifti [here](https://github.com/brainlife/app-subj2reference/blob/199143bbc677469931faa57f4ddcfd7fc97d7dff/CoordTransform.sh#L21) to some other reference space/object (and making relevant naming changes if necessary).

### Authors
- [Daniel Bullock](https://github.com/DanNBullock) (dnbulloc@iu.edu)

### Contributors
- [Soichi Hayashi](https://github.com/soichih) (hayashis@iu.edu)

### Project Director
- [Franco Pestilli](https://github.com/francopestilli) (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NIMH-T32-5T32MH103213-05](https://img.shields.io/badge/NIMH_T32-5T32MH103213--05-blue.svg)](https://projectreporter.nih.gov/project_info_description.cfm?aid=9725739)

### References 
TBA

## Running the App 

### Inputs

- [anat/t1w](https://brainlife.io/datatypes/58c33bcee13a50849b25879a) - the T1 anatomy for this subject

- [mask [brain]](https://brainlife.io/datatypes/5a281aee2c214c9ba83ce620) - the brain mask for this subjet

- [ROIS](https://brainlife.io/datatype/5be9ea0315a8683a39a1ebd9) - The ROIS that you would like to be warped to the reference space (i.e. MNI)

### On Brainlife.io

Visit [this site](https://doi.org/10.25663/brainlife.app.169) to run this app on the brainlife.io platform.

### Running Locally (on your machine) using singularity & docker

Because this is compiled code which runs on singularity, you can download the repo and [run it locally with minimal setup](https://github.com/brainlife/app-subj2reference/blob/199143bbc677469931faa57f4ddcfd7fc97d7dff/main#L9).  

### Running Locally (on your machine)

Ensure that you have [ANTs](https://github.com/ANTsX/ANTs) installed locally

Run: [this script](https://github.com/brainlife/app-subj2reference/blob/master/CoordTransform.sh), but take care to ensure that paths are pointint to the relevant target files [here](https://github.com/brainlife/app-subj2reference/blob/199143bbc677469931faa57f4ddcfd7fc97d7dff/CoordTransform.sh#L21).

Utilize a config.json setup that is analagous to the one contained within this repo.

### Sample Datasets

TBD

### Output

- [ROIS](https://brainlife.io/datatypes/5be9ea0315a8683a39a1ebd9) - a directory containing as many ROIs as were contained in the input ROI directory object, but which have now been warped to the relevant reference space.  File names inherited from input files.

## Usage notes
One application for this app is to warp all of your subjects' endpoing maps (generated by the [Generate tract endpoint maps app](https://doi.org/10.25663/brainlife.app.194)] to MNI space, and then perform an [overlap analysis](https://github.com/DanNBullock/EcogAnalysisCode) or simply visualize [the group-level endpoint density](https://github.com/DanNBullock/pysurferPlotting)

### Product.json

Currently not implimented

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/), and [ANTs](https://github.com/ANTsX/ANTs.  
([Click here](https://singularity.lbl.gov/docs-installation) to learn more about installing singularity)

 
