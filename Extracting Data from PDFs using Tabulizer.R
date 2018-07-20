library("tabulizer")

# The file could be local, or it could be on the web.
# We're going to use 
# Lane, K., Pomeroy, E. & Davila, M. (2018). Over Rock and Under Stone: Carved Rocks and Subterranean Burials at Kipia, Ancash, AD 1000 – 1532. Open Archaeology, 4(1), pp. 299-321. Retrieved 20 Jul. 2018, from doi:10.1515/opar-2018-0018

location <- 'https://www.degruyter.com/downloadpdf/j/opar.2018.4.issue-1/opar-2018-0018/opar-2018-0018.pdf'

# Next, let's grab the data in Table 1. This is on pg 6 of the pdf.
# The line below will open a window in the viewer on the right side
# of RStudio, and open pg 6 there. Drag and click a box over the 
# table to extract. Be careful to grab the table, and only the table.

data <- extract_areas(location, 6) 

# We can examine the first bit of data that we've extracted with the 'head' command.
head(data)

# We can save our data to another variable just in case we mess something up.

orig_data <- data # in case of trouble

# Now let's clean this up; right now it's a list with text, not a dataframe with numbers.
# save header
h <- data[[1]][1,]
# remove header in the table
data[[1]] <- data[[1]][-c(1,2),]

# let's examine the data again. 
head(data)

#Notice anything different than last time we ran the head command?

# Now we turn it into a dataframe, and tell it that h, the header, is our column headers.
datadf <- setNames(as.data.frame(do.call("rbind", data), stringsAsFactors = FALSE), h)
str(datadf)

View(datadf)

# ta da!

## Now let's plot something
library("ggplot2")

# data is all chr, so we have to turn it into numeric

#first we look in the C14 column for things that match digits
years <- regexpr("[[:digit:]]{3}",datadf[["C14"]])

#then we tell R that those digits are data type numeric
datadf$years <- as.numeric(regmatches(datadf[["C14"]], years))
datadf$RegPerc <- as.numeric(gsub("%", "", datadf$Pit))

#now we can make a scatter plot

ggplot(datadf, aes(x=Pit, y=C14)) +
  geom_point(shape=1) 

##
# We can get Tabulizer to extract all of the tables it finds automatically:
tab1 <- extract_tables(location)
str(tab1)
