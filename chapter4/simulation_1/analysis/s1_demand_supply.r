library(ggplot2)


data <- read.table("chapter4/simulation_1/analysis/demand_supply.csv", header=T, sep=",")

pdf("chapter4/simulation_1/analysis/demand_supply.pdf")
ggplot(data = data) + scale_colour_grey(name="Legend", start=0, end=0.6) +
  geom_line(aes(x  = data$Time, y = data$Demand, color = "demand")) +
  geom_line(aes(x  = data$Time, y = data$Supply, color = "supply")) +
  scale_y_continuous("Demand") +
  scale_x_continuous("Time")
dev.off()
