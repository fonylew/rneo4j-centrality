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
#sort(betweenness(g), decreasing = T)[1:10]