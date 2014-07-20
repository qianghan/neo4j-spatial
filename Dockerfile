## Neo4J + spatial 
## Based from maintainer Tiago Pires, tiago-a-pires@ptinovacao.pt
## Neo4J dependency: dockerfile/java
## get java from trusted build
## Modified from 
from dockerfile/java
maintainer John Clegg, john@projectx.co.nz

## install neo4j according to http://www.neo4j.org/download/linux
# Import neo4j signing key
run wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - 
# Create an apt sources.list file
run echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
# Find out about the files in neo4j repo ; install neo4j community edition
run apt-get update ; apt-get install neo4j=2.1.2 -y

## add launcher and set execute property
add launch.sh /
run chmod +x /launch.sh

# Install neo4j spatial
WORKDIR /tmp
RUN wget -q "https://github.com/neo4j-contrib/m2/blob/master/releases/org/neo4j/neo4j-spatial/0.13-neo4j-2.1.2/neo4j-spatial-0.13-neo4j-2.1.2-server-plugin.zip?raw=true" -O neo4j-sp
atial-0.13-neo4j-2.1.2-server-plugin.zip
RUN mv neo4j-spatial-0.13-neo4j-2.1.2-server-plugin.zip /var/lib/neo4j/plugins/
RUN unzip /var/lib/neo4j/plugins/neo4j-spatial-0.13-neo4j-2.1.2-server-plugin.zip -d /var/lib/neo4j/plugins/

## clean sources
run apt-get clean

## turn on indexing: http://chrislarson.me/blog/install-neo4j-graph-database-ubuntu
## enable neo4j indexing, and set indexable keys to name,age
run sed -i "s|#node_auto_indexing|node_auto_indexing|g" /var/lib/neo4j/conf/neo4j.properties
run sed -i "s|#node_keys_indexable|node_keys_indexable|g" /var/lib/neo4j/conf/neo4j.properties

WORKDIR /

## entrypoint
cmd ["/bin/bash", "-c", "/launch.sh"]
