library(RNeo4j)
library(igraph)
library(igraph)

getwd()
neo4j = startGraph("http://104.197.210.78:7474/db/data/")

# POPULAR TOPIC
query_topic =
  "
MATCH (t:Topic)
WITH t.degree as deg_topic,t.id as tid,t.emo as temo,t.timestamp as time,t.room as troom,t.like as tlike
RETURN tid,deg_topic,tlike,temo,time,troom
order by deg_topic desc 
limit 30
")
popular_topic = cypher(neo4j, query_topic)
##########

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

#* @get /deg
deg <- function(room){
  query_cen = paste(
    "
  MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: ",room,"})
  WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
  RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
  order by ndegree desc 
  limit 10
  ")
  data = cypher(neo4j, query_cen)
}

#* @get /bet
bet <- function(room){
  query_cen = paste(
    "
  MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: ",room,"})
  WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
  RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
  order by nbetween desc 
  limit 10
  ")
  data = cypher(neo4j, query_cen)
}

#* @get /clo
clo <- function(room){
  query_cen = paste(
    "
  MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: ",room,"})
  WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
  RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
  order by ncloseness desc 
  limit 10
  ")
  data = cypher(neo4j, query_cen)
}

#* @get /droom
droom <- function(room){
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

#* @get /rep
rep <- function(room){
  query_cen = paste(
    "
  MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: ",room,"})
  WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
  RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
  order by sum desc 
  limit 10
  ")
  data = cypher(neo4j, query_cen)
}

#* @get /top
top <- function(){
  popular_topic
}

#* @get /stupid
stupid <- function(a){
  a<-'stupid'
}
