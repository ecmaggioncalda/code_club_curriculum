# GOALS - 
# 1. CALCULATE PAIRWISE SINGLE NUCLEOTIDE VARIANT (SNV) DISTANCES 
# BETWEEN A SET OF GENOMES
# 2. UNDERSTAND THE INNER-WORKINGS OF BUILT-IN FUNCTION DIST.DNA AND THE
# ARGUMENT PAIRWISE.DELETION
# 3. FOR LOOPS AND APPLY STATEMENTS 

# READ IN NECESSARY LIBRARIES 
library(ape)

# CREATE A TOY DNA BIN OBJECT ----
dna_matrix = matrix(c('a', 'c', 'c', 't', 'g', 'a', 't', 't', 'g', 'a',
                      'a', 't', '-', 't', 'g', 't', 'a', 'a', 't', 't', 
                      't', 'c', 'c', 'a', 'n', 'a', 't', 't', 'g', 'a',
                      'a', 'c', 't', 't', 'c', 't', 't', 'a', 't', 'n',
                      't', 'n', 't', 'a', 'n', 'a', 'a', 'a', 'g', 't'), 
                    ncol = 10, nrow = 5, byrow = TRUE)
row.names(dna_matrix) = c('samp1', 'samp2', 'samp3', 'samp4', 'samp5')
dna = as.DNAbin(dna_matrix) 

# DNA BINS CAN sorta BE TREATED LIKE MATRICES ----
# Where the rows are samples and the columns are positions 



# GET PAIRWISE DISTANCE USING APE FUNCTION DIST.DNA ----
# Core: Among *all* samples, gets rid of any position where at least 1 sample has an N or - 
# Total number of bases is the same across all samples 

# Noncore: Among *each pair* of samples, gets rid of any position where at least 1 sample has an N or - 
# Total number of bases considered varies per pair


# COMPARE WITH A HISTOGRAM ----

# SUBSET TO CORE POSITIONS ----


# FOR LOOP INTRO ----
# for (iterator in vector_of_things){
#   do / store something
# }



# WRITE YOUR OWN PAIRWISE DISTANCE CALCULATOR ---- 
# HINTS! 
# Initialize a matrix of 0s with rows and columns being the number of samples (pairwise comparisons)
# pw_dist = matrix()
# We need to compare each set of samples, so we need 2 iterators...e.g. 2 for loops! 

# for (i in ){
#   for(j in ){
#     # compare 2 samples with logical operator 
#     
# store in your pw_dist matrix 
#   }
# }





