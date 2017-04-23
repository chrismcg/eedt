library(tm)

sent_data <- read.csv("chapter5/wal/kean-s_txt_sent_data_enron.csv", header=TRUE, sep=",")

sink(file="ch08_ex7.txt")

alldates <- format(as.Date(sent_data$date), '%Y-%m')

for (date in levels(factor(alldates))) {
  data <- sent_data[format(as.Date(sent_data$date), "%Y-%m") == date, ]
  source <- VectorSource(data$body)
  corpus <- Corpus(source)
  matrix <- TermDocumentMatrix(corpus, control = list(stopwords = TRUE, removeNumbers = TRUE, removePunctuation = TRUE))
  frequent_terms <- findFreqTerms(matrix, 100)
  print(date)
  print(nrow(data))
  print(frequent_terms)
}

in_data <- read.csv("chapter5/wal/kean-s_txt_inbox_data_enron.csv", header=TRUE, sep=",")

alldates <- format(as.Date(in_data$date), '%Y-%m')
for (date in levels(factor(alldates))) {
  data <- in_data[format(as.Date(in_data$date), "%Y-%m") == date, ]

  source <- VectorSource(data$body)
  corpus <- Corpus(source)
  matrix <- TermDocumentMatrix(corpus, control = list(stopwords = TRUE, removeNumbers = TRUE, removePunctuation = TRUE))
  frequent_terms <- findFreqTerms(matrix, 300)
  print(date)
  print(nrow(data))
  print(frequent_terms)  
}

