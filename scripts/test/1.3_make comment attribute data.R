

# require(usethis)
# edit_r_environ()

library(gptstudio)
library(network)
library(statnet)

tdf <- readRDS("data/processed/tdf.rds")


# ---- 



prompt1 <-
  "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous. Given text, perform the following steps:

Step 1) classify the text based on the following three categories: 

- 'Support' - the author(s) of the text support the delisting of wolves as an endangered species; i.e., wolves should receive less protection.

- 'Oppose' - the author(s) of the text oppose the delisting of wolves as an endangered species; i.e., wolves should receive protection under the Endangered Species Act. 

- 'Neutral' - the author(s) of the text do not clearly support or oppose delisting; e.g., the author(s) may be providing relevant information for decision-making about wolf managmenet. 

- 'Unsure' - the position of the author(s) on the topic of wolf delisting is not clear.

Step 2) return the category (using the lowercase 'support','oppose','neutral',or 'unsure').

Do not return anything except the category (i.e., do not include introductory explanation or concluding remarks).

Here is the input text: "

for(i in 1:nrow(tdf)){
  
  p1 <- paste0(prompt1, tdf$Comment2[i])
  
  result <- chat(
    prompt = p1,
    service = "openai",
    # model = "gpt-4-turbo-preview",
    # model = "gpt-4o-mini-2024-07-18",
    model = "gpt-4o-mini", # WAY cheaper; not clear if quality is worse
    skill = "intermediate",
    task = "general"
  )
  
  tdf$position[i] <- result
  
  cat("\r",i)
}

saveRDS(tdf,"data/processed/tdf.rds")

tdf$nw_cent <- tdf$nw_dens <- tdf$nw_size <- NA

for(i in 1:nrow(tdf)){
  
  df <- fromJSON(tdf$cogmaptext[i][[1]])

  # lines <- strsplit(gsub("'","",tdf$result[i]), "\n")[[1]]
  # lines <- lines[nzchar(lines)]
  # source_target <- do.call(rbind, strsplit(lines, ", "))
  # source_target <- do.call(rbind, strsplit(lines, ","))
  # 
  # # Remove surrounding quotes from the source and target
  # source_target <- apply(source_target, 2, function(x) gsub('(^"|"$)', '', x))
  # source_target[,3] <- sub("\\s+$", "", source_target[,3])
  
  # # Create the data frame
  # df <- unique(data.frame(
  #   source = source_target[, 1],
  #   target = source_target[, 2],
  #   effect = source_target[, 3],
  #   stringsAsFactors = FALSE
  # ))

  if(length(df)>0){
    net <- as.network(df,ignore.eval = "FALSE",loops = T)
    
    tdf$nw_size[i] <- network.size(net)
    tdf$nw_dens[i] <- sna::gden(net)
    tdf$nw_cent[i] <- centralization(net, mode = "digraph",FUN = "degree")
    
  }
  cat("\r",i)
}


# -------


# ad hoc tests --------

t.test(nw_cent ~ position, data = tdf[which(tdf$position %in% c("support","oppose")),])
t.test(nw_size ~ position, data = tdf[which(tdf$position %in% c("support","oppose")),])
t.test(nw_dens ~ position, data = tdf[which(tdf$position %in% c("support","oppose")),])










