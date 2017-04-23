source('chapter5/wal/analysis/common.r')

from <- data.frame(table(inbox_data['from']))
to <- data.frame(table(sent_data['to']))

mails <- union(from$Var1, to$Var1)
df <- data.frame(email=NA,ratio=0)
for (mail in mails) {
  to_count <- to[to$Var1 == mail,]$Freq
  from_count <- from[from$Var1 == mail,]$Freq 
  ratio <- to_count/from_count
  if (length(ratio) == 0) {ratio <- 0}
  row <- c(mail, ratio)
  df <- rbind(df, row)
}
df <- transform(df, ratio = round(as.numeric(ratio),digits=3))
df <- df[df$ratio!=0,]
data <- df[order(df['ratio'],decreasing=TRUE),]
print(data)
