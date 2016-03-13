library(RNeo4j)
library(igraph)
library(jsonlite)
neo4j = startGraph("http://104.197.210.78:7474/db/data/")

query0 =  "
MATCH (p1:User)-[:POSTED]->(:Topic)<-[:REPLIED]-(p2:User)
WHERE p1.id < p2.id
RETURN p1.id, p2.id, COUNT(*) AS weight
order by weight desc
"
data0 = cypher(neo4j, query0)
g0 = graph.data.frame(data0, directed = F)

deg = degree(g0)
summary(deg)
maxdegree(deg)

query =  "
MATCH (p1:User)-[:POSTED]->(:Topic)<-[:REPLIED]-(p2:User)
WHERE p1.id < p2.id
RETURN p1.id, p2.id, COUNT(*) AS weight
order by weight desc
"
data = cypher(neo4j, query)
g = graph.data.frame(data, directed = F)

bet = betweenness(g)
summary(bet)
maxbet = max(bet)

close = closeness(g)
summary(close)
maxclose = max(close)

for(i in 1:length(deg))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(deg[i])))
    updateProp(unode[[1]],degree = as.numeric(deg[[i]]),betweenness_centrality = as.numeric(bet[[i]]),betweenness = as.numeric(bet[[i]])/maxbet, closeness_centrality = as.numeric(close[[i]]),closeness = as.numeric(close[[i]])/maxclose)
}
