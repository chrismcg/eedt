library(ggplot2)

data <- read.table("simulation1-reads.csv", header=TRUE, sep=",")
mean <- apply(data, 2, mean)
median <- apply(data, 2, median)
max <- apply(data, 2, max)
df <- data.frame(population=seq(from = 10, to = 200, by = 10), mean=mean, median=median, max=max)
                 
ggplot(data = df) + scale_shape_manual(name="Type", values = c(2, 3, 4)) +
  geom_smooth(aes(x = population, y = mean)) +
  geom_point(aes(x = population, y = mean, shape = "mean")) +
  geom_smooth(aes(x = population, y = median)) +
  geom_point(aes(x = population, y = median, shape = "median")) +
  geom_smooth(aes(x = population, y = max)) +
  geom_point(aes(x = population, y = max, shape = "max")) +
  scale_y_continuous("reads") +
  scale_x_continuous("customers")

ggsave("simulation1-reads.pdf")
