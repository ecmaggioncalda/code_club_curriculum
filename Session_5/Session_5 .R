# Data Visualization (October 8, 2021)
# Part 1 - 2D Static Plotting 
# Part 2 - 2D Interactive Plotting
# Part 3 - 3D Interactive Plotting, Web Scraping

# Just going over different types of graphing functions. 
# Documentation can be found at the following: 
# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/plot

#################################
####### 2D Static Visuals #######
################################



########### Base R  ###########

# We'll be using data sets in base R 

# Determine the structure of the iris data and View the dataframe
data("iris")
str(iris)
View(iris)

# The plot() function in base R is very good for quickly looking at relationships in data
# Use the plot function in base R to plot the iris data



# Add an argument to color the data by species



####### GGPLOT Package  #########

# The qplot() function from the ggplot2 package is similar to the plot() function 
# It is good for quickly exploring a data frame without specifying a lot 
# Like the plot function, it doesn’t provide access to full customization of all parameters.  

# install 'ggplot2' if you haven't already and load the package from the library



# You can find out how to use a function by inserting a "?" before the function:
?qplot
help(qplot)


# Visualize the Relationships Between Sepal Length and Sepal Width in the Iris Dataset
qplot(data = iris, 
      x = Sepal.Width, 
      y = Sepal.Length)

# Use the color argument to add species data to the plot


# Use the size argument to add Petal Length to the plot


# Map all of the variables in the data set using one plot



# Use qplot to visualize the relationship between ozone/temp in the airquality dataset
# Then use the color, size, and shape arguments to map Wind, Solar.R, and Month

data("airquality")



# Did you get 'Error: A continuous variable can not be mapped...'?
# How can you change the structure of the variable to plot the data?




# Change the x- axis title to 'Temperature' using the 'xlab' argument
# Find an argument to change the title of the plot to 'NY Air Quality Measurements'



#### TIP ####
# Are you getting errors while generating plots?
# dev.off() is a useful function to reset your graphics settings




####### GGPLOT Package  ########

# ggplot2 is a package within the tidyverse collection 
# It is very powerful for data visualization
# This is the documentation: ggplot(data = , aes(variable_to_plot)) + geom_type()
# Find more info here: https://www.r-graph-gallery.com/ggplot2-package.html



# We'll use the ggplot() function to make a density plot of Petal.Length
ggplot(data = iris, aes(x = Petal.Length)) + 
  geom_density(fill = "Pink")




# On the same graph, visualize the densities by species rather than all together




#### TIP ####
# We can adjust the transparency to better visualize data when there is a lot on one plot
# Use the alpha argument to increase transparency
ggplot(data = iris, aes(x = Petal.Length)) + 
  geom_density(aes(fill = Species), alpha = 0.5)


#### TIP ####
# We can also generate individual plots for each category using the concept of faceting
# facet_wrap(~variable_to_facet)
?facet_wrap

# Example using the mpd dataset in base R
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = drv)) + 
  facet_wrap(~class, scales = "free") 


# The tilde '~' is a unique symbol in facet_wrap that allows the function to separate the data 

#### TIP ####
# You can also use 'facet_wrap(vars())'

# What does the argument 'scales' do?


# Now use the iris data set to facet_wrap your density plot by Species 
# With density plots you can color underneath your plots by using "fill" instead of "color"
ggplot(data = iris, aes(x = Sepal.Length)) + 
  geom_density(aes(fill = Species), alpha = 0.5) + 
  facet_wrap(~Species, scales = "free") 


# What's great about ggplot is that you can 'layer' to make your graphs more complex
# Layering can simply be done using "+" like in the examples above
# Let's change the angle of the x-axis text to make it more visible
# Add the following to your plot above

# theme(axis.text.x = element_text(angle = 90))




# Let's continue layering using the warpbreaks data set with knitting data
# Please see the example below

#### TIP ####
# You can perform calculations on plots using the stat_summary function
# Statistical Summaries

ggplot(data = warpbreaks, aes(x = wool, y = breaks)) + 
  geom_boxplot() + 
  geom_point() +
  stat_summary(geom = "point", fun = "mean", color = "blue", size = 3, alpha = 0.5) +
  labs(caption = "Data Source: warpbreaks in R", 
       title = "Knitting Breaks By Types of Wool")

# R understands built-in words like: mean, sum, etc. 
# Try visualizing the standard deviation or 'sd'

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
website <- read_html("https://en.wikipedia.org/wiki/COVID-19_pandemic_by_country_and_territory") 


# Let's work on getting this specific table: Total cases, deaths, and death rates by country (Our World in Data)

#### TIP ####
# Last time, we went over the piping operator ' %>% ' from the 'dplyr' package
# A shortcut on Mac to type the piping operator is 'Shift+Cmd+M'
# The shortcut on PC is 'Ctrl+Shift+M'

library('dplyr')

covid_tables <- website %>% html_table() # retrieves all of the tables from the webpage

covid_table_10 <- covid_tables[[10]]     # retrieves the 10th table from the webpage

# View covid_table_10
# Can you subset to get the columns of interest? 



# The janitor package helps to further clean 'dirty' data
# install.packages("janitor")
# library(janitor)


# Let's 'clean' the data table column names
# In R there are many naming styles but it is standard to name things using underscore or period
covid_table_10 <- covid_table_10 %>% clean_names()


# Let's look at the structure of the variable in the dataframe
# What is the structure of every variable?
# How can you change the datatype of the variables?


# converting relevant data types to numeric 

# The parse_number function is within the tidyverse pakage
# Parse_number will allow us to remove the commas in the numeric data 
# This will allow it to be read as numeric instead of character data


covid_table_10[,c(2:4)]  <- apply(X = covid_table_10[, -c(1)], MARGIN = 2, FUN = parse_number) 

# What does the argument 'Margin = 2' mean?
# What does -c(1) mean?
# How are c(2:4) and -c(1) similar in this example?
# What does the apply function do?


# Now that we've cleaned the data, we can create a 2D interactive graph

####### Plotly Package  ########
# Like ggplot, plot_ly allows for more manual customization
# Install the plotly package and retrieve from the library
# The '::' helps to access a specific function from a specific package

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
plot_ly(covid_table_10, x = ~deaths, y = ~cases, z = ~deaths_million, color = ~country)  %>%
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
        x = 0.2,  # changes the x-axis location of the image
        y = 3,    # changes the y-axis location of the image
        sizex = 2,
        sizey = 2,
        sizing = "stretch",
        opacity = 0.4,
        layer = "below"
      )
    )
  ) %>% 
  hide_legend()


# There may be cross-sharing issues with scraping an image directly from a website. 
# It is also common to upload an image directly from your working directory
# Find an image and add it to your plot

image_file <- "spongebob_PNG65.png"  # <- change this line depending on your image

# The RCurl package helps to collect data from http 
# In this case, we'll use it to encode the image into a special base64 format
txt <- RCurl::base64Encode(readBin(image_file, "raw", file.info(image_file)[1, "size"]), "txt")


plot_ly(covid_table_10, x = ~log(deaths), y = ~log(cases), z = ~deaths_million, color = ~country)  %>%
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
