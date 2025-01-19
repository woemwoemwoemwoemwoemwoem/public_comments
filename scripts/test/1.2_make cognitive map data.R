

# require(usethis)
# edit_r_environ()

library(gptstudio)
library(network)
library(networkD3)
library(jsonlite)

tdf <- readRDS("data/processed/tdf.rds")


# ---- 



prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. Given text, perform the following steps:

Step 1) identify all quantitative factors mentioned in the text. 'Quantitative factors' refers to variables that can be measured numerically (including presence/absence).

Step 2) identify all perceived causal relationships among the quantitative factors. A perceived causal relationship is a relationship in which one factor is believed to cause or influence another factor. In Step 2, only include relationships that can be directly attributed to the text (i.e., do not include relationships that are not explicitly mentioned in the text).

Step 3) construct an edgelist of the relationships identified in Step 2. The edgelist should have three columns, named 'source', 'target', and 'effect'. The 'source' column identifies the factor causing a change in the other factor. The 'target' column identifies the factor that is affected by the source factor. In the 'effect' column, use '+' to indicate a positive causal effect (an increase in the source factor leads to an increase in the target factor) and '-' to indicate a negative effect.

Step 4) for any factors that are 'negative' (e.g., 'reduction in costs' or 'less disease'), rephrase them so that they are positive (e.g., 'costs' or 'disease') and change the sign of the 'effect' accordingly. If both the 'source' and 'target' factor are rephrased, the sign of the 'effect' should remain the same.

Do not return anything except the edgelist (i.e., do not include introductory explanation or concluding remarks). Return the edgelist as tab delimited text. Do not include spaces before or after commas. Do not include spaces before line breaks.

Here is the input text: "

prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. Your task is to review the text of a comment submitted to a federal agency and extract - from the text of the comment - a cognitive map that depicts the perceived causal relationships among quantitative factors that structure the mental model of the author(s) of the text. Given text, perform the following steps:

Step 1) identify all perceived causal relationships among quantitative factors. 'Quantitative factors' refers to variables that can be measured numerically (i.e., they can increase, decrease, appear, or disappear. 'The econonmy' is not a quantitative factor, but 'the strength of the economy' is a quantitative factor. A 'perceived causal relationship' is a relationship in which one factor is believed to cause or influence another factor. Only include relationships for which there is clear evidence, from the text, of how an increase or decrease in one quantitative factor increases or decreases the value of another quantitative factor. 

Step 2) construct an edgelist of the relationships identified in Step 1. The edgelist should have four columns, named 'source', 'target', 'effect', and 'evidence'. The 'source' column identifies the factor causing a change in the other factor. The 'target' column identifies the factor that is affected by the source factor. In the 'effect' column, use '+' to indicate a positive causal effect (an increase in the source factor leads to an increase in the target factor) and '-' to indicate a negative effect. In the 'evidence' column, present a quote from the text that forms the basis of the contents of the 'source', 'target', and 'effect' columns.

Step 3) for any factors that are 'negative' (e.g., 'reduction in costs' or 'less disease'), rephrase them so that they are positive (e.g., 'costs' or 'disease') and change the sign of the 'effect' accordingly. If both the 'source' and 'target' factor are rephrased, the sign of the 'effect' should remain the same.

Do not return anything except the edgelist (i.e., do not include introductory explanation or concluding remarks). Return the edgelist as tab delimited text. Do not include spaces before or after commas. Do not include spaces before line breaks.

Here is the input text: "


prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. Your task is to review the text of a comment submitted to a federal agency and extract - from the text of the comment - a cognitive map that depicts the perceived causal relationships among quantitative factors that structure the mental model of the author(s) of the text. Given text, perform the following steps:

Step 1) identify all perceived causal relationships among quantitative factors. 'Quantitative factors' refers to variables that can be measured numerically (i.e., they can increase, decrease, appear, or disappear. 'The econonmy' is not a quantitative factor, but 'the strength of the economy' is a quantitative factor. A 'perceived causal relationship' is a relationship in which one factor is believed to cause or influence another factor. Only include relationships for which there is clear evidence, from the text, of how an increase or decrease in one quantitative factor increases or decreases the value of another quantitative factor. 

Step 2) construct an edgelist of the relationships identified in Step 1. The edgelist should have three columns, named 'source', 'target', and 'effect'. The 'source' column identifies the factor causing a change in the other factor. The 'target' column identifies the factor that is affected by the source factor. In the 'effect' column, use '+' to indicate a positive causal effect (an increase in the source factor leads to an increase in the target factor) and '-' to indicate a negative effect.

Step 3) for any factors that are 'negative' (e.g., 'reduction in costs' or 'less disease'), rephrase them so that they are positive (e.g., 'costs' or 'disease') and change the sign of the 'effect' accordingly. If both the 'source' and 'target' factor are rephrased, the sign of the 'effect' should remain the same.

Do not return anything except the edgelist (i.e., do not include introductory explanation or concluding remarks). Return the edgelist as tab delimited text. Do not include spaces before or after commas. Do not include spaces before line breaks.

Here is the input text: "

prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. 
  
  Please analyze the following text and extract direct causal relationships where both the 'source' and 'target' are quantitative factors that can increase or decrease in value. A direct causal relationship is one where a measurable change in the source factor leads to a measurable change in the target factor. Only consider explicitly stated cause-and-effect relationships, meaning the text should indicate that one factor directly causes a change in the other. Ignore statements that only report observations or correlations that do not specify direct causality (e.g., 'wolf populations are estimated to be more than five times over the recovery targets' is an observation, not a causal statement). Ensure that the relationship described is supported by the text, and that the source factor directly causes a measurable change in the target, rather than suggesting an indirect or hypothetical effect. Only focus on measurable quantities such as population sizes, attainment of recovery goals, species numbers, losses, or other concrete metrics. Non-quantitative factors or general statements about opinions or hypothetical situations should be ignored.
  
  For each identified causal relationship:
  
1.	Identify the source (the causal factor) and the target (the factor that is affected). Ensure that both the source and the target are quantitative and that the source directly causes a change in the target.

2.	Specify whether the effect is 'positive' or 'negative.' A positive effect means that an increase in the source causes an increase in the target. A negative effect means that an increase in the source causes a decrease in the target.

3.	Return the output as a table in JSON format. The table should be an edgelist with three columns: 'source,' 'target,' and 'effect’. Do not return anything except the edgelist (i.e., do not include introductory explanation or concluding remarks).

Here is the text:"

tdf$cogmaptext <- NA

for(i in 1:nrow(tdf)){
  
  p1 <- paste0(prompt1, tdf$Comment2[i])
  
  result <- chat(
    prompt = p1,
    stream = FALSE,
    service = "openai",
    # model = "gpt-4-turbo-preview", # expensive, accurate, restrictive
    # model = "gpt-4o-mini-2024-07-18",
    model = "gpt-4o-mini", # WAY cheaper; not clear if quality is worse
    skill = "advanced",
    task = "general"
  )
  
  tdf$cogmaptext[i] <- gsub("```json\n|\n```", "", result)
  
  cat("\r",i)
}

saveRDS(tdf,"tdf.rds")

setwd("outputs/test/inspect networks output/")

for(i in 1:nrow(tdf)){
  
  df <- fromJSON(tdf$cogmaptext[i][[1]])
  
  # lines <- strsplit(gsub("'","",tdf$cogmaptext[i]), "\n")[[1]]
  # lines <- lines[nzchar(lines)]
  # source_target <- do.call(rbind, strsplit(lines, "\t"))
  # # source_target <- do.call(rbind, strsplit(lines, ","))
  # 
  # # Remove surrounding quotes from the source and target
  # source_target <- apply(source_target, 2, function(x) gsub('(^"|"$)', '', x))
  # source_target[,3] <- sub("\\s+$", "", source_target[,3])
  # 
  # # Create the data frame
  # df <- unique(data.frame(
  #   source = source_target[, 1],
  #   target = source_target[, 2],
  #   effect = source_target[, 3],
  #   # evidence = source_target[, 4],
  #   stringsAsFactors = FALSE
  # ))
  
  # inspect network --------
  
  if(length(df)>0){
    net <- as.network(df,ignore.eval = "FALSE",loops = T)
    links <- as.data.frame(as.edgelist(net, attrname = "effect"))
    linkcols = ifelse(links$V3 == "negative", "#e41a1c", ifelse(links$V3 == "positive", "#377eb8","#929292"))
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

setwd("~/public_comments")
