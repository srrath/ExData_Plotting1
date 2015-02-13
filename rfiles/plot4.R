library(sqldf)
library(reshape2)

#df_input <- read.table("expldata/data/household_power_consumption.txt",header = TRUE,sep = ";",na.strings = "?")

df_input <- read.csv.sql("./git/ExData_Plotting1/data/household_power_consumption.txt",
                        colClasses = c('character', 'character', 'numeric',  'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric'), 
                        header = TRUE,sep = ";",sql ="Select * from file where Date = '1/2/2007' OR Date = '2/2/2007'")

# Convert the Date column to Date variable
df_input<- transform (df_input, Date=as.Date(Date,"%d/%m/%Y"))

# Add a column with date timestamp

df_input$Date_Ts<- strptime(paste(df_input$Date,df_input$Time), "%Y-%m-%d %H:%M:%S")



#Plot for Global Active Power and send it to png file
#Melt the dataset by "Sub_metering_1"        "Sub_metering_2" and "Sub_metering_3"


#subset based to have only Date_Ts, Sub_metering_1,2,3
df_input_mlt <- df_input[,c(10,7,8,9)]


# need to conver to character for melt function to work fine.. but ideally it should have been worked without cast.
df_input_mlt$Date_Ts <- as.character(df_input_mlt$Date_Ts)



df_mlt<-melt(df_input_mlt, id =c("Date_Ts"), measure.vars=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
             variable.name="Sub_metering", 
             value.name="Sub_metering_value",
             factorsAsStrings=TRUE)

#cast it back to Date timestamp for graph
df_mlt$Date_Ts <- strptime(df_mlt$Date_Ts, "%Y-%m-%d %H:%M:%S")


#Chose the graphic device
png(file = "./git/ExData_Plotting1/figure/plot4.png", width = 480, height = 480, units = "px",type="cairo-png", )


#set the global variable for no of rows and cols in plot
par(mfrow=c(2,2))

#set the margin
par(mar= c(4,4,2,2))

#Plot-1

plot(x = df_input$Date_Ts, y=df_input$Global_active_power, type="l", xlab = "", ylab = "Global Active Power(Killow Watts)")

#Plot-2

plot(x = df_input$Date_Ts, y=df_input$Voltage, type="l", xlab = "datetime", ylab = "Voltage")

#Plot-3

with(df_mlt, plot(Date_Ts,Sub_metering_value, xlab = "", ylab = "Energy Sub metering",  type="n"))
with(subset(df_mlt,Sub_metering=="Sub_metering_1" ), points(Date_Ts,Sub_metering_value,type="l",col="black"))
with(subset(df_mlt,Sub_metering=="Sub_metering_2" ), points(Date_Ts,Sub_metering_value,type="l", col="red"))
with(subset(df_mlt,Sub_metering=="Sub_metering_3" ), points(Date_Ts,Sub_metering_value, type="l",col="blue"))
legend("topright",lty=1,col=c("black", "red", "blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#Plot-4
plot(x = df_input$Date_Ts, y=df_input$Global_reactive_power, type="l", xlab = "datetime", ylab = "Global_Reactive_Power")

dev.off()



