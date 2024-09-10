# Header ------------------------------------------------------------------
# Assignment name: Assignment3_RDataFram
# Author name: Natalie Allen
# Date: September 10, 2024
# Notes:

# File setup --------------------------------------------------------------

# set working directory below
setwd("/Users/natal/Documents/Purdue/Data_science_biol/DataSceinceRepo/lab1_unix/data")
# load libraries below

# Exercise 3 --------------------------------------------------------------

### Question 1
# load built-in dataset
data(trees)
# structure of a data frame
str(trees)

### Using the tree data frame and calculate: what’s the average height of the cherry tree?
#mean of Height in trees
avgHeight = mean(trees$Height)
print(avgHeight)
#76

### Question 2
###What is the average girth of those that are more than 75ft tall?
#subset data for trees over 75ft tall and get the girth
over75 = trees$Girth[trees$Height > 75]
#get mean girth
avgOver75 = mean(over75)
print(avgOver75)
#14.51176

### Question 3
###What is the maximum height of trees with a volume between 15 and 35 ft^3?
#subset data for trees with volume between 15 and 35; get height of those trees
VolumeSet = trees$Height[trees$Volume > 15 & trees$Volume < 35]
#get max height 
maxHeight = max(VolumeSet)
print(maxHeight)
#86 is the max height

### Question 4
###Read in “Gesquiere2011_data.csv”,
#for male ID equal 3, what’s the maximum GC value, what’s the mean T value?
#read in csv
nf<-read.csv("Gesquiere2011_data.csv", sep = '\t')
head(nf)

#subset nf for male ID 3
maleID_3 <- nf[nf$maleID == 3, ]
print(maleID_3)

#get maximum GC value
max(maleID_3$GC)
#136.31 maximum GC value for male ID 3

#get mean T value
mean(maleID_3$T)
#149.0377 mean T value for male ID 3


### Question 5
###How many rows have GC larger than 50, and T larger than 100?
#subset data for GC > 50 and T >100
RowSubset <- nf[nf$GC > 50 & nf$T > 100, ]

#count number of rows in subset
numRows <- nrow(RowSubset)
print(numRows)
#1117 rows with GC larger than 50, and T larger than 100
