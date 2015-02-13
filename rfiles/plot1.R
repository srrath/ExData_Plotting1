
library (sqldf)
#df_input <- read.table("expldata/data/household_power_consumption.txt",header = TRUE,sep = ";",na.strings = "?")
df_input <- read.csv.sql("./git/ExData_Plotting1/data/household_power_consumption.txt",
                         header = TRUE,sep = ";",sql ="Select * from file where Date = '1/2/2007' OR Date = '2/2/2007'")

# Convert the Date column to Date variable
df_input<- transform (df_input, Date=as.Date(Date,"%m/%d/%Y"))

# Add a column with date timestamp

df_input$Date_Ts<- strptime(paste(df_input$Date,df_input$Time), "%Y-%m-%d %H:%M:%S")

#Plot for Global Active Power and send it to png file
#Chose the graphic device
png(file = "./git/ExData_Plotting1/figure/plot1.png", width = 480, height = 480, units = "px")

#create the Plot
hist(df_input$Global_active_power, col="red", main ="Global Active Power", 
     xlab="Global Active Power(kilowatts)", ylab = "Frequency")
dev.off()



