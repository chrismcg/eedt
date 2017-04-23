source('chapter5/wal/analysis/common.r')

getwd()
from <- inbox_data['from']
colnames(from)[1] <- 'mail'
to <- sent_data['to']
colnames(to)[1] <- 'mail'
all <- rbind(from,to)
counted <- data.frame(table(all))
sorted <- counted[order(counted['Freq'],decreasing=TRUE),]
print(sorted[0:20,])
