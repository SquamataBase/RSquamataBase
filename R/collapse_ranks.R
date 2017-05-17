collapse_ranks = function(x, collapse, predator=TRUE, prey=FALSE) {
    stopifnot(collapse %in% c("infraspecies", "species", "genus", "family", "order", "class", "phylum", "kingdom"))

    ranks = factor(
        c("infraspecies", "species", "genus", "family", "order", "class", "phylum", "kingdom"),
        levels=c("infraspecies", "species", "genus", "family", "order", "class", "phylum", "kingdom")
    )

    collapse = match(collapse, levels(ranks))

    keep = rep(TRUE, nrow(x))

    if (predator) {
        hierarchy = get_taxonomy(taxon_id=unique(x$predator_taxon_id))
        i = 1L
        for (h in hierarchy[[2]]) {
            
            if (match(h$rank[1], levels(ranks)) <= collapse) {
                matchedrows = which(x$predator_taxon == h$scientific_name[1])
                x$predator_taxon[matchedrows] = h$scientific_name[match(levels(ranks)[collapse], h$rank)]
                x$predator_taxon_id[matchedrows] = h$id[match(levels(ranks)[collapse], h$rank)]
                x$predator_taxon_rank[matchedrows] = h$rank[match(levels(ranks)[collapse], h$rank)]

            } else {
                keep[i] = FALSE
            }
            i = i + 1L
        }
    }
    if (prey) {
        hierarchy = get_taxonomy(taxon_id=unique(x$prey_taxon_id))
        i = 1L
        for (h in hierarchy[[2]]) {
            
            if (match(h$rank[1], levels(ranks)) <= collapse) {
                matchedrows = which(x$prey_taxon == h$scientific_name[1])
                x$prey_taxon[matchedrows] = h$scientific_name[match(levels(ranks)[collapse], h$rank)]
                x$prey_taxon_id[matchedrows] = h$id[match(levels(ranks)[collapse], h$rank)]
                x$prey_taxon_rank[matchedrows] = h$rank[match(levels(ranks)[collapse], h$rank)]

            } else {
                keep[i] = FALSE
            }
            i = i + 1L
        }
    }

    return(x[keep,])
}