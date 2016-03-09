# rneo4j-centrality

## Install Packages
```
install.packages("RNeo4j")
install.packages("igraph")
install.packages("jsonlite")
install.packages("devtools")
```

# Docker Machine
`git clone https://github.com/fonylew/rneo4j-centrality.git`
## Run Docker
`docker run -d --name rstudio -p 8787:8787 rocker/rstudio`
## Add some alias
```
alias xr="docker exec -it rstudio /usr/bin/R"
alias xrbash="docker exec -it rstudio /bin/bash"
```
