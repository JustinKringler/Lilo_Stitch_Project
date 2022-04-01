#WebScraping Lilo and Stitch Script
library(XML)
url <- "https://movies.fandom.com/wiki/Lilo_%26_Stitch/Transcript"
source <- readLines(url, encoding = "UTF-8")
parsed_doc <- htmlParse(source, encoding = "UTF-8")
xpath_script<-xpathSApply(parsed_doc, path = '/html/body/div[4]/div[3]/div[2]/main/div[3]/div[2]/div', xmlValue)
script<-data.frame(script = unlist(strsplit(as.character(xpath_script), "\n")))

##############Data Cleaning################

# We want the dataframe to have a column with the speaker, and a column with the text.
# This script includes things going on in the scene so our first step is having it include
# Script: followed by text.

script$script<-ifelse(grepl(":", script$script, fixed = TRUE) == FALSE,
       paste0("Script: ", script$script),script$script  )

# Now we want to seporate the script into two columns. One column for the Character/script
# and the other for what was said.
script_ish<-data.frame(do.call("rbind", strsplit(as.character(script$script), ":", fixed = TRUE)))
script_ish<-script_ish[,1:2]

#Now Im going to get rid of blank rows and rows that just have " [". LETS GOOOO
#we will change blank rows to look like " [" rows, then covnert them to 000 since 
#that does not exist in any other row, then delete all rows with 000.

script_ish$X2<-ifelse(script_ish$X2==" "," [",script_ish$X2)
script_ish$X2<-ifelse(script_ish$X2==" [","000",script_ish$X2) 
script_ish<-script_ish[- grep("000", script_ish$X2),]

#Need to get rid of first row because it just for the start of the transcript
Clean_Script<-script_ish[- grep("Transcript", script_ish$X2),]

#Change row to say Nani
Clean_Script[145,1]<-"Nani"
# Random boy says this but were just gonna leave it as script.
#Clean_Script[168,2]

#410 is messed up but we will fix it to Nani
Clean_Script[410,1]<- "Nani"

setwd("C:/Users/cc13m/OneDrive/Desktop/All_Folders/R/Projects/Lilo and Stitch")
write.csv(Clean_Script,"C:/Users/cc13m/OneDrive/Desktop/All_Folders/R/Projects/Lilo and Stitch/lilo_script.csv", row.names = FALSE)


