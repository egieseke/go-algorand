PARAMS=-w 2 -R 0 -N 1 -n 1 --node-template node.json --relay-template relay.json

all:	net.json genesis.json

net.json:	node.json ${GOPATH}/bin/netgoal Makefile
	netgoal generate -t net -r /tmp/wat -o net.json ${PARAMS}

genesis.json:	${GOPATH}/bin/netgoal Makefile
	netgoal generate -t genesis -r /tmp/wat -o genesis.json ${PARAMS}

clean:
	rm -f net.json genesis.json
