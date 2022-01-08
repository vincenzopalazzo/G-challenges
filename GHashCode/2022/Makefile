CC=dart
FMT=format
ARGS="--help"

default: get fmt build

get:
	$(CC) pub get

fmt:
	$(CC) $(FMT) .
	$(CC) analyze .

build:
	$(CC) compile exe bin/hashd.dart -o hashd

run:
	$(CC) run bin/hashd.dart $(ARGS)

clean:
	$(CC) clean

dep_upgrade:
	$(CC) pub upgrade --major-versions
