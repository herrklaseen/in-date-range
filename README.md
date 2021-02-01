# in-date-range

A Lightroom Classic plugin to help setting creation date on a number of images at once. The user specifies a date range within which the creation date should fall. The plugin calculates as many timestamps as selected images and applies a date to each. The dates will be applied in same order as the images. So, for instance, if the images are sorted by file name, the dates will be applied with the oldest date on the first image, etc. 

## Installation

1. Go to [releases](https://github.com/herrklaseen/in-date-range/releases) and download the most recent `.gz` file. 
2. Extract the files (using an unarchiver of some sort)
3. Put the extracted folder where you see fit
4. Open Lightroom and choose File > Plug-in manager
5. Click Add and follow the instructions to add the plugin you just downloaded

You start the plugin by going to menu Library > Plug-in extras > Set created date in range.

## Basic workflow

Before starting, please read the "Limitations" section below. 

1. Import your non-raw files
2. Select the files you want to change
2. If you have a roll of scanned photos that are named in sequence, sort them by file name
3. Use this plugin (Library > Plug-in extras...) to set the dates as you wish
4. Keep your photos selected and go to menu Metadata > Edit capture time
5. Select "Shift by set number of hours"
6. Set the offset to 0
7. Click "Change all"
8. Save the metadata to the actual files by Command/Ctrl+S (Save metadata to file)

After this operation your photos should have the dates you specified both as `CreateDate` and `ModifyDate`. Your photos should now be sortable and filterable with those dates as value. 

## Brutish workflow

If you (or Lightroom) for any reason have changed the `ModifyDate` you will not be able to change the date with this plugin, *unless you do the following*. **Please note:** this can potentially delete metadata from your photos, please be careful and keep a backup if you are unsure. 

1. Select the photos you want to change dates on
2. Sort them as you see fit
3. Go to menu Metadata > Read metadata from files (this will erase any metadata not present in the actual file)
4. Go to step 3 in "Basic workflow" and continue from there

If this workflow does not work either, please see "ModifyDate already set in image metadata" below.

## Limitations

### File types

I have no intention of supporting raw files with this plugin. Photos taken with a digital camera rarely have wildly differing capture dates they way a scanned image could have. If your raw files have the wrong date/time, it is usually a matter of shifting the time with a program of your choise and you're done. The plugin has been tested on `tif` and `jpeg|jpg` files. 

### Date handling in Lightroom

The date handling in Lightroom has several inconsistencies that are difficult to overcome by using the Software Development Kit (SDK) that Adobe provides. Specifically, Lightroom is not consistent in using the `CreateDate` and `ModifyDate` when displaying and filtering photos in the catalog. It should be mentioned that there seems to be no real standard on how to use these metadata fields within the industry and Adobe is not alone in being inconsistent. If you're really interested, read this (it's the tip of an iceberg): https://feedback.photoshop.com/conversations/lightroom-classic/lightroom-still-inconsistent-capture-datetime-for-photos-and-videos/5f5f45764b561a3d424dfc91. The workflows outlined above are an attempt to overcome these inconsistencies and reach a state where your photos have the "capture time" set to whatever this plugin set. 

### ModifyDate already set in image metadata

If the `ModifyDate` metadata field is set on the actual file (maybe another application changed it), you might need to reset all date-related fields on the actual image file. This can be accomplished using the excellent but daunting EXIF Tool by Phil Harvey. Proceed to install and read its documentation here: https://exiftool.org/. After date-related fields with exiftool, you may need to follow the "Brutish workflow" outlined above. 

As it becomes increasingly difficult to change the dates on the photos the later you do it, I recommend that you do this directly after import. 

## Please note

This plugin is in its early stages of development and has not been tested thoroughly. It works in my limited testing, but I will refine it over time. Please try it out, but use at your own risk. I am fairly confident the plugin can do no harm, but it's always good to have a backup of your files, if something should go wrong.  
