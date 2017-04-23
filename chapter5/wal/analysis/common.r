library(ggplot2)
library(mailminer)
library(tidyverse)
library(stringr)

inbox_data <- read.table("chapter5/wal/kean-s_inbox_data_enron.csv", header=TRUE, sep=",")
sent_data <- read.table("chapter5/wal/kean-s_sent_data_enron.csv", header=TRUE, sep=",")
