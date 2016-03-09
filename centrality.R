library(RNeo4j)
library(igraph)
library(jsonlite)
neo4j = startGraph("http://104.197.136.113:7474/db/data/")
query =  "
MATCH (p1:User)-[:POSTED]->(:Topic)<-[:REPLIED]-(p2:User)
WHERE p1.id < p2.id
RETURN p1.id, p2.id, COUNT(*) AS weight
order by weight desc
"
data = cypher(neo4j, query)
g = graph.data.frame(data, directed = F)
bet = betweenness(g)
sort(bet,decreasing=T)[1:10]
for(i in 1:length(bet))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(bet[i]))) 
    updateProp(unode[[1]],betweenness_centrality = as.numeric(bet[[i]]))
}

close = closeness(g)
for(i in 1:length(close))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(close[i]))) 
    updateProp(unode[[1]],closeness_centrality = as.numeric(close[[i]]))
}
