

# require(usethis)
# edit_r_environ()

library(gptstudio)
library(network)
library(networkD3)
library(htmlwidgets)
library(htmltools)
library(tesseract)

t1 <- read.csv("../text files/m5w-xmpx-wobv.csv") # 170k
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
    fname <- paste0("../text files/pdfs/",t3$Document.ID[i],".pdf")
    download.file(url, destfile = paste0("../text files/pdfs/",t3$Document.ID[i],".pdf"), mode = "wb",quiet = T)
    
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
      fname <- paste0("../text files/pdfs/",t3$Document.ID[i],".pdf")
      download.file(url, destfile = paste0("../text files/pdfs/",t3$Document.ID[i],".pdf"), mode = "wb",quiet = T)
      
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

prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. Given text, perform the following steps:

Step 1) identify all quantitative factors mentioned in the text. 'Quantitative factors' refers to variables that can be measured numerically (including presence/absence).

Step 2) identify all perceived causal relationships among the quantitative factors. A perceived causal relationship is a relationship in which one factor is believed to cause or influence another factor. In Step 2, only include relationships that can be directly attributed to the text (i.e., do not include relationships that are not explicitly mentioned in the text).

Step 3) construct an edgelist of the relationships identified in Step 2. The edgelist should have three columns, named 'source', 'target', and 'effect'. The 'source' column identifies the factor causing a change in the other factor. The 'target' column identifies the factor that is affected by the source factor. In the 'effect' column, use '+' to indicate a positive causal effect (an increase in the source factor leads to an increase in the target factor) and '-' to indicate a negative effect.

Step 4) for any factors that are 'negative' (e.g., 'reduction in costs' or 'less disease'), rephrase them so that they are positive (e.g., 'costs' or 'disease') and change the sign of the 'effect' accordingly. If both the 'source' and 'target' factor are rephrased, the sign of the 'effect' should remain the same.

Do not return anything except the edgelist (i.e., do not include introductory explanation or concluding remarks). Return the edgelist as comman delimited text. Do not include spaces before or after commas. Do not include spaces before line breaks.

Here is the input text: "

for(i in 1:nrow(tdf)){

  p1 <- paste0(prompt1, tdf$Comment2[i])

  result <- chat(
    prompt = p1,
    service = "openai",
    # model = "gpt-4-turbo-preview",
    model = "gpt-4o-mini-2024-07-18",
    # model = "gpt-4o-mini", # WAY cheaper; not clear if quality is worse
    skill = "intermediate",
    task = "general"
  )

  tdf$result[i] <- result

  cat("\r",i)
}

saveRDS(tdf,"tdf.rds")

setwd("../inspect networks output/")

for(i in 1:nrow(tdf)){

  lines <- strsplit(gsub("'","",tdf$result[i]), "\n")[[1]]
  lines <- lines[nzchar(lines)]
  source_target <- do.call(rbind, strsplit(lines, ", "))
  source_target <- do.call(rbind, strsplit(lines, ","))

  # Remove surrounding quotes from the source and target
  source_target <- apply(source_target, 2, function(x) gsub('(^"|"$)', '', x))
  source_target[,3] <- sub("\\s+$", "", source_target[,3])

  # Create the data frame
  df <- unique(data.frame(
    source = source_target[, 1],
    target = source_target[, 2],
    effect = source_target[, 3],
    stringsAsFactors = FALSE
  ))
  


  # inspect network --------

  if(nrow(df)>4){
  net <- as.network(df[-c(1,2,nrow(df)),],ignore.eval = "FALSE",loops = T)
  links <- as.data.frame(as.edgelist(net, attrname = "effect"))
  linkcols = ifelse(links$V3 == "-", "#e41a1c", ifelse(links$V3 == "+", "#377eb8","#929292"))
  class(links$V1) <- class(links$V2) <- "numeric"
  links[,1:2] <- links[,1:2] - 1
  nodes <- data.frame(concept = net%v%"vertex.names", deg = sna::degree(net))
  
  # nodes$group <- sapply(strsplit(nodes$concept,"[.]"), `[`, 1)
  nodes$group = "test"
  
  ColourScale <- 'd3.scaleOrdinal()
            .domain(["test"])
           .range(["#555555"]);'
  
  forceNetwork(Nodes = nodes, Links = links
                         , charge=-10
                         , NodeID = "concept"
                         , Group = "group"
                         , Nodesize = "deg"
                         , colourScale = JS(ColourScale)
                         , opacity = 1
                         , radiusCalculation = JS(" Math.sqrt(d.nodesize)+4")
                         , arrows = T
                         , Value = 1#"value"
                         , linkColour = linkcols
                         , fontSize = 15
                         , fontFamily = 'Arial'
                         , opacityNoHover = 1
                         , bounded = T
                         , zoom = T
                         , linkDistance = JS("function(d) { return 100; }")
                         , linkWidth = JS("function(d) { return 2; }")
  ) %>% 
    htmlwidgets::prependContent(htmltools::tags$h1(tdf$Organization.Name[i])) %>% 
    saveNetwork(file = paste0(tdf$Organization.Name[i],'.html'))
  
  }
  cat("\r",i)
}

setwd("../scripts/")
