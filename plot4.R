##Loading the data - We will only be using data from the dates 2007-02-01 and 2007-02-02. 
##One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.

file2read<-file("household_power_consumption.txt");
##regular expression "^[1,2]/2/2007"
###^ means starts with 
###[1,2] is a set of possible characters for the next character - so this
###will find 1/2/2007 or 2/2/2007 which matches dd/mm/yyyy format for
###specified range of 2007-02-01 and 2007-02-02 (Feb 1st or 2nd)

power <- read.table(text = grep("^[1,2]/2/2007",readLines(file2read),value=TRUE), sep=";", na.strings = "?" )
colnames(power) = c('Date','Time','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3')

str(power)
#'data.frame':  2880 obs. of  9 variables:
#$ Date                 : Factor w/ 2 levels "1/2/2007","2/2/2007": 1 1 1 1 1 1 1 1 1 1 ...
#$ Time                 : Factor w/ 1440 levels "00:00:00","00:01:00",..: 1 2 3 4 5 6 7 8 9 10 ...
#$ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
#$ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
#$ Voltage              : num  243 243 244 244 243 ...
#$ Global_intensity     : num  1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1 ...
#$ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#$ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
#$ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...

##You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
power$Date <- as.Date(power$Date, "%d/%m/%Y")
head(power$Date)
#[1] "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01"
head(power$Time)
#[1] 00:00:00 00:01:00 00:02:00 00:03:00 00:04:00 00:05:00
#1440 Levels: 00:00:00 00:01:00 00:02:00 00:03:00 00:04:00 00:05:00 00:06:00 ... 23:59:00
#concatenate the date & time together and convert to POSIXlt
power$datetime <- mapply(paste,power$Date,power$Time)
power$datetime =strptime(power$datetime, "%Y-%m-%d %H:%M:%S")
str(power$datetime)
# POSIXlt[1:2880], format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 00:02:00" ...

##PLOT 4 4 plots adding Global Active Power Line Chart
png(filename = "plot4.png", width = 480, height = 480)
  par(mfrow = c(2, 2))
  #1
  plot(power$datetime, power$Global_active_power, ylab="Global Active Power", xlab = NA, type = "l")
  #2
  plot(power$datetime, power$Voltage, ylab="Voltage", xlab = "datetime", type = "l")
  #3
  with(power, plot(datetime, Sub_metering_1, ylab = "Energy sub metering", xlab=NA, type = "n")) #type=n sets up plot without data
  with(power, points(datetime, Sub_metering_1, col = "black" ,type = "l"))
  with(power, points(datetime, Sub_metering_2, col = "red", type = "l"))
  with(power, points(datetime, Sub_metering_3, col = "blue", type = "l"))
  legend("topright", bty = "n", lty=1, col = c("black", "blue", "red"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  #4
  plot(power$datetime, power$Global_reactive_power, ylab = "Global_reactive_power", xlab = "datetime", type = "l")
dev.off()
par(mfrow = c(1, 1))