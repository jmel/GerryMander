## maps.R
## input is gerrymander file from jmel, slightly modified
## output is a few maps
## Nov 25 2012

require(ggplot2)
require(maps)
require(RColorBrewer)

state.votes = read.table("gerrymanderState.txt", header=TRUE, skip=8)
state.votes$state=sub("-", " ", state.votes$state)

mapofstates=map_data("state")
names(mapofstates)[5] = "state"

map.votes=merge(mapofstates, state.votes)
map.votes = map.votes[order(map.votes$order),]

qplot(long, lat, data=map.votes, geom="polygon", group=group, fill=contVoteDem)

map.votes$contDemSeatProp = map.votes$contSeatDem/map.votes$contSeatTot
map.votes$contDemVoteProp = map.votes$contVoteDem/map.votes$contVoteTot

qplot(long, lat, data=map.votes, geom="polygon", group=group, fill=contDemSeatProp/contDemVoteProp) + scale_fill_gradient2(low="red", mid="white", high="blue", midpoint=1, space="rgb")

