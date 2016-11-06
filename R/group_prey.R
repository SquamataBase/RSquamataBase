group_prey = function(x, categories, FUN=NULL) {
    stopifnot(identical(class(categories), "list"))
    stopifnot(length(categories) >= 2)
    stopifnot(all(sapply(categories, class) == "character"))
    stopifnot(!is.null(names(categories)))
    stopifnot("prey_taxon" %in% colnames(x))
    
    opts = c(names(categories), "Other")
    catgs = character(nrow(x))

    if (is.null(FUN)) {
        hierarchy = get_taxonomy(taxon_id=x$prey_taxon_id)
        for (h in hierarchy[[2]]) {
            catg = sapply(categories, function(s) { length(intersect(h$scientific_name, s)) > 0 })
            stopifnot(sum(catg) <= 1)  # assert prey categories are mutually exclusive
            catg = append(catg, ifelse(sum(catg) == 0, TRUE, FALSE))
            catgs[which(x$prey_taxon == h$scientific_name[1])] = opts[catg]
        }
    } else {
        y = FUN(x)
        expressions = lapply(categories, function(z) parse(text=gsub("(\\w+?)(?=\\s*?<)", "y", z, perl=TRUE)))
        catg = sapply(expressions, function(z) eval(z))
        catg[which(is.na(catg), arr.ind=TRUE)] = FALSE
        catg = cbind(catg, rowSums(catg) == 0)
        catgs = apply(catg, 1, function(z) opts[z])
    }

    x$prey_category = catgs
    return(x)
}