library(sqldf)

#df_input <- read.table("expldata/data/household_power_consumption.txt",header = TRUE,sep = ";",na.strings = "?")

df_input <- read.csv.sql("./git/ExData_Plotting1/data/household_power_consumption.txt",
                        colClasses = c('character', 'character', 'numeric',  'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric'), 
                        header = TRUE,sep = ";",sql ="Select * from file where Date = '1/2/2007' OR Date = '2/2/2007'")

# Convert the Date column to Date variable
df_input<- transform (df_input, Date=as.Date(Date,"%d/%m/%Y"))

# Add a column with date timestamp

df_input$Date_Ts<- strptime(paste(df_input$Date,df_input$Time), "%Y-%m-%d %H:%M:%S")


#Chose the graphic device
png(file = "./git/ExData_Plotting1/figure/plot2.png", width = 480, height = 480, units = "px")

#Plot for Global Active Power and send it to png file

plot(x = df_input$Date_Ts, y=df_input$Global_active_power, type="l", xlab = "", ylab = "Global Active Power(Killow Watts)")
dev.off()

