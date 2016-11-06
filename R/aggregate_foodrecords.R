aggregate_foodrecords = function(x, by) {
    
    #y = t(sapply(x$prey_taxon, function(taxon) {
    #        hierarchy = get_taxonomy(taxon)$hierarchy[[1]]$scientific_name
    #        sapply(prey_categories, function(cats) any(cats %in% hierarchy))
    #    }))
    stopifnot(c("predator_taxon", "prey_category") %in% colnames(x))
    stopifnot(by %in% colnames(x))
    res = aggregate(data.frame(x[,by]), list(x$predator_taxon, x$prey_category), sum)
    colnames(res) = c("predator_taxon", "prey_taxon", by)
    return(xtabs(as.matrix(res[,by])~predator_taxon+prey_taxon, data=res))
}
