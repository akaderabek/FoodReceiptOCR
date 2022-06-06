# FoodReceiptOCR
Repository of files related to the use of novel OCR processing of point-of-sale receipts as a method for data collection in expenditure research. This research was conducted under a cooperative agreement between the Michigan Program for Survey and Data Science and the United States Department of Agriculture - Economic Research Service.

The R files associated with this project were developed to evidence the ability of using the open source Tesseract OCR engine to read point-of-sale (POS) receipts which evidence food purchases. The goal of this research was to evidence novel OCR processes as a method to estimate under reporting in surveys of expenditure research.

The process included three main processes, first the pre-processing of receipt images using ImageMagick, secondly the OCR of the image using Tesseract, and lastly the parsing of scanned test into an analytical format; i.e., a digital replica of the receipt.

Files were coded based on type of food-purchase event, i.e., either Food Away From Home (FAFH) or Food At Home (FAH) expenditures. Image pre-processing was essentially identical for each type of event receipt. Parsing of OCR results was highly dependent on event type and within each event type, results were sensitive to establishment/receipt formatting and layout.

Questions, comments and additional insights can be sent to Adam Kaderabek at amkad@umich.edu. 
