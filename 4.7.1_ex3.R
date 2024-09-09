setwd("/Users/natal/Documents/Purdue/Data_science_biol/DataSceinceRepo/lab1_unix/data")
nf<-read.table("Gesquiere2011_data.csv")
head(nf)


# load built-in dataset
data(trees)
# structure of a data frame
str(trees)

### Using the tree data frame and calculate: what’s the average height of the cherry tree?
avgHeight = mean(trees$Height)
print(avgHeight)
#76

###What is the average girth of those that are more than 75ft tall?
over75 = trees$Girth[75 > trees$Girth]
avgOver75 = mean(over75)  
print(avgOver75)
#13.24839

###What is the maximum height of trees with a volume between 15 and 35 ft^3?
VolumeSet = trees$Volume[15 < trees$Volume < 35]


###Read in Read in “Gesquiere2011_data.csv”, for male ID equal 3, 
#what’s the maximum GC value, what’s the mean T value?
nf<-read.table("Gesquiere2011_data.csv", header = TRUE)


###How many rows have GC larger than 50, and T larger than 100?

# read.table separated the table using "tab" separator
# but didn't interpret the first line as header
nf<-read.table("Gesquiere2011_data.csv", header = TRUE)
# read.csv can also be used
# but need to specify the correct separator
# default separator is comma
nf<-read.csv("Gesquiere2011_data.csv", sep = '\t')
nf<-read.csv("Gesquiere2011_data.csv", sep = ';')
nf<-read.csv("Gesquiere2011_data.csv", skip = 5)

##check
write.csv(trees, "trees.csv")
write.csv(trees,"trees.csv", append = TRUE)
read.csv("trees.csv", row.names = TRUE)
read.csv("trees.csv", col.names = FALSE)

dim(nf)
head(nf)
tail(nf)


