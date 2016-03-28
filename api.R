library(RNeo4j)
library(igraph)
library(igraph)

getwd()
neo4j = startGraph("http://104.197.210.78:7474/db/data/")

#* @get /mean
normalMean <- function(samples=10){
  data <- rnorm(samples)
  mean(data)
}

#* @post /sum
addTwo <- function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* @get /cen
cen <- function(room){
  query_cen = paste(
  "
  MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: ",room,"})
  WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
  RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
  order by deg_room desc 
  limit 10
  ")
  data = cypher(neo4j, query_cen)
}

#* @get /test
test <- function(a){
  query_test =
    "
    MATCH (n:User)
    return n
    limit 10;
    "
  data_test = cypher(neo4j, query_test)
}

#* @get /stupid
stupid <- function(a){
  a<-'stupid'
}
