########################################################################################
###############
############### Sliding windows SNP/KB estimation from VCF
########## 12 oct 2017

########################################################################################

# Libraries
#install.packages('genoPlotR')
library('genoPlotR')
library(RColorBrewer)
library(igraph)
library(GGally)
#######################################
# Set working directory

setwd('~/Documents/Melanie/SNP_comparison_N16961_db_PacBio/Mauve/')

setwd('~/Documents/EPFL/Vibrio_Chromosomal_rearrangements/Rearrangements_Other_sps/Acinetobacter_baumannii/Synteny/')

df<-read.delim("FINAL_SYNTENY_ALL_REARRANGEMENTS_A_baumannnii.SNP",h=T)
nam<-read.delim("FINAL_SYNTENY_ALL_REARRANGEMENTS_A_baumannnii",h=F)




df<-read.delim("4_strains_Mauve.SNP",h=T)
nam<-read.delim("4_strains_Mauve",h=F)


head(nam)
nam<-nam[grep("File",nam$V1),2]
nam<-as.character(nam[-length(nam)])
nam<-strsplit(nam,split = '/')

nam<-lapply(nam, function (x) x  [length(x)]    )
nam<-gsub("Vibrio_cholerae_","",gsub(".fna","",gsub(".fasta","",nam)))   
      

head(df)
df2<-gsub("(.{1})", "\\1 ", as.character(df$SNP.pattern))
df2<-strsplit(df2,' ')



# LOOP calculating different letter of SNP column (output MAUVE)
Results<-list()
for ( i in 1:length(df2[[1]])){
  for (j in 2:length(df2[[1]])){
    df3<-Filter(function(x) !any(grepl("-", x[i:j])), df2) # 
    Results[[paste(nam[i],nam[j],sep = "@")]]<-table(unlist(lapply(df3, function (x) ifelse(x[i]!=x[j],"YES","NO") )))[2]
    
  }
}




Results

# PLOT RESULTS AS A NETWORK OF DIFFERENT SNP NUMBER
mat1<-as.data.frame(matrix(Results,nrow = length(nam) -1 ,ncol = length(nam)))
mat1<-rbind.data.frame(rep(0,length(nam)),mat1)

colnames(mat1)<- unique(unlist(strsplit(names(Results), split="@"))) 
rownames(mat1)<- unique(unlist(strsplit(names(Results), split="@")))
mat1[is.na(mat1)]<-0

for (k in 1:dim(mat1)[2]) {
mat1[,k]<-unlist(mat1[,k])}

require(ape)

write.table(mat1,file="~/Documents/EPFL/Vibrio_Chromosomal_rearrangements/Rearrangements_Other_sps/Acinetobacter_baumannii/Synteny/SNP_diff_Mauve.txt",sep = '\t', row.names = T,, col.names=NA,quote=F)

mat2<-network(mat1,matrix.type="adjacency",
        ignore.eval = F,
        names.eval = "weights")

pdf("~/Documents/EPFL/Vibrio_Chromosomal_rearrangements/Rearrangements_Other_sps/Acinetobacter_baumannii/Synteny/SNP_diff_Mauve_Network.pdf", height = 12, width = 18)
ggnet2(mat2,label=TRUE, edge.label = "weights", color=unique(unlist(strsplit(names(Results), split="@"))))
dev.off()

# PLOT DENDOGRAM OF DIFFERENT SNP NUMBER

HC<-hclust(as.dist(mat1),method = "complete")

pdf("~/Documents/EPFL/Vibrio_Chromosomal_rearrangements/Rearrangements_Other_sps/Acinetobacter_baumannii/Synteny/SNP_diff_Mauve_Hierarchical_Clustering.pdf", height = 12, width = 12)
plot(HC)
myhcl <- cutree(HC, h=max(HC$height/1.5))
abline(h = max(HC$height/1.5), col="red")
dev.off()

