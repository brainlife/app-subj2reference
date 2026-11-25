<h1 align="center">Warp subject ROIs to MNI space</h1>

<p align="center">
  Subject-space ROIs (or other NIfTI maps) warped to the MNI ICBM152 2009c template with an ANTs nonlinear registration of the subject's T1-weighted image.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.169"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.169-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Warps a set of subject-space ROIs to MNI space (ICBM152 2009c) using an ANTs SyN registration of the subject's T1-weighted image.**

Registers the subject T1 to the MNI ICBM152 2009c nonlinear asymmetric template with ANTs (rigid, affine and SyN), then applies the warp to every .nii.gz file in the input directory with antsApplyTransforms. The T1 should not be skull-stripped because the template includes the skull. The brain mask input is not used by the script. Use it to bring ROIs or endpoint maps from several subjects into a common space for group analysis.

| | |
|---|---|
| **Inputs** | `neuro/anat/t1w` · `neuro/mask` · `neuro/rois` |
| **Outputs** | `neuro/rois` |
| **Container** | `brainlife/ants:2.2.0.1` |
| **Resources** | 8 CPUs · 18 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.169](https://doi.org/10.25663/brainlife.app.169) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` (!brain_extracted) | yes | Subject T1-weighted image, not skull-stripped. Must be in the same space as the ROIs. |
| `mask` | `neuro/mask` (brain) | yes | Brain mask of the subject (required by the registry but not read by the script). |
| `rois` | `neuro/rois` | yes | ROIs in subject space (NIfTI files). |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/rois` | ROIs warped to MNI space, one file per input ROI with the same names. |

<!-- brainlife-app:end -->

## Versions on brainlife.io

Both Apps run the same code from the `master` branch; they differ only in the datatype of the maps to warp.

| App | ANTs | Branch | Run it | Status |
|---|---|---|---|---|
| Warp ROIs from subject space to MNI space | 2.2.0.1 | [`master`](https://github.com/brainlife/app-subj2reference/tree/master) | [doi:10.25663/brainlife.app.169](https://doi.org/10.25663/brainlife.app.169) | current |
| Warp density-probability from subject space to MNI space - copy | 2.2.0.1 | [`master`](https://github.com/brainlife/app-subj2reference/tree/master) | [doi:10.25663/brainlife.app.558](https://doi.org/10.25663/brainlife.app.558) | available |

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.169](https://doi.org/10.25663/brainlife.app.169) and choose:

- [`neuro/anat/t1w`](https://brainlife.io/datatypes/58c33bcee13a50849b25879a): the subject's T1-weighted image. It must **not** be skull-stripped (`!brain_extracted`), because the MNI template used as the registration target includes the skull.
- [`neuro/mask`](https://brainlife.io/datatypes/5a281aee2c214c9ba83ce620) (`brain`): the subject's brain mask. It is required by the App but not used by the current script.
- [`neuro/rois`](https://brainlife.io/datatypes/5be9ea0315a8683a39a1ebd9): the ROIs to warp to MNI space.

Press **Execute**. The warped ROIs are archived to your project as a new `neuro/rois` dataset tagged `MNI Warp`.

A typical use is to warp every subject's tract endpoint maps (from the [Generate tract endpoint maps](https://doi.org/10.25663/brainlife.app.194) App) to MNI space and then run an [overlap analysis](https://github.com/DanNBullock/EcogAnalysisCode) or visualize [group-level endpoint density](https://github.com/DanNBullock/pysurferPlotting).

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). `main` runs `CoordTransform.sh` inside the `brainlife/ants:2.2.0.1` container, which provides ANTs and the MNI template.

1. Clone this repository.
2. Create `config.json` with the paths to your inputs (see `config.json.example`):

   ```json
   {
       "t1": "/t1.nii.gz",
       "mask": "/mask.nii.gz",
       "rois": "/rois"
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

To run `CoordTransform.sh` without the container, install [ANTs](https://github.com/ANTsX/ANTs) and point the `MNI` variable in the script to a local copy of the target template.

### Warping to another reference space

The App can be repurposed by changing the target image (`MNI=/atlas/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii`) in [`CoordTransform.sh`](CoordTransform.sh) to another reference space, and adjusting output names if needed.

## Outputs

```text
output/
└── rois/   one NIfTI file per input ROI, warped to MNI space, with the input file names
```

The script also leaves the registration in the working directory: `t1_to_mni_Warped.nii.gz` (the T1 in MNI space), `t1_to_mni_0GenericAffine.mat` and `t1_to_mni_1Warp.nii.gz`.

## Troubleshooting

- **Poor registration**: check that the T1 is not skull-stripped; the target template includes the skull.
- **No ROIs in the output**: only files matching `*.nii.gz` in the `rois` directory are warped.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Warp ROIs from subject space to MNI space. brainlife.io App. [doi:10.25663/brainlife.app.169](https://doi.org/10.25663/brainlife.app.169)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)
- Avants et al. A reproducible evaluation of ANTs similarity metric performance in brain image registration. *NeuroImage* 54:2033-2044 (2011). [doi:10.1016/j.neuroimage.2010.09.025](https://doi.org/10.1016/j.neuroimage.2010.09.025)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)

## Authors

- [Daniel Bullock](https://github.com/DanNBullock)
- [Franco Pestilli](https://github.com/francopestilli) (project director)

**Contributors:** [Soichi Hayashi](https://github.com/soichih)

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). ANTs is distributed under its own licence.
