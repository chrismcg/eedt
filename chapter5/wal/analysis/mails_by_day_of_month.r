source('chapter5/wal/analysis/common.r')

inbox_count <- dates_count(dates=inbox_data['date'], element='%d')
sent_count <- dates_count(dates=sent_data['date'], element='%d')

days_of_month <- str_pad(seq(1,31),2,"left",0)

df <- data.frame(days=factor(days_of_month, levels=days_of_month),inbox=inbox_count,sent=sent_count)

ggplot(data=df) + 
  scale_shape_manual(name="Mailbox", values=c(2,3)) +
  geom_point(aes(x=days,y=inbox, shape='inbox')) +
  geom_smooth(aes(x=days,y=inbox, group=1)) +
  geom_point(aes(x=days,y=sent, shape='sent')) +
  geom_smooth(aes(x=days,y=sent, group=2)) +
  scale_y_continuous('number of emails') +
  scale_x_discrete('day of month')
