#!/usr/bin/env python
# encoding: utf-8

"""Nice plot of the three DPC images"""

import os
import h5py
from scipy import stats
import matplotlib as mpl
import matplotlib.pyplot as plt


def draw(input_file_name, height,
         absorption_image,
         differential_phase_image,
         dark_field_image,
         language="it"):
    """Display the calculated images with matplotlib."""
    if language == "it":
        absorption_image_title = "assorbimento"
        differential_phase_image_title = "fase differenziale"
        dark_field_image_title = "riduzione di visibilit\\`a"
    else:
        absorption_image_title = "absorption"
        differential_phase_image_title = "differential phase"
        dark_field_image_title = "dark field"
    _, ((abs1_plot, abs2_plot),
        (phase1_plot, phase2_plot),
        (df1_plot, df2_plot)) = plt.subplots(
        3, 2, sharex=True, figsize=(4.6, height), dpi=300)
    min_x = 500
    max_x = 700
    min_y = 50
    max_y = 150
    abs1 = abs1_plot.imshow(absorption_image,
                            cmap=plt.cm.Greys, aspect='auto')
    limits = stats.mstats.mquantiles(absorption_image,
                                     prob=[0.02, 0.98])
    abs2 = abs2_plot.imshow(
        absorption_image[min_x:max_x, min_y:max_y],
        cmap=plt.cm.Greys, aspect='auto')
    abs1.set_clim(*limits)
    abs1_plot.axis("off")
    abs1_plot.set_title(absorption_image_title, size="medium")
    phase1 = phase1_plot.imshow(differential_phase_image)
    phase2 = phase2_plot.imshow(
        differential_phase_image[min_x:max_x, min_y:max_y])
    limits = stats.mstats.mquantiles(differential_phase_image,
                                     prob=[0.02, 0.98])
    #limits = (-3, 3)
    phase1.set_clim(*limits)
    phase1_plot.axis("off")
    phase1_plot.set_title(differential_phase_image_title, size="medium")
    df1 = df1_plot.imshow(dark_field_image)
    df2 = df2_plot.imshow(
        dark_field_image[min_x:max_x, min_y:max_y])
    df1_plot.set_title(dark_field_image_title, size="medium")
    df1_plot.axis("off")
    limits = stats.mstats.mquantiles(dark_field_image,
                                     prob=[0.02, 0.98])
    df1.set_clim(*limits)
    plt.tight_layout()
    plt.savefig('images_{0}.eps'.format(
        os.path.splitext(os.path.basename(input_file_name))[0]), dpi=300)

if __name__ == '__main__':
    import argparse
    commandline_parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    commandline_parser.add_argument("--language",
                                    default="it",
                                    choices=["it", "en"],
                                    help="language for the text")
    commandline_parser.add_argument("file",
                                    nargs=1,
                                    help="input file name")
    commandline_parser.add_argument("height",
                                    nargs=1,
                                    type=float,
                                    help="height of the plot")
    args = commandline_parser.parse_args()
    input_file_name = args.file[0]
    height = args.height[0]

    if not os.path.exists(input_file_name):
        raise(OSError("{0} not found".format(input_file_name)))

    input_file = h5py.File(input_file_name, "r")
    absorption_image_name = "postprocessing/absorption"
    differential_phase_image_name = "postprocessing/differential_phase"
    visibility_reduction_image_name = "postprocessing/visibility_reduction"

    absorption_image = input_file[absorption_image_name]
    differential_phase_image = input_file[differential_phase_image_name]
    visibility_reduction_image = input_file[visibility_reduction_image_name]

    draw(input_file_name, height, absorption_image,
         differential_phase_image, visibility_reduction_image,
         args.language)
