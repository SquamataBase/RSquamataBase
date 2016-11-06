get_taxonomy = function(taxon_name=NULL, taxon_id=NULL) {
    .stagger_request()
    if (!is.null(taxon_name) && is.null(taxon_id)) {
        stopifnot(inherits(taxon_name, "character"))
        query = sprintf("http://localhost:8000/data/taxonomy/?taxon_name=%s", gsub(" ", "+", taxon_name))
    } else if (!is.null(taxon_id) && is.null(taxon_name)) {
        stopifnot(inherits(taxon_id, "integer"))
        query = sprintf("http://localhost:8000/data/taxonomy/?taxon_id=%s", taxon_id)
    } else if (!is.null(taxon_name) && !is.null(taxon_id)) {
        stopifnot(inherits(taxon_name, "character") && inherits(taxon_id, "integer"))
        query = sprintf("http://localhost:8000/data/taxonomy/?taxon_name=%s&taxon_id=%s", gsub(" ", "+", taxon_name), taxon_id)
    } else {
        stop("No query parameters were provided.")
    }
    # try the cache first
    taxonomy = mget(query, rsquamatabase, ifnotfound=list(NULL))[[1]]
    # and only hit the server if it is not there
    if (is.null(taxonomy)) {
        taxonomy = .format_tax(jsonlite::fromJSON(query, flatten=TRUE)[[1]])
        assign(query, taxonomy, envir=rsquamatabase)  # cache the results so that future requests for same data don't hit server
    }
    return(taxonomy)
}
