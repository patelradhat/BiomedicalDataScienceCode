df <- counts_matrix
df <- as.data.frame(df)
counts = df[,2:ncol(df)]
dds = DESeqDataSetFromMatrix(countData = counts[,order(colnames(counts))], colData = si, design = ~ celltype)
dds = DESeq(dds)
cm = data.frame(counts(dds, normalized=TRUE))
rownames(cm) = paste0(df$Chr, '_', df$Start, '_', df$End)

if (!requireNamespace("GenomicRanges", quietly = TRUE)) {
  BiocManager::install("GenomicRanges")
}
library(GenomicRanges)
df <- as.data.frame(df)

if (!requireNamespace("DESeq2", quietly = TRUE)) {
  BiocManager::install("DESeq2")
}
library(DESeq2)

counts = df[,2:5]
row.names(counts) <- counts_matrix$Gene.Name
metadata <- data.frame(Sample = c("parental1", "parental2", "knockout1", "knockout2"), Condition = c('parental', 'parental', 'knockout', 'knockout'))
dds = DESeqDataSetFromMatrix(countData = counts[,order(colnames(counts))], colData = metadata, design = ~ Condition)
dds = DESeq(dds)
cm = data.frame(counts(dds, normalized=TRUE))

cm$parental_av <- rowMeans(cm[, c("CD58KO_1", "CD58KO_2")])
cm$knockout_av <- rowMeans(cm[, c("Parental_1", "Parental_2")])
cm$logfold <- log2(cm$parental_av / cm$knockout_av)

res = results(dds, lfcThreshold=1, contrast=c("Condition", "parental", "knockout"))
print(mcols(res, use.names=T))
hist(res$pvalue, breaks=0:20/20, col="grey50", border="white", xlim=c(0,1), main="Histogram of p-values", xlab="p-value")
plotMA(res, ylim = c(-5, 5))
print(sum(res$padj < 0.01 & abs(res$log2FoldChange) > 1))
cm_orig = data.frame(counts(dds, normalized=TRUE))
mat = cm_orig[which(res$padj < 0.01 & abs(res$log2FoldChange) > 1),]
mat = mat - rowMeans(mat)

anno = as.data.frame(colData(dds)[, c("Sample", "Condition")])
#rownames(mat) = NULL
if (!requireNamespace("pheatmap", quietly = TRUE)) {
  install.packages("pheatmap")
}
library(pheatmap)
pheatmap(mat, annotation_col = anno, scale="row")
heatmap_obj <- pheatmap(mat, annotation_col = anno, scale="row")
heatmap_matrix <- heatmap_obj$tree_row$labels
indices <- c(1:2, 4:9, 10:12, 14:17, 36:39, 27, 47, 49)
heatmap_matrix_cut <- heatmap_matrix[indices]
mat_cut <- mat[rownames(mat) %in% heatmap_matrix_cut, , drop = FALSE]
pheatmap(mat_cut, annotation_col = anno, scale="row")


##thresholding
threshold_PVAL <- 0.05/23013
pvals <- res$pvalue

passed_threshold <- pvals < threshold_PVAL

#rows_passing_threshold <- rownames(res)[sum(passed_threshold) ]

rows_passing_threshold <- rownames(res)[which(passed_threshold==TRUE)]

print(sort(rows_passing_threshold))

print(counts["GZMA", ])

cm$deseqlog <- res@listData$log2FoldChange

thresh_log <- 10
passed_log <- cm$deseqlog > thresh_log
rows_passedlog <- row.names(cm)[which(passed_log==TRUE)]
print(sort(rows_passedlog))

head(res(listData$log2FoldChange))



