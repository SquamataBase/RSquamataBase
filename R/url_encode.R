url_encode = function(x) {
    if (is.null(x)) {
        return(NULL)
    } else if (identical(class(x), "character")) {
        x = paste('\"', gsub(" ", "+", x), '\"', sep="")
    } else if (identical(class(x), "integer")) {
        # do nothing
    } else {
        stop("Invalid object passed to url_encode")
    }
    x = sprintf("[%s]", paste(x, collapse=","))
    return(x)
}