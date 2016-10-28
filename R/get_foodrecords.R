get_foodrecords = function(predator=NULL, prey=NULL, detailed=FALSE) {
    if (!is.null(predator) && is.null(prey)) {
        stopifnot(inherits(predator, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&view=detailed", predator)
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s", predator)
        }
    } else if (!is.null(prey) && is.null(predator)) {
        stopifnot(inherits(prey, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?prey=%s&view=detailed", prey)
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?prey=%s", prey)
        }
    } else if (!is.null(prey) && !is.null(predator)) {
        stopifnot(inherits(predator, "character") && inherits(prey, "character"))
        query = if (detailed) {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&prey=%s&view=detailed", predator, prey)
        } else {
            sprintf("http://localhost:8000/data/foodrecords/?predator=%s&prey=%s", predator, prey)
        }
    } else {
        stop("No query parameters were provided.")
    }
    foodrecords = jsonlite::fromJSON(query)
    return(foodrecords[[1]])
}
