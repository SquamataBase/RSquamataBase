get_foodrecords = function(predator=NULL, prey=NULL, detailed=FALSE) {
    .stagger_request()
    if (!is.null(predator) && is.null(prey)) {
        stopifnot(inherits(predator, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&view=detailed", gsub(" ", "+", predator))
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s", gsub(" ", "+", predator))
        }
    } else if (!is.null(prey) && is.null(predator)) {
        stopifnot(inherits(prey, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?prey=%s&view=detailed", gsub(" ", "+", prey))
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?prey=%s", gsub(" ", "+", prey))
        }
    } else if (!is.null(prey) && !is.null(predator)) {
        stopifnot(inherits(predator, "character") && inherits(prey, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&prey=%s&view=detailed", gsub(" ", "+", predator), gsub(" ", "+", prey))
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&prey=%s", gsub(" ", "+", predator), gsub(" ", "+", prey))
        }
    } else {
        stop("No query parameters were provided.")
    }
    # try the cache first
    foodrecords = mget(query, rsquamatabase, ifnotfound=list(NULL))[[1]]
    # and only hit the server if it is not there
    if (is.null(foodrecords)) {
        foodrecords = .format(jsonlite::fromJSON(query, flatten=TRUE)[[1]], detailed)
        assign(query, foodrecords, envir=rsquamatabase)  # cache the results so that future requests for same data don't hit server
    }
    return(foodrecords)
}
