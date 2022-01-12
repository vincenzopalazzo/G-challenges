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
	$(CC) compile exe bin/hashd.dart -o hashd

run:
	$(CC) run bin/hashd.dart $(ARGS)

compete: clean build
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/a_an_example.in.txt --output output/one_pizza/a_an_example.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/b_basic.in.txt --output output/one_pizza/b_basic.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/c_coarse.in.txt --output output/one_pizza/c_coarse.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/d_difficult.in.txt --output output/one_pizza/d_difficult.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/e_elaborate.in.txt --output output/one_pizza/e_elaborate.out.txt -s;
	zip -r $(PROBLEM).zip bin lib pubspec.yaml

clean:
	rm -rf *.zip hashd output/one_pizza/*

dep_upgrade:
	$(CC) pub upgrade --major-versions
