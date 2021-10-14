# Data Visualization (October 8, 2021) Key
# Part 1 - 2D Static Plotting 
# Part 2 - 2D Interactive Plotting
# Part 3 - 3D Interactive Plotting, Web Scraping

# Just going over different types of graphing functions. 
# Documentation can be found at the following: 
# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/plot

# The working directory is the default location R will look for files you want to use
# It's also where R will put any files you save

# Let's set out working directory
setwd("~/Dropbox (University of Michigan)/Snitkin/codeclub/Session_5")

####### 2D Static Visuals #######

####### Base R  ########

# We'll be using data sets in base R 

# Determine the structure of the iris data and View the data frame

data(iris)     # loads the iris data set into your environment 
str(iris)      # displays structure/characteristics of the data
colnames(iris) # colnames best for dataframes/matrices
names(iris)    # names best for dataframes/vectors
View(iris)


# The plot() function in base R is very good for quickly looking at relationships in data
# Use the plot function in base R to plot the iris data
plot(iris)


# Add an argument to color the data by species
plot(iris, col = iris$Species)

# So this is a quick and dirty way to visualize trends and
# I can there are very distinct trends in Sepal.Length by species
# If I wanted to see which color is green I'd have to do more work
aggregate(Sepal.Length ~ Species, data=iris, max)

# I can't interact with the plot to get more info so we'll use
#   interactive plots to have fun today
# Before the interactive plots we'll get into more 2D static plots


####### GGPLOT2 Package: qplot  ########

# The qplot() function from the ggplot2 package is similar to the plot() function from base R 
# It is good for quickly exploring a data frame and allows you to make plots quickly without specifying a lot 
# Doesn’t provide access to full customization of all parameters.  

# install 'ggplot2' if you haven't already and load the package from the library

# install.packages(ggplot2)
library(ggplot2)

# You can find out how to use a function by inserting a "?" before the function:
?qplot
help(qplot)


# Visualize the Relationships Between Sepal Length and Sepal Width in the Iris dataset
qplot(data = iris, 
      x = Sepal.Width, 
      y = Sepal.Length)

# Use the color argument to add species data to the plot
qplot(data = iris, x = Sepal.Width, y = Sepal.Length, color = Species)

# Use the size argument to add Petal Length to the plot
qplot(data = iris, x = Sepal.Width, y = Sepal.Length, color = Species, size = Petal.Length)

# Map all of the variables in the data set using one plot
qplot(data = iris, x = Sepal.Length, y = Petal.Length, color = Sepal.Width, size = Petal.Width, shape = Species)



# Now that we've practiced using qplot with the iris data, try on your own with the airquality data
# So let's use qplot to visualize the relationship between ozone/temp in the airquality dataset
# Then use the color, size, and shape arguments to map Wind, Solar.R, and Month
data("airquality")  # loads airquality data into R environment
str(airquality)   

# What does the str function do?
# It tells us the object is type dataframe, there are 153 rows, 6 variables
# The variables are type integer and numeric 


# Did you get 'Error: A continuous variable can not be mapped...'?
# So basically, some aesthetics would prefer categorical variables rather than continuous
# Like there aren't enough shapes in the world to plot every single continuous item so we
# have to group the continuous variables some way
# So how can we change the structure of the variable from continuous to categorical to plot the data?

#Currently Month is characterized as type integer
airquality$Month <- as.factor(airquality$Month)

qplot(data = airquality, 
      x = Temp, 
      y = Ozone, 
      color = Wind, 
      size = Solar.R, 
      shape = Month)


# Change the x- axis title to 'Temperature' using the 'xlab' argument
# Find an argument to change the title of the plot to 'NY Air Quality Measurements'

qplot(data = airquality, 
      x = Temp, 
      y = Ozone, 
      color = Wind, 
      size = Solar.R, 
      shape = Month, 
      xlab = "Temperature", 
      main = "NY Air Quality Measurements") 


#### TIP ####
# dev.off() is a useful function to reset your graphics settings if you're getting errors while generating plots



####### GGPLOT2 Package: ggplot  ########

# ggplot2 is a package within the tidyverse collection that Emily went over last week
# It is very powerful for data visualization and one that I use all the time
# This is the basic documentation: ggplot(data = , aes(variable_to_plot)) + geom_type()
# Find more info here: https://www.r-graph-gallery.com/ggplot2-package.html

# So now I'd like you to use the ggplot() function to make a density plot of Petal.Length
ggplot(data = iris, aes(x = Petal.Length)) + 
  geom_density(fill = "Pink")


# Instead of just filling with a single color
# we can instead map the fill argument to a variable in our data frame using aes()
# So on the same graph, try to visualize the densities by species rather than all together
ggplot(data = iris, aes(x = Petal.Length)) + 
  geom_density(aes(fill = Species))


# In some cases it may be difficult to reasonably visualize all of the data on a single plot

#### TIP ####
# We can adjust the transparency to better visualize data when there is a lot on one plot
# Use the alpha argument to increase transparency

ggplot(data = iris, aes( x = Petal.Length)) + 
  geom_density(aes(fill = Species), alpha = 0.5)



#### TIP ####
# We can also generate individual plots for each category using the concept of faceting
# facet_wrap(~variable_to_facet)

?facet_wrap

# Example using the mpd dataset in base R
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = drv)) + 
  facet_wrap(vars(class), scales = "free")

# The tilde '~' is a unique symbol in facet_wrap that allows the function to separate the data 

#### TIP ####
# You can also use 'facet_wrap(vars())'

# What does the argument 'scales' do?

# Now use the iris data set to facet_wrap your density plot by Species 
# With density plots you can color underneath your plots by using "fill" instead of "color"
# What happens when you use "color?"

ggplot(data = iris, aes(x = Sepal.Length)) + 
  geom_density(aes(fill = Species), alpha = 0.5) + 
  facet_wrap(~Species, scales = "free")

# Here is another example of using facet_wrap 
# with data that has more categorical variables
# Warpbreaks is a knitting data set
str(warpbreaks)

ggplot(data = warpbreaks, aes(x = breaks)) + 
  geom_density(aes(fill = wool), alpha = 0.5) 

ggplot(data = warpbreaks, aes(x = breaks)) + 
  geom_density(aes(fill = wool), alpha = 0.5) + 
  facet_wrap(~warpbreaks$tension)


# What's great about ggplot is that you can 'layer' to make your graphs more complex
# Layering can simply be done using "+" like in the examples above
# Let's change the angle of the x-axis text to make it more visible
# Add the following to your plot above

# theme(axis.text.x = element_text(angle = 90))




# Let's continue layering using the warpbreaks data set with knitting data
# Please see the example below

#### TIP ####
# You can perform calculations on plots using the stat_summary function

# R understands built-in words like: mean, sum, etc. 
# In this example, we can visualize the mean breaks by wool type
# On your own try visualizing the standard deviation or 'sd'

# Statistical Summaries
ggplot(data = warpbreaks, aes(x = wool, y = breaks)) + 
  geom_point() +
  stat_summary(geom = "point", fun = "mean", color = "blue", size = 3, alpha = 0.5) +
  labs(caption = "Data Source: Base R", 
       title = "Knitting Breaks By Types of Wool")


# Wouldn't it be nice to hover over the plot to find the values of the means?
# This is what makes interactive plots cool!



#################################
#### 2D Interactive Visuals ####
################################

# For our interactive visuals let's play with a new dataset from the web
# You can retrieve data directly from an html table by using the tidyverse package 'rvest'
# https://github.com/tidyverse/rvest

# install.packages('rvest')  # Install the 'rvest' package

# library(rvest) # Retrieve from the library

# Get data from Wikipedia
library(rvest)

website <- read_html("https://en.wikipedia.org/wiki/COVID-19_pandemic_by_country_and_territory") 


# Let's work on getting this specific table: Total cases, deaths, and death rates by country (Our World in Data)

#### TIP ####
# Last time, we went over the piping operator ' %>% ' from the 'dplyr' package
# A shortcut on Mac to type the piping operator is 'Shift+Cmd+M'
# The shortcut on PC is 'Ctrl+Shift+M'

covid_tables <- website %>% html_table()  # retrieves all of the tables from the webpage

covid_table_10 <- covid_tables[[10]]      # retrieves the 10th table from the webpage


View(covid_table_10)
# Can you subset to get the columns of interest? 


covid_table_10 <- covid_table_10[,2:5]    # Some data cleaning


# The janitor package helps to further clean 'dirty' data
# install.packages("janitor")
# library(janitor)


# In R there are many naming styles but it is standard to name things using underscore or period
# So let's 'clean' the data table column names
# There's a dash in one of the columns which might make things weird later

#cleaning data table columns names
covid_table_10 <- covid_table_10 %>% clean_names()


# Let's look at the structure of the variable in the dataframe
# What is the structure of every variable?
str(covid_table_10)
# How can you change the datatype of the variables?

# The parse_number function is within the tidyverse package
# Parse_number will allow us to remove the commas in the numeric data 
# This will allow it to be read as numeric instead of character data

library(tidyverse)
covid_table_10[,c(2:4)]  <- apply(X = covid_table_10[, -c(1)], MARGIN = 2, FUN = parse_number) 

# So apply we might have touched on before is a function in base R
# X represents the data we want to work with
# What does the argument 'Margin = 2' mean?
# FUN is short for the function that we want to use
# So when looking at the data: What does -c(1) mean?

# How are c(2:4) and -c(1) similar in this example?
# So what does the apply function do overall?


# Now that we've cleaned the data, we can create a 2D interactive graph

####### Plotly Package  ########

# install.packages("plotly")
library(plotly)

# Like ggplot, plot_ly allows for more manual customization
# Install the plotly package and retrieve from the library
# The '::' helps to access a specific function from a specific package 
#   if you're working with multiple packages and stuff conflicts can occur


plotly::plot_ly(x = covid_table_10$cases, y = covid_table_10$deaths, type = "scatter", mode = 'markers', color = covid_table_10$country)  %>%
  layout(title = "Reported Cases vs Deaths by Country", 
         xaxis=list(title = "Reported Cases"), 
         yaxis = list(title = "Reported Deaths"), 
         #legend = list(orientation = 'h'), 
         plot_bgcolor = "Black", 
         paper_bgcolor = 'Black', 
         font = list(color = "White") 
  ) %>% 
  hide_legend()


# There are many points tightly packed together 
# How can we better visualize the data on the graph?
# Hint: You'll notice that the scales of the axes are very different.  


plotly::plot_ly(x = log(covid_table_10$cases), 
                y = log(covid_table_10$deaths), 
                type = "scatter", 
                mode = 'markers', 
                color = covid_table_10$country)  %>%
  layout(title = "Reported Cases vs Deaths by Country", 
         xaxis=list(title = "Reported Cases"), yaxis = list(title = "Reported Deaths"), 
         #legend = list(orientation = 'h'), 
         plot_bgcolor = "Black", 
         paper_bgcolor = 'Black', 
         font = list(color = "White") 
         ) %>% 
  hide_legend()




#################################
#### 3D Interactive Visuals ####
################################

# Complete cases is a great function to further clean data
# Compare covid_table_10 before and after 'complete.cases'
# What does the function do?
covid_table_10 <- covid_table_10[complete.cases(covid_table_10),]


# Now let's make everything 3D! 
# Remember to 'transform' your variables to make things easier to visualize
# Change your axis titles to indicate you've transformed your variables

plot_ly(covid_table_10, 
        x = ~log(deaths), 
        y = ~log(cases), 
        z = ~deaths_million, 
        color = ~country)  %>%
  layout(title = "Reported Cases vs Deaths vs Deaths/Million by Country", 
         scene = list(title = "Reported Deaths"), 
         yaxis = list(title = "Reported Cases"), 
         zaxis = list(title = "Deaths/Million")) %>% 
  layout(
    images = list(
      list(
        # Add images directly from a website 
        source =  "https://images.plot.ly/language-icons/api-home/r-logo.png?raw=true",
        # Adding '?raw=true' at the end of the link ensures that only the photo is taken from a website
        xref = "x",
        yref = "y",
        x = 0.2,
        y = 3,
        sizex = 2,   # changes the x-axis location of the image
        sizey = 2,   # changes the y-axis location of the image
        sizing = "stretch",
        opacity = 0.4,
        layer = "below"
      )
    )
  ) %>% 
  hide_legend()



# appending '?raw=true' at the end of the link ensures that only the photo is taken from a website


# There may be cross-sharing issues with scraping an image directly from a website. 
# You can also upload an image directly from your working directory
# Find an image and add it to your plot

# Adding image to plot background directly from computer

image_file <- "spongebob_PNG65.png" # <- change this line depending on your image

# The RCurl package helps to collect data from http 
# In this case, we'll use it to encode the image into a special base64 format
txt <- RCurl::base64Encode(readBin(image_file, "raw", file.info(image_file)[1, "size"]), "txt")

plot_ly(covid_table_10, 
        x = ~log(deaths), 
        y = ~log(cases), 
        z = ~deaths_million, 
        color = ~country)  %>%
  layout(title = "Reported Cases vs Deaths vs Deaths/Million by Country", 
         scene = list(title = "Reported Deaths"), 
         yaxis = list(title = "Reported Cases"), 
         zaxis = list(title = "Deaths/Million"), 
         images = list(
           list(
             # Add images
             source =  paste('data:image/png;base64', txt, sep=','),
             xref = "x",
             yref = "y",
             x = 0.2,
             y = 3,
             sizex = 3,
             sizey = 3,
             sizing = "stretch",
             opacity = 0.4,
             layer = "below"
           )
         )) %>% 
  hide_legend()


# DONE :)


