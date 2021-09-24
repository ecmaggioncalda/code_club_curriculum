# GOALS:
# 1. LEARN HOW TO READ IN DNA ALIGNMENT WITH APE
# 2. LEARN ABOUT ROOTING TREES
# 3. IDENTIFY MUTATION TYPES IN A NUCLEOTIDE ALIGNMENT


# READ IN NECESSARY LIBRARIES 
library(ape)
#library(tidyverse)

###PART 1 - BUILDING AND ROOTING A PHYLOGENETIC TREE IN R

# READ IN DNA ALIGNMENT
# Q - WHAT DEFINES FASTA FORMAT
##standardized header line format, followed by the sequence
dna_aln = read.dna('Session 3/seqs.fasta',
                   format = "fasta")

# CREATE A DISTANCE MATRIX AND AN NJ TREE WITHOUT THE OUTGROUP
#outgroup allows for an idea of direction of evolution
# Q - WHAT DOES THE WHICH STATEMENT DO?
##gives position of the TRUE statements
# Q - WHAT DOES %in% DO?
##provides a TRUE/FALSE of the presence/absence of vector1 in vector2
# Q - WHAT DOES THE - IN FRONT OF og_i DO?
##Indicates to drop the location indicated as opposed to select it

og_i = which(row.names(dna_aln) %in% 'outgroup');
dist_mat_noOG = dist.dna(dna_aln[-og_i,],
                         model = "N")

# BUILD A NEIGHBOR JOINING TREE
# Q - WHAT IS THE OBJECTIVE OF THE NEIGHBOR JOINING ALGORITH (i.e. WHAT IS THE INPUT AND OUTPUT)?
##"neighbor joining has the advantage that it does not assume all lineages evolve at the same rate (molecular clock hypothesis)"
##Input is distance matrix between strains, output is a plot of those distances
#gives the phylogenetic tree so that the branch lengths are the exact pairwise distances from the matrix, and the minimum total branch lengths, so that you get the most likely evolution of the tree

nj_tree_noOG = bionj(dist_mat_noOG)
nj_tree_noOG

# PLOT UNROOTED PHYLOGENY
# Q - WHAT WAS THE MUTATION THAT OCCURED IN THE FIRST POSITION OF THE ALIGNMENT?
##dna_aln[,1] or as.character(dna_aln[,1])
## A vs. T
# Q - BASED ON THE FIRST POSITION IN THE ALIGNMENT, WHERE COULD THE ROOT OF THE TREE BE?
## Sample 3? (my answer) #Evan says this would be a midpoint root, no directionality of evolution
## Evan: we have an indication that since 4 & 5 are T and the outgroup is A, the direction of evolution is towards the T
plot(nj_tree_noOG, type = 'unrooted', no.margin = T)

# CREATE A DISTANCE MATRIX AND AN NJ TREE WITH OUTGROUP
dist_mat = dist.dna(dna_aln, model = "N")

# BUILD A NEIGHBOR JOINING TREE AND ROOT ON THE OUTGROUP
nj_tree = bionj(dist_mat)
nj_tree_rooted = root(nj_tree, 'outgroup')

# PLOT THE ROOTED PHYLOGENY
# Q - WHERE WAS THE ROOT PLACED ON THE UNROOTED TREE?
## Between sample 3 and sample 4 & 5
plot(nj_tree_rooted, no.margin = T)

#consider the use of outgroup rooting the tree for pyseer analysis

# CHALLENGE - USE THE drop.tip FUNCTION TO REMOVE OUTGROUP AND RE-PLOT TREE
nj_tree_rooted_noOG <- drop.tip(nj_tree_rooted, 'outgroup')
plot(nj_tree_rooted_noOG, no.margin = T)

###PART 2 - DETERMINE MUTATION CLASSES OCCURING IN DNA ALIGNMENT

# INITIALIZE MATRIX TO KEEP TRACK OF MUTATIONS WE IDENTIFY IN THE ALIGNMENT
mut_matrix = matrix(0, ncol = 4, nrow = 4,
                    dimnames = list(c('a', 'c', 't', 'g'),
                                    c('a', 'c', 't', 'g')))

# LOOP OVER COLUMNS IN ALIGNMENT AND TABULATE MUTATIONS
for(pos in 1:ncol(dna_aln))
{
  
  # GET CURRENT POSITION IN ALIGNMENT
  # Q - HOW MANY TIMES DOES THIS PIECE OF CODE RUN?
  ## 13
  # Q - WHAT VALUES WILL pos HAVE DURING EACH RUN?
  ## 1:13, the column in the dna_aln we are selecting
  pos_aln = as.character(dna_aln[,pos])
  
  # GET OUTGROUP ALLELE
  og_allele = pos_aln[og_i]
  
  # GET NON-OUTGROUP ALLELES
  # Q - WHAT DOES table DO AND WHAT IS THE STRUCTURE OF THE OUTPUT?
  ## table simplifies the different categories of a vector, counts # of occurrences
  ## structure is a named vector
  alleles = names(table(pos_aln[-og_i]))
  #alleles = unique(pos_aln[-og_i])
  
  non_og_alleles = setdiff(alleles, og_allele)

  #s = table(pos_aln[-og_i])
  # IF THERE ARE VARIANT ALLELES, THEN ADD MUTATIONS TO MATRIX
  # Q - WHY DO YOU THINK WE ARE LOOKING FOR >1 INSTEAD OF >0?
  ## Ambiguity with the samples if there is only 1 difference between outgroup and sample lineage, doesn't give us any direction of evolution   
  # Q - WHICH POSITIONS DO WE NOT REPORT ANY MUTATIONS FOR AND WHY?
  ## Any where there is only a change between outgroup and sample 
  print(paste("Position", pos, "alignment", sep = " "))
  print(pos_aln)
  if(length(alleles) > 1)
  {
    
    #LOOP THROUGH EACH VARIANT ALLELE AND 
    for(var_allele in non_og_alleles)
    {
      print(paste("Position ", pos, ": ", og_allele, "=>", var_allele), sep = "");
      mut_matrix[og_allele, var_allele] = mut_matrix[og_allele, var_allele] + 1
        
    }#end for
    
  }#end if
  
}#end for


# CHALLENGE - CALCULATE THE TRANSITION RATE AND TRANSVERSION RATE FROM YOUR MATRIX


# EXTRA CHALLENGE - USE AN APPLY TO LOOP ACROSS POSITIONS OF ALIGNMENT AND REPORT 
# IF THERE IS A MUTATION AT A GIVEN POSITION

