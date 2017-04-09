library(ggplot2)
data <- read.table("chapter4/simulation_1/analysis/price_demand.csv", header=T, sep=",")

pdf("chapter4/simulation_1/analysis/price_demand.pdf")
ggplot(data = data) + scale_colour_grey(name="Legend", start=0, end=0.6) +
  geom_line(aes(x  = data$Time, y = data$Average_Price, color = "price")) +
  geom_line(aes(x  = data$Time, y = log2(data$Demand)-3, color = "demand"))
dev.off()