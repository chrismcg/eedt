source('chapter5/wal/analysis/common.r')

inbox_count <- times_count(times=inbox_data['date'], element="%H")
sent_count <- times_count(times=sent_data['date'], element='%H')

hours_of_day <- str_pad(seq(0,23),2,"left",0)

df <- data.frame(hours=factor(hours_of_day, levels=hours_of_day),inbox=inbox_count,sent=sent_count)

ggplot(data=df) + scale_shape_manual(name="Mailbox", values=c(2,3)) +
  geom_point(aes(x=hours,y=inbox, shape='inbox')) +
  geom_smooth(aes(x=hours,y=inbox, group=1)) +
  geom_point(aes(x=hours,y=sent, shape='sent')) +
  geom_smooth(aes(x=hours,y=sent, group=2)) +
  scale_y_continuous('number of emails') +
  scale_x_discrete('hour of day')
