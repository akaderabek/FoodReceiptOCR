library(stringi)
library(stringr)


# Identify strings or regex patterns indicative that line text is not of
# interest and should not be captured and delete whole line
  # NOTES:
  # 1.) 

garbageline<-c("VISIT",
               "WRITE",
               "CALL",
               "REDEEM",
               "\\.COM",
               "FREE",
               "CODE",
               "CASHLESS",
               "CHANGE",
               "LEGO",
               "AUTHORIZ",
               "SIZE ITEM PRICE",
               "SERVICE COFFEE",
               "REFERENCE",
               "APPROVAL",
               "AUTH",
               "TRAN",
               "WRAP NO ONIONS. NO CUCUMBERS. THANKS",
               "PAID CASH",
               "ITE.\\sC", # ITEM COUNT
               "EXACT DOLLAR",
               "SMURF",
               "TIP",
               "TI.\\s",
               "SUB W/",
               "SEAT",
               "ITEM TOTAL",
               "^.{40,}$",
               "CASH")


save(garbageline, file = "Dictionary Data/dict_garbage_line_FAFH.RData")

# Identify strings or regex patterns indicative that text pattern is not of
# interest and should not be captured but instead deleted from line to improve
# capturing of other data.
# NOTES:
# 1.) 

garbageregex<-c("\\d{1,2}/\\d{1,2}", # Date pattern "mm/dd" 
                "\\d{1,2}/\\d{1,2}/\\d{2,4}", # Date pattern "mm/dd/yy" (or"mm/dd/yyyy")
                "\\d{1,2}:\\d{1,2}", # Time Pattern dd:dd
                "DINE IN",
                "TO GO",
                "NO DRINK",
                "CUT",
                "EAT IN",
                "WALK IN",
                "ORDER DATE",
                "(?<![\\S])[:alpha:]{1}(?![\\S])", # remove single letters surrounded by white space
                "X{2,}", # remove sequences of X's
                "(?<=\\.[0-9]{2})[A-Z\\s]+$|(?<=\\.[0-9]{2})\\s*0", # remove garbage at the end of an item string following a price
                "[0-9]{4,}", # remove any long string of digits (five or more) from line 
                "TAKE.UT",
                ".?AKEOUT ")

# garbageregex<-c("(?<![\\.\\S])[:alnum:]{1,2}(?![\\S])", # 1. one or two characters surrounded by whitespace, 
#                 "(?i)([a-z])\\1\\1\\1+", # 2. letter character that repeats 4x or more in a word,
#                 "(?i)([0-9])\\1\\1\\1+", # 3. number that repeats 4x or more in a word
#                 "[^A-Za-z0-9\\s]") # 4. all special characters except whitespace - CAN'T REMOVE UNLESS ALL PRICES AND EVERYTHING ARE CLEARED ALREADY.
save(garbageregex, file = "Dictionary Data/dict_garbage_inline_FAFH.RData") 

# -----------------------------------------------------------------------------

total.indicators<-c("(?<!.)TOTAL", # Total not preceded by anything
                    "\\sTOTAL\\s*$",
                    "CHARGE",
                    "MASTERCARD",
                    "PAYMENT",
                    "AMOUNT",
                    "DRIVE THRU",
                    "ORDER TOTAL",
                    "VISA",
                    "BALANCE",
                    "GRAND T",
                    "(?<!.)TOTL",
                    "(?<!.)TOTA")
save(total.indicators, file = "Dictionary Data/dict_total_indicators_FAFH.RData") 

# -----------------------------------------------------------------------------

tax.indicators<-c("\\s+TAX\\s?", 
                  "^\\s*TAX\\s*$",
                  "^\\s*AX\\s*$",
                  "\\s+AX\\s+",
                  "^.AX\\s+",
                  "^TA.[^A-Z0-9]")

save(total.indicators, file = "Dictionary Data/dict_tax_indicators_FAFH.RData") 
# -----------------------------------------------------------------------------

subtotal.indicators<-c("SUBTO.+",
                  "SUB TOTAL",
                  "NET TOTAL",
                  "OUBTOTA",
                  "SUB.TOTAL",
                  "SUB. TOTAL",
                  "SUBT.+")

save(total.indicators, file = "Dictionary Data/dict_subtot_indicators_FAFH.RData") 

