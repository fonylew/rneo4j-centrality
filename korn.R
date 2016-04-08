library(RNeo4j)
library(igraph)
library(igraph)
library(jsonlite)
neo4j = startGraph("http://104.197.210.78:7474/db/data/")
#################################

# Food
query_food =  
"
MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: 'food'})
WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
order by deg_room desc
"
data_food = cypher(neo4j, query_food)
View(data_food)

# blueplanet
query_blueplanet =  
"
MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: 'blueplanet'})
WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
order by deg_room desc
"
data_blueplanet = cypher(neo4j, query_blueplanet)
View(data_blueplanet)

# sinthorn
query_sinthorn =  
  "
MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: 'sinthorn'})
WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
order by deg_room desc
"
data_sinthorn = cypher(neo4j, query_sinthorn)
View(data_sinthorn)

# chalermthai
query_chalermthai =  
  "
MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: 'chalermthai'})
WITH n.id as nid, g.name as room, count(*) as sum ,n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
RETURN nid,room,sum ,ndegree,nbetween,ncloseness
order by sum desc
"
data_chalermthai = cypher(neo4j, query_chalermthai)
View(data_chalermthai)

# isolate
query_isolate =  
  "
MATCH (n:User)-[p:POSTED]->(t:Topic)-[c:CLASSED]->(g:Room {name: 'isolate'})
WITH n.id as nid, g.name as room, count(*) as sum , SUM(t.degree)as deg_room, n.degree as ndegree , n.betweenness_centrality as nbetween, n.closeness_centrality as ncloseness
RETURN nid,room,deg_room,sum ,ndegree,nbetween,ncloseness
order by deg_room desc
"
data_isolate = cypher(neo4j, query_isolate)
View(data_isolate)

###################################
##TAG
user="327698"          #change id here
query_tag = paste(
"
MATCH (n:User{id:",user,"})-[p:POSTED]->(t:Topic)-[:TAGGED]->(g:Tag)
WITH g.name as tag , count(t)as count_tag
RETURN tag,count_tag
order by count_tag desc
")
data_tag = cypher(neo4j, query_tag)
View(data_tag)

###################################
##between
#user="184197"          #change id here
query_temp = paste(
  "
MATCH (n:User)
RETURN n.id,n.degree,n.closeness_centrality,n.betweenness_centrality;

")
data_temp = cypher(neo4j, query_temp)
View(data_temp)

###################################
# PER USER
user="184197"          #change id here
query_temp = paste(
  "
MATCH (n:User{id:",user,"})
RETURN n.id,n.degree,n.closeness_centrality,n.betweenness_centrality;
")
data_temp = cypher(neo4j, query_temp)
View(data_temp)

###################################
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
