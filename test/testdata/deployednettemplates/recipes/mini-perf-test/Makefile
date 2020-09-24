PARAMS=-w 10 -R 1 -N 2 -n 5 -H 2 --node-template node.json --relay-template relay.json --non-participating-node-template nonPartNode.json

all:	net.json genesis.json

net.json:	node.json nonPartNode.json ${GOPATH}/bin/netgoal
	netgoal generate -t net -r /tmp/wat -o net.json ${PARAMS}

genesis.json:	${GOPATH}/bin/netgoal
	netgoal generate -t genesis -r /tmp/wat -o genesis.json ${PARAMS}

clean:
	rm -f net.json genesis.json
