# create environment to cache server responses
rsquamatabase = new.env(hash=TRUE)
assign("STAGGER_REQUESTS_FOR_X_SEC", 0.500, envir=rsquamatabase)
assign("PREVIOUS_REQUEST_TIME", Sys.time(), envir=rsquamatabase)

.stagger_request = function() {
    if (Sys.time() - get("PREVIOUS_REQUEST_TIME", envir=rsquamatabase) <
            get("STAGGER_REQUESTS_FOR_X_SEC", envir=rsquamatabase)) {
        Sys.sleep(get("STAGGER_REQUESTS_FOR_X_SEC", envir=rsquamatabase))
    }
    assign("PREVIOUS_REQUEST_TIME", Sys.time(), envir=rsquamatabase)
}

# formatted get_foodrecords output
.format = function(foodrecords, detailed=FALSE) {
    
    if (length(foodrecords) == 0) {
        return(NULL)
    }

    # column names returned by fromJSON
    json_names = c("predator.id",
                   "prey.id",
                   "predator.taxon",
                   "prey.taxon",
                   "predator.count",
                   "prey.count",
                   "predator.mass",
                   "predator.mass_unit",
                   "prey.mass",
                   "prey.mass_unit",
                   "predator.volume",
                   "predator.volume_unit",
                   "prey.volume",
                   "prey.volume_unit",
                   "details.locality.coordinates.longitude",
                   "details.locality.coordinates.latitude",
                   "details.locality.country",
                   "details.locality.state", 
                   "details.locality.county"
                )

    formatted_names = sapply(json_names, function(name) {
                            bits = strsplit(name, ".", fixed=TRUE)[[1]]
                            if (bits[1] == "predator" || bits[1] == "prey") {
                                return(paste(bits[1], bits[length(bits)], sep="_"))
                            } else {
                                return(bits[length(bits)])
                            }
                        },
                        USE.NAMES=FALSE
                    )

    foodrecords = foodrecords[,json_names]
    colnames(foodrecords) = formatted_names
    return(foodrecords)
}

# formatted get_taxonomy output
.format_tax = function(taxonomy) {
    # column names returned by fromJSON
    json_names = c("id",
                   "scientific_name",
                   "taxon_status",
                   "hierarchy"
                )

    taxonomy = taxonomy[,json_names]
    colnames(taxonomy) = json_names
    res = list(taxa=taxonomy[,1:3], hierarchy=taxonomy[,4])
    names(res$hierarchy) = res$taxa$id
    return(res)
}
