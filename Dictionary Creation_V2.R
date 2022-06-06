library(stringi)
library(stringr)

# This file contains the multiple lists/vectors of regex & string patterns used
# in the parsing of OCR scans. Dictionaries should be updated in alphabetical 
# order as necessary and resaved for loading in parsing script.
# -----------------------------------------------------------------------------

# List of image files to import and OCR
FAH4OCR<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Cropped/", 
               list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Cropped/"), sep="")
save(FAH4OCR, file = "Dictionary Data/preprocessed_files_for_OCR.RData")
# List of image files to export OCR text.cvs
FAH.OCROut<-paste("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Receipts/", 
                  list.files("K:/Research/Umich_West/2020 Receipt Validation/TesseractOCR/03 FAH Processed/Cropped/"), sep="")
FAH.OCROut<-str_replace(FAH.OCROut, ".jpg|.JPG|.png|.PNG", ".csv")
save(FAH.OCROut, file = "Dictionary Data/OCR_processed_files_for_export_to_csv.RData")
# -----------------------------------------------------------------------------

# Units to be identified within a given line.
  # NOTES:
  # 1.) It would be useful to eliminate OZ in favor of Z, however the simpler
  #     pattern may increase errors in recognition.
  # 2.) "QTY" could be excluded here so it could instead be captured in the 
  #     "quantity" field, however first need to identify how it is actually 
  #      associated with prices; i.e., like "CT" or "Pack", or is it "# @..."


c("OZ", # what about Z, 0Z, 02, or O2? space from number vs no space...
  "LB",
  "GAL",
  "PK",
  "LT",
  )
units<-c("CT", 
         "DZ", 
         "EA", 
         "OZ", 
         "HALF GALLON", 
         "GAL", "GALLON", 
         "LB", 
         "PK", 
         "Z", 
         "QTY", 
         "WT"); save(units, file = "Dictionary Data/dict_units.RData")

# -----------------------------------------------------------------------------

# Identify 1 or more digits ("\\d+", (+="1 or more")) followed by one "."
# or less ("\\.?", (?="0 or 1")), possibly followed by 0 or more digits ("\\d*",
# (*="0 or more")), preceding each of the "units". Numbers must precede unit 
# as indicated by ("?=") but regex will include numbers and unit because unit is
# outside the "preceded by" statement.

  # NOTES:
  # 1.) It would be useful to create a paste function based on units since the 
  #     regex does not change aside from unit strings. As such the only place an 
  #     update needs to occur is the "units" dictionary.

extractunits<-c("\\d+\\.?\\d*(?=)\\sCT", 
                "\\d+\\.?\\d*(?=)\\sDZ", 
                "\\d+\\.?\\d*(?=)\\sEA", 
                "\\d+\\.?\\d*(?=)\\sOZ", 
                "\\d+\\.?\\d*(?=)\\sHALF GALLON", 
                "\\d+\\.?\\d*(?=)\\sGAL", 
                "\\d+\\.?\\d*(?=)\\sGALLON", 
                "\\d+\\.?\\d*(?=)\\sLB", 
                "\\d+\\.?\\d*(?=)\\sPK", 
                "\\d+\\.?\\d*(?=)\\sZ", 
                "\\d+\\.?\\d*(?=)\\sQTY", 
                "\\d+\\.?\\d*(?=)\\sWT") 
save(extractunits, file = "Dictionary Data/dict_extract_units.RData")

# -----------------------------------------------------------------------------

# Identify strings or regex patterns indicative that line text is not of
# interest and should not be captured and delete whole line
  # NOTES:
  # 1.) 

garbageline<-c("ABOVE ITEM",
               "AD SAVIN",
               "AMOUNT", 
               "AUTH ",
               "CASH[^A-Z0-9]", 
               "CHANGE", 
               "COUPON",
               "CREDIT TEND", 
               "DEBT",
               "DILLON",
               "ELIGIBLE",
               "ENDING",
               "^\\s?EBT ",
               "GENERAL EXEM",
               "GROCERIES",
               "ITEMS",
               "KROGER SAV",
               "KROGER PLUS",
               "MANAGER",
               "OFF NEXT",
               "FUEL",
               "ON SALE",
               "PRICE YOU PAY.*",
               "PURCHASED",
               "REDUCED TO CLEAR",
               "REG PRICE",
               "RE.{3,4}(AR|ER) PRICE",
               "RETURN VALUE", 
               "[A-Z0-9]+\\s*T(O|0)TAL", # 1 or more non-whitespace char, followed by 0 or more whitespace char, followed by "TOTAL" (where total can be spelled with O or zero)
               "^\\s*$", # line of only whitespace from start of string ("^") to end of string ("$")
               "(?<![A-Z])TA.", # "TA" followed by another character but not preceded by "TO". Should indicate "TAX" line.
               "STORE SAV", 
               "\\s+TENDER\\s+",
               "TOTAL BEFORE", 
               "TOTAL AFTER",
               "VALUED C",
               "OU SAVED",
               "YOUR SAV",
               "\\d{1,2}/\\d{1,2}/\\d{4}")


save(garbageline, file = "Dictionary Data/dict_garbage_line_controls2.RData")

# -----------------------------------------------------------------------------

# Identify strings or regex patterns indicative that line text is a dept header
# NOTES:
# 1.) 

headers<-c("^\\s*BAKED GOODS\\s*$", 
           "^\\s*BULK\\s*$",
           "^\\s*DAIRY\\s*$",
           "^\\s*DAIRY.+FROZEN\\s*$",
           "^\\s*DELI\\s*$", 
           "^\\s*FROZEN\\s*$",
           "^\\s*GROCERY\\s*$",
           "^\\s*HEALTH MARKET\\s*$",
           "^\\s*MEAT\\s*$",
           "^\\s*NATURAL (FOODS|FOOD)\\s*$",
           "^\\s*NON F.+D\\s*$", 
           "^\\s*PRODUCE\\s*$", 
           "^\\s*REFRIG/FIROZEN\\s*$", 
           "^\\s*SODA\\s*$")

save(headers, file = "Dictionary Data/dict_headers_line_controls2.RData")
# -----------------------------------------------------------------------------
# Identify strings or regex patterns indicative that text pattern is not of
# interest and should not be captured but instead deleted from line to improve
# capturing of other data.
  # NOTES:
  # 1.) 

garbageregex<-c("(?<![\\.\\S])[:alnum:]{1,2}(?![\\S])", # 1. one or two characters surrounded by whitespace, 
                "(?i)([a-z])\\1\\1\\1+", # 2. letter character that repeats 4x or more in a word,
                "(?i)([0-9])\\1\\1\\1+", # 3. number that repeats 4x or more in a word
                "[^A-Za-z0-9\\s]") # 4. all special characters except whitespace - CAN'T REMOVE UNLESS ALL PRICES AND EVERYTHING ARE CLEARED ALREADY.
save(garbageregex, file = "Dictionary Data/dict_garbage_inline_controls.RData") 

# -----------------------------------------------------------------------------

