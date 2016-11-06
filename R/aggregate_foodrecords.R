aggregate_foodrecords = function(x, by=NULL) {
    
    stopifnot(c("predator_taxon", "prey_category") %in% colnames(x))
    if (!is.null(by)) {
        stopifnot(by %in% colnames(x))
        res = aggregate(data.frame(x[,by]), list(x$predator_taxon, x$prey_category), sum)
        colnames(res) = c("predator_taxon", "prey_category", by)
        return(xtabs(as.matrix(res[,by])~predator_taxon+prey_category, data=res))
    } else {
        res = xtabs(~predator_taxon+prey_category, data=x)
        res[which(res > 0, arr.ind=TRUE)] = 1 
        return(res)
    }
}
