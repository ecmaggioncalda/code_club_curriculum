#Practice problems solutions

#Practice: Try using the aes() values in geom_point to 1) change the color of the dots to something other than black, 2) change the color of the dots based on the clade value (hint: this will require using as.factor())

pivoted_cytokine_data %>%
  drop_na(Measure) %>%
  ggplot(aes(x = Cytokine,
             y = Measure)) +
  geom_point(aes(color = "blue"))

pivoted_cytokine_data %>%
  drop_na(Measure) %>%
  ggplot(aes(x = Cytokine,
             y = Measure)) +
  geom_point(color = "blue")

pivoted_cytokine_data %>%
  drop_na(Measure) %>%
  ggplot(aes(x = Cytokine,
             y = Measure)) +
  geom_point(aes(color = as.factor(clade)))


#Practice Part A) Find the column(s) in each data frame that are in common using intersect() & colnames()

common_cols <- intersect(colnames(cytokine_data), colnames(extra_data))

#Practice Part B) Determine that the matching columns are of the same type (numeric vs. character) (using str())
#Note: Here this step is unnecessary because they are of the same type, but this is good practice since they may not always be
#If they aren't we can use the mutate function to fix this so the data frames will be able to merge (see mutate section)

cytokine_data %>%
  select(all_of(common_cols)) %>%
  str()

extra_data %>%
  select(all_of(common_cols)) %>%
  str()

#Practice Part C) Combine them using full_join() into a data frame called full_data

full_data <- cytokine_data %>%
  full_join(extra_data, by = common_cols)

#Practice Problem: using drop_na(), drop all rows where IDSA_severe_mod is NA, and then find the max cytokine value for serum_TNFa

full_data %>%
  drop_na(IDSA_severe_mod) %>%
  summarize(max(serum_TNFa)) #%>%
  #view()

#Practice: filter full_data to include only clade 2 strains. Repeat this exercise so that clade NA strains are not dropped as well.

full_data %>%
  filter(clade == "2") %>%
  view()

full_data %>%
  filter(clade == "2" | is.na(clade) == TRUE) %>%
  view()

#Practice problem: using the replace() function and the across() function, replace all negative values in the cytokine columns with 0, create new object, full_data2

full_data2 <- full_data %>%
  mutate(across(all_of(cytokine_cols), ~replace(.x, .x < 0, 0)))

#Practice: from full_data2, 1) select only your serum cytokine columns, 2) drop any rows of cytokine columns that contain NA, 3) sample half the remaining samples, 4) find the mean cytokine value for each serum cytokine

full_data2 %>%
  select(all_of(cytokine_cols)) %>%
  drop_na() %>%
  slice_sample(prop = 0.5) %>%
  summarize(across(everything(), ~mean(.x))) %>%
  view()
