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

# Shows an overview of the sample 
# Notice, the dash isn't counted 
dna[2,]

# Shows the sample as a character string 
as.character(dna[2,])

# GET PAIRWISE DISTANCE USING APE FUNCTION DIST.DNA ----
# Core: Among *all* samples, gets rid of any position where at least 1 sample has an N or - 
# Total number of bases is the same across all samples 
core_pw_dist = dist.dna(dna, pairwise.deletion = FALSE, model = 'N', as.matrix = TRUE)

# Look at the matrix
core_pw_dist

# The matrix is symmetric, so just get the lower half, ignore the diagonal 
core_dist = core_pw_dist[lower.tri(core_pw_dist, diag = FALSE)]

# Noncore: Among *each pair* of samples, gets rid of any position where at least 1 sample has an N or - 
# Total number of bases considered varies per pair
noncore_pw_dist = dist.dna(dna, pairwise.deletion = TRUE, model = 'N', as.matrix = TRUE)

noncore_dist = noncore_pw_dist[lower.tri(noncore_pw_dist, diag = FALSE)]

# COMPARE WITH A HISTOGRAM 
hist(core_dist, xlim = c(0,10))
hist(noncore_dist, xlim = c(0,10))

# SUBSET TO CORE POSITIONS ----
dna_mat = as.character(dna) # when referring to the letters, n, or dash, should convert to a character! 


# FOR LOOP INTRO ----
# for (iterator in vector_of_things){
#   do / store something
# }

# initialize storage 
contains_n_or_dash = rep(0, ncol(dna_mat))

dna_mat[,2] 
dna_mat[,2] == 'n'
sum(dna_mat[,2] == 'n')

for (pos in 1:ncol(dna_mat)){
  num_n_or_dash_across_samp = sum(dna_mat[,pos] == 'n' | dna_mat[,pos] == '-')
  contains_n_or_dash[pos] = num_n_or_dash_across_samp
}

# vectorized, faster way
contains_n_or_dash_v2 = colSums(dna_mat == 'n' | dna_mat == '-')

# subset positions to where there are no Ns or -s! 
dna_core = dna_mat[,contains_n_or_dash == 0]

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

pw_dist = matrix(0, nrow = nrow(dna_core), ncol = nrow(dna_core))
for (i in 1:nrow(dna_core)){
  for (j in 1:nrow(dna_core)){
    
    snvs = sum(dna_core[i,] != dna_core[j,])
    pw_dist[i,j] = snvs
  }}

# check that your for loops matches the result of dist.dna!
sum(pw_dist != core_pw_dist)


# DO IT THE APPLY WAY ----
# when you compare a matrix to a vector, it will go column-wise  
dna_core = t(dna_core)
apply(dna_core, 2, function(samp){
  colSums(dna_core != samp)
})

# this doesnt work correcly! 
dna_core = t(dna_core)
apply(dna_core, 1, function(samp){
  rowSums(dna_core != samp)
})


# WRITE YOUR OWN PAIRWISE DISTANCE CALCULATOR ---- 
# Initialize pairwise distance matrix 
pw_dist = matrix(0, nrow = nrow(dna), ncol = nrow(dna))
for (i in 1:nrow(dna)){
  for (j in 1:nrow(dna)){
    
    # convert to character string 
    dna_1 = as.vector(as.character(dna[i,]))
    dna_2 = as.vector(as.character(dna[j,]))
    
    # get core positions for the sample 
    to_keep = !(dna_1 %in% c('n', '-') | dna_2 %in% c('n', '-')) 
    
    # subset to core positions per sample 
    dna_1 = dna_1[to_keep]
    dna_2 = dna_2[to_keep]
    
    # get snv distances 
    snvs = sum(dna_1 != dna_2)
    pw_dist[i,j] = snvs
  }
}









