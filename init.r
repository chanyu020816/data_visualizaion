# init.R
#
# Example R code to install packages if not already installed
#
my_packages = c("package_name_1", "package_name_2", ...)
install_if_missing = function(p) {
if (p %in% rownames(installed.packages()) == FALSE) {
install.packages(p)
}
}
invisible(sapply(my_packages, install_if_missing))