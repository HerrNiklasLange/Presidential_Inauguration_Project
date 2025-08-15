#Need to follow the following video so that everything works
#https://www.youtube.com/watch?v=GnpJujF9dBw
#common error go into the java folder and remove the error file
#rm(list = ls()) for removing all global variables


#The data is from https://www.presidency.ucsb.edu/
#www.presidency.ucsb.edu/documents/app-categories/spoken-addresses-and-remarks/presidential/inaugural-addresses?items_per_page=60
LoadingPH <- function(){
  print("Executing Webscrapper")
  
  all_speeches <- data.frame(president=character(),
                             date=character(),
                             speech=character(),
                             stringsAsFactors = FALSE)
# Loading packages
  library(RSelenium)
  library(wdman)
  library(netstat)
  library(httr)
  library(rvest)
  library(openxlsx)
  library(readxl)
  library(lubridate)
  
  
  #loading selium and preparing servers dfWebSCrapper[[1,2]]
  selenium(phantomver = NULL)
  selenium_objext <- selenium(retcommand = T, check = F)
  #checking newest version of chrome
  binman::list_versions("chromedriver")
  #starting a server
  rD <- rsDriver(browser="firefox",
                 chromever = NULL,
                 verbose =  F,
                 port = free_port(), phantomver = NULL)
  #remDr <- rD[["client"]]
  assign("remDr", rD[["client"]], envir = .GlobalEnv)
   
  #The website is not the best designed hence I needed to add some URL manually
  
  #There have been a total of 63 inaugural speeches made
  remDr$navigate("https://www.presidency.ucsb.edu/documents/oath-office-and-second-inaugural-address")
  all_speeches <- rbind(all_speeches, Readinghtml())
  Sys.sleep(3)
  
  remDr$navigate("https://www.presidency.ucsb.edu/documents/the-presidents-inaugural-address")
  all_speeches <- rbind(all_speeches, Readinghtml())
  Sys.sleep(3)
  print(data)
  remDr$navigate("https://www.presidency.ucsb.edu/documents/second-inaugural-address")
  Readinghtml()
  Sys.sleep(3)
  
  remDr$navigate("https://www.presidency.ucsb.edu/documents/address-upon-assuming-the-office-president-the-united-states-1")
  Readinghtml()
  Sys.sleep(3)
  
  remDr$navigate("https://www.presidency.ucsb.edu/documents/address-upon-assuming-the-office-president-the-united-states-0")
  Readinghtml()
  Sys.sleep(3)
  
  remDr$navigate("https://www.presidency.ucsb.edu/documents/address-upon-assuming-the-office-president-the-united-states")
  Readinghtml()
  Sys.sleep(3)

  base <- "https://www.presidency.ucsb.edu/documents/inaugural-address"
  
  for (i in 0:54){
    if(i==0){
      remDr$navigate(base)
      Readinghtml()
      Sys.sleep(3)
       }
    #It starts to count from 0 to 54 but it also has a case where it has no number at the end of the url
    url <- paste(base,i)
    url <- gsub(" ", "-", url)
    remDr$navigate(url)
    Readinghtml()
    Sys.sleep(3)
      
    }
  
  
  setwd(getwd())
  write.xlsx(all_speeches, "/Users/nikla/programming_projects/R/presidential_inaugural_address/pres_inuagural_address.xlsx")
  
  #closing the server
  rD[["server"]]$stop()
  
  #if server is not closed properly or you have issues 
  #(Error in selenium(phantomver = NULL) :Selenium server signals port = 4567 is already in use.)
  #restart R (go to Session/Restart R, or control + shift + F10)

}
Readinghtml <- function(){
  
  #President, Inaguaration, date
  dfWebScrapper <- data.frame(president="NA", date = "NA", speech = "NA")
  
  updated_page_source <- remDr$getPageSource()[[1]] 
  
  parsed_page <- read_html(updated_page_source)
  dfWebScrapper$president <- parsed_page %>%  
        html_elements(xpath = "/html/body/div[2]/div[4]/div/section/div/section/div/div/div[1]/div[1]/div/div[2]/h3/a") %>%
        html_text()
  dfWebScrapper$date <- parsed_page %>%  
    html_elements(xpath = "/html/body/div[2]/div[4]/div/section/div/section/div/div/div[1]/div[2]/span") %>%
    html_text()  
  speech <- parsed_page %>%  
    html_elements(xpath = "/html/body/div[2]/div[4]/div/section/div/section/div/div/div[1]/div[3]") %>%
    html_text()  
  dfWebScrapper$speech <- gsub("\n", " ", speech)
  print(dfWebScrapper)
  return(dfWebScrapper)
  
}