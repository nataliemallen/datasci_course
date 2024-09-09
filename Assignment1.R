# Header ------------------------------------------------------------------
# Assignment name: Assignment 1   
# Author name: Natalie Allen  
# Date: August 26, 2024
# Notes:

# File setup --------------------------------------------------------------

# set working directory below
setwd("/Users/natal/Documents/Purdue/Data science course/")

# load libraries below


# Exercise 1 --------------------------------------------------------------

### Question 1
z <- seq(2, 100, by = 2)
z
#[1]   2   4   6   8  10  12  14  16  18  20  22  24  26  28  30  32  34  36  38  40  42  44  46  48  50  52  54  56  58  60  62  64
#[33]  66  68  70  72  74  76  78  80  82  84  86  88  90  92  94  96  98 100

### Question 2
y = z[z %% 12 == 0]
y # 12 24 36 48 60 72 84 96
length(y) #8
# 8 elements match

### Question 3
sum(z)
#2550

### Question 4
51*50 #2550
51*50 == sum(z) #TRUE
#yes, 51*50 is also 2550

### Question 5
z[5]*z[10]*z[15]
#6000

### Question 6
z^2
# [1]     4    16    36    64   100   144   196   256   324   400   484   576   676   784   900  1024  1156  1296  1444  1600  1764
#[22]  1936  2116  2304  2500  2704  2916  3136  3364  3600  3844  4096  4356  4624  4900  5184  5476  5776  6084  6400  6724  7056
#[43]  7396  7744  8100  8464  8836  9216  9604 10000
#squares each number in z

### Question 7
y <- seq(0, 30, by = 3)
y
# [1]  0  3  6  9 12 15 18 21 24 27 30

intersect(z, y)
###6 12 18 24 30

### Question 8
seq(2, 100, by = 2)
(1:50)*2

seq(2, 100, by = 2) == (1:50)*2 #TRUE
#yes, they produce the same vectors

# Exercise 2 --------------------------------------------------------------

### Question 1
A <- matrix(1:10, 10, 5)
A
#[,1] [,2] [,3] [,4] [,5]
#[1,]    1    1    1    1    1
#[2,]    2    2    2    2    2
#[3,]    3    3    3    3    3
#[4,]    4    4    4    4    4
#[5,]    5    5    5    5    5
#[6,]    6    6    6    6    6
#[7,]    7    7    7    7    7
#[8,]    8    8    8    8    8
#[9,]    9    9    9    9    9
#[10,]   10   10   10   10   10


### Question 2
Z <- array(dim=c(5,5,2))
Z[,,1] <- A[1:5, 5]
Z[,,1]
#[,1] [,2] [,3] [,4] [,5]
#[1,]    1    1    1    1    1
#[2,]    2    2    2    2    2
#[3,]    3    3    3    3    3
#[4,]    4    4    4    4    4
#[5,]    5    5    5    5    5
Z[,,2] <- A[6:10, 5]
Z[,,2]
#[,1] [,2] [,3] [,4] [,5]
#[1,]    6    6    6    6    6
#[2,]    7    7    7    7    7
#[3,]    8    8    8    8    8
#[4,]    9    9    9    9    9
#[5,]   10   10   10   10   10

### Question 3
x <- c("n30","n101","n140")
class(x) #character

x <- sub("n", "", x)
x
#[1] "30"  "101" "140"

x <- as.numeric(x)
class(x) #numeric

# Helpful info ------------------------------------------------------------

# Using Ctrl+Shift+R (Cmd+Shift+R on the Mac) creates new sections which are an easy way to organize
# scripts. You can also use them to navigate around very large scripts whith the stacked line icon in
# the top right of the script window.


# Using Ctrl+Shift+C (Cmd+Shift+C on the Mac) creates multiple commented out lines (e.g., # ) and allows you
# to type longer text segments and then comment them out as a group.
