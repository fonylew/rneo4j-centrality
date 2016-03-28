library(RNeo4j)
library(igraph)
library(igraph)
library(jsonlite)

getwd()
neo4j = startGraph("http://104.197.210.78:7474/db/data/")


system.time({
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
maxdegree=max(deg)
})

system.time({
for(i in 1:length(deg))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(deg[i])))
    updateProp(unode[[1]],degree = as.numeric(deg[[i]]))
}
})

print('completed User degree')
save(deg, file="degree_user.Rdata")
sort_deg=sort(deg,decreasing=TRUE)  
write.csv(sort_deg,"degree_user_sort.csv")  
Sys.time()
# BETWEENNESS & CLOSENESS

system.time({
query =  "
MATCH (p1:User)-[:POSTED]->(:Topic)<-[:REPLIED]-(p2:User)
WHERE p1.id < p2.id
RETURN p1.id, p2.id, COUNT(*) AS weight
order by weight desc
"
data = cypher(neo4j, query)
g = graph.data.frame(data, directed = F)
})

system.time({
bet = estimate_betweenness(g,cutoff=-1, weights = NULL)
summary(bet)
maxbet = max(bet)
})

system.time({
for(i in 1:length(bet))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(bet[i]))) 
    updateProp(unode[[1]],betweenness_centrality = as.numeric(bet[[i]]))
}
})

print('completed betweenness')
save(bet, file="betweenness_centrality.Rdata")
Sys.time()

system.time({
close = estimate_closeness(g,cutoff=-1, weights = NULL,normalize=TRUE)
summary(close)
maxclose = max(close)
})

system.time({
for(i in 1:length(close))
{
    unode = getLabeledNodes(neo4j, "User", id = as.integer(names(close[i]))) 
    updateProp(unode[[1]],closeness_centrality = as.numeric(close[[i]]))
}
})

print('completed closeness')
save(close, file="closeness_centrality.Rdata")
Sys.time()

# print('writing User in neo4j...')
# for(i in 1:length(deg))
# {
#     unode = getLabeledNodes(neo4j, "User", id = as.integer(names(deg[i])))
#     updateProp(unode[[1]],degree = as.numeric(deg[[i]]),betweenness_centrality = as.numeric(bet[[i]]),betweenness = as.numeric(bet[[i]])/maxbet, closeness_centrality = as.numeric(close[[i]]),closeness = as.numeric(close[[i]])/maxclose)
# }

# print('completed writing node User')
# Sys.time()

system.time({
queryt =  "
MATCH (n:User)-[r:REPLIED]->(p:Topic)
WITH count(*) as weight,p.id as pid
RETURN pid,weight
order by weight desc
"
datat = cypher(neo4j, queryt)

print('completed degree')
save(datat, file="degree_topic.Rdata")
print('writing Topic in neo4j...')
for(i in 1:nrow(datat))
{
    unode = getLabeledNodes(neo4j, "Topic", id = as.integer(datat$pid[i]))
    updateProp(unode[[1]],degree = as.numeric(datat$weight[i]))
}
})

print('completed writing node Topic')
Sys.time()

print('- Finished -')


print('Graph Density')
system.time({
density=graph.density(g, loops=FALSE)
})
density

# It's take really long time
print('calculating Graph Diameter')
system.time({
diameter=diameter(g)
})
diameter