
# require(usethis)
# edit_r_environ()

library(gptstudio)
library(network)
library(networkD3)
library(htmlwidgets)
library(htmltools)
library(tesseract)

t1 <- read.csv("data/original/m5w-xmpx-wobv.csv") # 170k
t2 <- t1[which(t1$Organization.Name != ""),]
t3 <- t2[which(nchar(t2$Organization.Name) > 12),] # quick and imprecise... down to ~ n=380

t3$pdfAttachment <- t3$pdfAttachment2 <- NA
for(i in 1:nrow(t3)){
  tosplit <- t3$Attachment.Files[i]
  if(nchar(tosplit)>0){
    pdfAttachmemt <- strsplit(t3$Attachment.Files[i], split = ",")[[1]][which(grepl("pdf$", strsplit(t3$Attachment.Files[i], split = ",")[[1]]))]
    if(length(pdfAttachmemt)==1){
      t3$pdfAttachment[i] <- pdfAttachmemt
    }
    if(length(pdfAttachmemt)==2){
      t3$pdfAttachment[i] <- pdfAttachmemt[1]
      t3$pdfAttachment2[i] <- pdfAttachmemt[2]
    }
  }
}

t3$CommentPDF2 <- t3$CommentPDF1 <- NA

for(i in 1:nrow(t3)){
  if(!is.na(t3$pdfAttachment[i])){
    url <- t3$pdfAttachment[i]
    fname <- paste0("data/processed/text files/pdfs/",t3$Document.ID[i],".pdf")
    download.file(url, destfile = paste0("data/processed/text files/pdfs/",t3$Document.ID[i],".pdf"), mode = "wb",quiet = T)
    
    txt <- paste(pdftools::pdf_text(fname),collapse = "\n")
    if(nchar(txt)>100){ # 100? maybe higher or lower
      t3$CommentPDF1[i] <- txt
    }
    if(nchar(txt)<101){
      tmp <- magick::image_read_pdf(fname)
      images <- magick::image_convert(tmp,format = "png")
      
      ocr_text <- sapply(images, function(image) {
        ocr_text <- ocr(image)  
        return(ocr_text)        
      })
      
      t3$CommentPDF1[i] <- paste(ocr_text, collapse = "\n") # might still need some cleaning up (remove address info, etc.) 
    }
    if(!is.na(t3$pdfAttachment2[i])){
      url <- t3$pdfAttachment2[i]
      fname <- paste0("data/processed/text files/pdfs/",t3$Document.ID[i],".pdf")
      download.file(url, destfile = paste0("data/processed/text files/pdfs/",t3$Document.ID[i],".pdf"), mode = "wb",quiet = T)
      
      txt <- paste(pdftools::pdf_text(fname),collapse = "\n")
      if(nchar(txt)>100){ # 100? maybe higher or lower
        t3$CommentPDF2[i] <- txt
      }
      if(nchar(txt)<101){
        tmp <- magick::image_read_pdf(fname)
        images <- magick::image_convert(tmp,format = "png")
        
        ocr_text <- sapply(images, function(image) {
          ocr_text <- ocr(image)  
          return(ocr_text)       
        })
        
        t3$CommentPDF2[i] <- paste(ocr_text, collapse = "\n") # might still need some cleaning up (remove address info, etc.)
      }
    }
    
  }
  cat("\r",i)
}

# maybe paste commentpdf2 to pdf1

t3$Comment2 <- ifelse(is.na(t3$CommentPDF1),t3$Comment,t3$CommentPDF1)

t4 <- t3[nchar(t3$Comment2)>2000 & nchar(t3$Comment2)<10000,] # 83 left

tdf <- t4
# -----



# save -----

saveRDS(tdf, "data/processed/tdf.rds")

# -----


