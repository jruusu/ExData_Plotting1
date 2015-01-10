library(data.table)
library(dplyr)
library(lubridate)

zipfile_url <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
zipfile <- "data/household_power_consumption.zip"
txtfile <- "data/household_power_consumption.txt"

# Ensure the zip file is available
if (! file.exists(zipfile)) download.file(zipfile_url, zipfile, method="curl")

# Ensure the zip file has been extracted
if (! file.exists(txtfile)) unzip(zipfile, exdir="data")

# For repeatability across locales, make sure we're using en_US.
Sys.setlocale("LC_TIME", "en_US.utf8")

# Read the dataset
dataset <- read.csv2(txtfile, dec=".", na.strings = "?", colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Select samples from the two specified dates, 2007-02-01 and 2007-02-02
samples <- subset(dataset, dataset$Date %in% c("1/2/2007", "2/2/2007"))

# Combine Date and Time into a single DateTime (POSIXct) column
samples <- mutate(samples, datetime = dmy_hms(paste(samples$Date, samples$Time)))

# Plot 4
png(filename="plot4.png", width=480, height=480)

par(mfcol = c(2,2))

with(samples, {
  plot(datetime, Global_active_power, type="l", ylab = "Global Active Power", xlab = "")

  plot(datetime, Sub_metering_1, type="l", ylab = "Energy sub metering", xlab = "")
  lines(samples$datetime, samples$Sub_metering_2, col="red")
  lines(samples$datetime, samples$Sub_metering_3, col="blue")  
  legend(
    "topright",
    c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    text.col = colors,
    col = colors,
    lty = 1, bty = "n"
  )  

  plot(datetime, Voltage, type="l")
  plot(datetime, Global_reactive_power, type="l")
})

dev.off()
