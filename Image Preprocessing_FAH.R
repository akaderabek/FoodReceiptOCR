library(dplyr)
library(image.binarization)
library(magick)
library(stringi)
library(stringr)
library(tesseract)
library(tictoc)
library(tidyr)


# create string with path & input file name
FAHin<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/01 FAH Sample Images/Quality 4/", 
             list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/01 FAH Sample Images/Quality 4/"), sep="") 
# create string with path & output file name
FAHout<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Quality 4/", 
      list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/01 FAH Sample Images/Quality 4/"), sep="") 
# standardize file extension case for image_write()
FAHout<-str_replace(FAHout, ".JPG", ".jpg") 
FAHout<-str_replace(FAHout, ".PNG", ".png") 

# ------------------------------------------------------------------------------

# The pre-processing loop imports image files from the list of paths created above and conducts a series of steps.
# 1. Load image and increase density to 300.
# 2. Convert the image to grayscale.
# 3. Binarize the image converting all pixels to either black or white (Uses T.R. Singh method).
# 4. Check if image is wider than high and if so rotate 90 degrees. (Not fully functional. Does not confirm true north of image, only rotates if wider than high.)
# 5. Deskew image.
# 6. Write image to designated directory with density = 300.

tic("binarization") # start timer
for (i in 1:7) {
  original<-image_read(FAHin[i], density = 300) # load original image
  grayed<-image_convert(original, colorspace = "Gray") # convert to gray scale
  binary<-image_binarization(grayed, type = "trsingh") # binarization of gray scale using T.R. Singh Adaptive Binarization
  
  if(image_info(binary)[2]>image_info(binary)[3]) { # confirm orientation - if in portrait layout,
    binary<-image_rotate(binary, degrees = 90) # rotate 90 degrees
    deskewed<-image_deskew(binary) # deskew image
  }
  else {
    deskewed<-image_deskew(binary) # deskew image
  }
  image_write(deskewed, FAHout[i], path=FAHout[i], density = 300) # write new image file to folder
} 
toc() # stop time, report duration

# -----------------------------------------------------------------------------

# CROPPIING CODE TO MANUALLY CROP IMAGES

# create string with path & input file name
Crop.in<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Quality 4/", 
             list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Quality 4/"), sep="") 
# create string with path & output file name
Crop.out<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Cropped/", 
              list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Quality 4/"), sep="") 

# import pre-processed receipt image, then display in browser and print image properties in console
image<-image_read(Crop.in[7], density = 300); image_browse(image); image

# create cropped image object, then display in browser
cropped<-image_crop(image, geometry = "2000x1750+500+0"); image_browse(cropped)
# image2<-image_deskew(cropped); image_browse(image2); image2 # Deskew cropped image if further deskew is necessary
# cropped<-image_crop(image2, geometry = "665x1600+0+0"); image_browse(cropped) # Cropping of double deskewed images

# write new image file of cropped receipt
image_write(cropped, path = Crop.out[7], density = 300)
