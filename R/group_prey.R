
group_prey = function(x, prey_categories) {
    stopifnot(identical(class(prey_categories), "list"))
    stopifnot(!is.null(names(prey_categories)))
    stopifnot("prey_taxon" %in% colnames(x))
    hierarchy = get_taxonomy(taxon_id=x$prey_taxon_id)
    
    opts = c(names(prey_categories), "Other")
    catgs = character(nrow(x))

    for (h in hierarchy[[2]]) {

        catg = sapply(prey_categories, function(s) { length(intersect(h$scientific_name, s)) > 0 })
        stopifnot(sum(catg) <= 1)  # assert prey categories are mutually exclusive
        catg = append(catg, ifelse(sum(catg) == 0, TRUE, FALSE))

        catgs[which(x$prey_taxon == h$scientific_name[1])] = opts[catg]
    }
    
    x$prey_category = catgs
    return(x)
}