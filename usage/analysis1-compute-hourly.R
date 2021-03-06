library(ggplot2)

data <- read.table("simulation1-compute.csv", header=TRUE, sep=",")

hours = seq(0, 23)
data$hours = hours

ggplot(data=data, aes(x=Time, y=Compute)) +
  geom_line(aes(x = data$hours, y = data$X10, colour = "red")) +
  geom_line(aes(x = data$hours, y = data$X100, colour = "blue")) +
  geom_line(aes(x = data$hours, y = data$X200, colour = "green"))

ggsave("simulation1-compute-hourly.pdf")
