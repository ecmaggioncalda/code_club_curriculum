#Tidyverse Data Cleaning Basics - Tips & Tricks
#Just going to go over some functions that I use a lot in tidyverse to get my data into the shape I need it for analysis
#A super amazing resource is https://www.rstudio.com/resources/cheatsheets/
#They have cheatsheets for a lot of the major packages in RStudio, including packages that are part of tidyverse
#Some of these files have been uploaded to this code club folder (2021.09.20), but go to the website for the most recent versions if doing this in the future

#LIBRARIES ----
library(tidyverse)

#LOAD FILES ----
###reference the data-import.pdf
#load cytokine data file
cytokine_data <- read_csv("cytokine_data.csv")

#load accessory data file
extra_data <- read_csv("extra_data.csv")

#view structure
str(cytokine_data)
str(extra_data)

#GENERAL NOTES ----
#Note 1: tidyverse deals in a data-frame-like structure called tibbles; tibbles do not use row names, and instead use index columns as part of their data sorting and cleaning. This can be an adjustment if you're used to sorting and selecting by row-names, and some functions outside of tidyverse will still require row-names as part of a data-frame, but within tidyverse they aren't necessary and will be dropped during manipulations, so make sure you start out with something you can use as an index column because they won't be preserved through some manipulations

#Note 2: tidyverse uses piping, which is like daisy-chaining several functions into one series of manipulations
#piping makes it easy to read out what step-wise actions are being taken to manipulate a data set, and performs these without needing intermediate objects in your environment
#piping uses %>% to indicate that the following function is going to be performed on the prior data set, for example:

cytokine_data %>%
  view()

#this means I want to use the view() command on my cytokine_data object, and I open up the cytokine_data object in a new window
#this performs the same function as view(cytokine_data) but when performing multiple functions in a series, it is much easier for readability to pipe them, for example:

view(drop_na(extra_data, "IDSA_severe_mod"))

#vs

extra_data %>%
  drop_na(IDSA_severe_mod) %>% #drops all rows that have NA in IDSA_severe_mod column
  view()

#the piped version is easier to read what is happening in a sequence, and this is especially true as more manipulations are added

#Notice also that when piping and calling a column name, it isn't placed in quotes
#In piping, it is treated as an object of the data frame, so does not need to be specified with quotes, but you can if you want

#Note 3: There are some functions that I still use base R for, and a lot of the time tidyverse seems to play nice with base R functions, but not everything may work in a pipe
#Example of one base R function that can be useful that will pipe

cytokine_data %>%
  select(serum_TNFa,
         serum_CXCL.9) %>%
  colSums()

#DATA TIDYING ----
###reference the tidyr.pdf
#Pivot ----
#For some functions like ggplot, it is easier to work with the data in "long" form as opposed to "wide" form
#This means for the cytokine data, we would need to convert the different cytokines into their own variable with multiple levels, and then have a separate column of values
#We would go from 35 columns, to 4 columns (genome_id, clade, cytokine, and value)

pivoted_cytokine_data <- cytokine_data %>%
  pivot_longer(grep("serum|stool", colnames(cytokine_data), value = TRUE), #select which columns to pivot
               values_to = "Measure", #determines the name of the column where the column values are all binned
               names_to = "Cytokine") #determines the name of the column where are the column names are binned

pivoted_cytokine_data %>%
  view()

#If we have a data set in long form where we would prefer to break up a specific variable into separate columns, this can be performed using pivot_wider
#This could be necessary if you have a categorical variable Y with levels "a" "b" & "c", and an identity column X, and want to convert it to a data frame with one row per identity X, and have three columns with binary 0/1 if the value is "a" "b" &/or "c"

#DATA VISUALIZATION ----
###reference the data-visualization.pdf
#ggplot ----
#Lets get an overall view of the data distributions
pivoted_cytokine_data %>%
  ggplot(aes(x = Cytokine,
             y = Measure)) + #with ggplot, to specify different layers of aesthetics we use +, instead of %>%, since we are adding on top of the previous thing
  geom_point()

#You'll get an error that says there were missing values that were excluded
#If we want to clean up these missing values prior to ggplot, we can pipe in the drop_na function

pivoted_cytokine_data %>%
  drop_na(Measure) %>% #Specifies I only want to drop rows that are NA in the Measure column
  ggplot(aes(x = Cytokine,
             y = Measure)) +
  geom_point()

#Practice: Try using the aes() values in geom_point to 1) change the color of the dots to something other than black, 2) change the color of the dots based on the clade value (hint: this will require using as.factor())



#DATA TRANSFORMATION ----
###reference the data-transformation.pdf

#Merge ----
#Goal: merge together the cytokine_data and extra_data data frames into one data set

#tidyverse has several different ways to combine different data frames:
#bind_rows -> add two tables on top of each other, needs to have the same column names
#bind_cols -> combine two tables next to each other, there is no relational data here, data needs to be in the proper order before binding
#relational joins -> joining tables by matching column and row values; there are several different versions of these joins, but the important thing is that these will preserve relationships between variables given an identity column, or several identity columns

#Practice Part A) Find the column(s) in each data frame that are in common using intersect() & colnames()

#Practice Part B) Determine that the matching columns are of the same type (numeric vs. character) (using str())
#Note: Here this step is unnecessary because they are of the same type, but this is good practice since they may not always be
#If they aren't we can use the mutate function to fix this so the data frames will be able to merge (see mutate section)

#Practice Part C) Combine them using full_join() into a data frame called full_data

#full_data <- 

#Summarize ----
#The summarize function takes input columns and functions and summarizes it down to a single value

#The across() function instructs R to perform the same function over several columns, determined by selection criteria
#selection criteria can be a grep for columns with certain naming criteria, a vector of column names, or put everything() to perform the summary function across all columns in the tibble

#If using a vector to select columns, specify this by using the all_of() function to indicate that you want to select all of the names from the vector, and are not selecting a column of that name

#Note: Both across() and all_of() are super useful functions across a lot of tidyverse functions, wherever there is some sort of selection of column names these functions are applicable

#Ex.1 determine how many NA values are in each column of the data set
full_data %>%
  summarize(across(everything(), ~sum(is.na(.x)))) %>%
  view()

#Ex.2 determine the mean value of each cytokine value
cytokine_cols <- grep("serum|stool", colnames(full_data), value = TRUE)

full_data %>%
  summarize(across(all_of(cytokine_cols), ~mean(.x))) %>%
  view()

#Practice Problem: using drop_na(), drop all rows where IDSA_severe_mod is NA, and then find the max cytokine value for serum_TNFa

#Filter----
#use a logical expression to determine rows to keep based on a column value

#filter will only include cases where the logical expression is true
#this means it will also drop NA values, which it will not give a warning for
#if you don't want it to drop NA values, and still want to filter by a specified value, include a second expression

#Practice: filter full_data to include only clade 2 strains. Repeat this exercise so that clade NA strains are not dropped as well.

#Mutate ----
#Mutate is similar to summarize in the way it is structured, but it instead can alter column values, create new columns, or remove columns

#drop a column with mutate
full_data %>%
  mutate(clade = NULL) %>%
  #select(!clade) %>% #this is another way to perform the same task using select instead
  view()

#convert column values from character to numeric
cytokine_data %>%
  filter(clade != "cryptic") %>%
  mutate(clade = as.numeric(clade)) %>%
  str()

#Practice problem: using the replace() function and the across() function, replace all negative values in the cytokine columns with 0, create new object, full_data2

#full_data2 <-

#Sample ----
#if you want to take a random sample of your data, use slice_sample() and specify either the proportion of the data to collect, or the absolute number of samples you want to select

#Practice: from full_data2, 1) select only your serum cytokine columns, 2) drop any rows of cytokine columns that contain NA, 3) sample half the remaining samples, 4) find the mean cytokine value for each serum cytokine

