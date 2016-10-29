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
    foodrecords = jsonlite::fromJSON(query, flatten=TRUE)[[1]]
    col_names = matrix(
        ncol = 2, 
        byrow = TRUE,
        data = c(
            "predator.id", "pred_id",
            "prey.id", "prey_id",
            "predator.taxon", "predator",
            "prey.taxon", "prey",
            "predator.count", "pred_amount",
            "prey.count", "prey_amount",
            "details.locality.coordinates.longitude", "longitude",
            "details.locality.coordinates.latitude", "latitude",
            "details.locality.country", "country",
            "details.locality.state", "state", 
            "details.locality.county", "county")
        )
    foodrecords = foodrecords[,col_names[,1]]
    colnames(foodrecords) = col_names[,2]
    return(foodrecords)
}
