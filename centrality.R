library(RNeo4j)
library(igraph)
library(igraph)
library(jsonlite)

setwd('~/rneo4j-centrality')
getwd()
neo4j = startGraph("http://104.197.210.78:7474/db/data/")

Sys.time()

queryu =  "
MATCH (p1:User)-[:POSTED]->(:Topic)<-[r:REPLIED]-(p2:User)
WHERE p1.id < p2.id
RETURN p1.id, p2.id, COUNT(r) AS weight
order by weight desc
"
datau = cypher(neo4j, queryu)
gu = graph.data.frame(datau, directed = F)

deg = degree(gu)
summary(deg)
maxdegree(deg)

print('completed User degree')
save(deg, file="degree_user.Rdata")
Sys.time()

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

print('completed betweenness')
save(bet, file="betweenness_centrality.Rdata")
Sys.time()

close = closeness(g)
summary(close)
maxclose = max(close)

print('completed closeness')
save(close, file="closeness_centrality.Rdata")
Sys.time()

print('writing User in neo4j...')
for(i in 1:length(deg))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(deg[i])))
    updateProp(unode[[1]],degree = as.numeric(deg[[i]]),betweenness_centrality = as.numeric(bet[[i]]),betweenness = as.numeric(bet[[i]])/maxbet, closeness_centrality = as.numeric(close[[i]]),closeness = as.numeric(close[[i]])/maxclose)
}

print('completed writing node User')
Sys.time()

queryt =  "
MATCH (:Topic)<-[r]-(:User)
RETURN COUNT(r) AS weight
order by weight desc
"
datat = cypher(neo4j, queryt)
gt = graph.data.frame(datat, directed = F)

degt = degree(gt)
summary(degt)
print('completed degree')
save(degt, file="degree_topic.Rdata")
Sys.time()

print('writing Topic in neo4j...')
for(i in 1:length(deg))
{
    unode = getLabeledNodes(neo4j, "Topic", id = as.integer(names(degt[i])))
    updateProp(unode[[1]],degree = as.numeric(degt[[i]]))
}

print('completed writing node Topic')
Sys.time()

print('- Finished -')
