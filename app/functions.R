createPhyActTable <- function(data){
  m <- matrix(nrow = 3, ncol = 2)
  colnames(m) <- c("val","Freq")
  #rownames(m) <- c(0, 8.75, 17.5)
  #cat(sum(data < 8.75), " : ",
  #    sum(data >= 8.75), " : ",
  #    sum(data >= 17.5), "\n")
  
  m[1,1] = 0
  m[1,2] = nrow(data[data$total_mmet < 8.75,]) # sum(data < 8.75)
  m[2,1] = 8.75
  m[2,2] = nrow(data[data$total_mmet >= 8.75,]) # sum(data >= 8.75)
  m[3,1] = 17.5
  m[3,2] = nrow(data[data$total_mmet >= 17.5,]) # sum(data >= 17.5)
  #todel <- m
  m <- as.data.frame(m)
  m
}

lookup_table <- function(data, ag){
  
  var <- ag$V2[match(data, ag$V1)]
  var
}

format_function <- "#! function() {
        var fraction  = this.y / this.series.yAxis.max * 100;
        if (fraction > 20){
              return Math.round(this.y);
        }else{
            return null;
        }
      }!#"

getSeriesName <- function( EQ, EB){
  nEQ <- "Off"
  if (EQ == 1)
    nEQ <- "On"
  
  nEB <- "Off"
  if (EB == 1)
    nEB <- "On"
  # cat(EQ, " : ", EB, "\n")
  paste("EQ:", nEQ, "& EB:", nEB, sep = " ")
  
}

appendMissingFrequencies <- function( df1, df2){
  missingModes <- setdiff(df1[,2], df2[,1])
  if (nrow(df2) < 8){
    for (i in (1:length(missingModes))){
      df2 = rbind(df2,c(missingModes[i], 0))
    }
  }
  df2
}


#(tripTime, tripMode, "MS64_ebik1_eq1", 2)

getModeSpecificTrips <- function(data1, data2, columnName, mn){
  
  data1[is.na(data1)] <- 0
  
  temp <- data.frame(rn = data1$X)
  
  locatTripModeData <- data2[,c("X","baseline", columnName)]
  
  locatTripModeData <- (subset(locatTripModeData, (X %in% temp$rn) ))
  
  localtripData <- data1[,c("X","baseline", columnName)]
  
  localtripData <- data.frame(rn = localtripData$X, diff = ((localtripData[[columnName]] - localtripData$baseline) / localtripData$baseline ) * 100)
  
  localtripData <- subset(localtripData, diff <= 200 & diff >= -200 )
  
  locatTripModeData <- subset(locatTripModeData, (X %in% localtripData$rn) )
  
  names(locatTripModeData)[names(locatTripModeData)=="X"] <- "rn"
  localtripData <- dplyr::inner_join(localtripData, locatTripModeData, by = "rn")
  
  wtrips <- subset(localtripData, baseline == mn)
  
  wtrips
  
  
}