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

# Plot 2
png(filename="plot2.png", width=480, height=480)

par(mfrow=c(1,1))
plot(
  samples$datetime,
  samples$Global_active_power,
  type="l",
  ylab = "Global Active Power (kilowatts)",
  xlab = ""
)

dev.off()
