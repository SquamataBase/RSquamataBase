
onquit = function(e) {
    system2("squamatabase", args=c("services", "stop", "ui"))
}

.onLoad = function(libname=find.package("RSquamataBase"), pkgname="RSquamataBase") {
    system2("squamatabase", args=c("services", "start", "ui"))
    reg.finalizer(.GlobalEnv, onquit, onexit=TRUE)
}

.onUnload = function(libname=find.package("RSquamataBase")) {
    system2("squamatabase", args=c("services", "stop", "ui"))
}

