CC=dart
FMT=format
ARGS="--help"
PROBLEM=

default: get fmt build

get:
	$(CC) pub get

fmt:
	$(CC) $(FMT) .
	$(CC) analyze .

build:
	$(CC) compile exe bin/kikstartd.dart -o kikstartd

run:
	$(CC) run bin/hashd.dart $(ARGS)

compete: clean build

clean:
	rm -rf *.zip kikstartd output/**/*.out

dep_upgrade:
	$(CC) pub upgrade --major-versions
