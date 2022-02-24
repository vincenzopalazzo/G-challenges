CC=dart
FMT=format
ARGS="--help"
PROBLEM=
FAST="off"

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

compete_pizza: clean build
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/a_an_example.in.txt --output output/one_pizza/a_an_example.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/b_basic.in.txt --output output/one_pizza/b_basic.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/c_coarse.in.txt --output output/one_pizza/c_coarse.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/d_difficult.in.txt --output output/one_pizza/d_difficult.out.txt -s;
	./hashd --problem $(PROBLEM) --input inputs/one_pizza/e_elaborate.in.txt --output output/one_pizza/e_elaborate.out.txt -s;
	zip -r $(PROBLEM).zip bin lib pubspec.yaml

compete_mia: clean build
	./hashd --problem $(PROBLEM) --input inputs/cache_server/a.in --output output/cache_server/a.out -s;
	./hashd --problem $(PROBLEM) --input inputs/cache_server/b.in --output output/cache_server/b.out -s;
	./hashd --problem $(PROBLEM) --input inputs/cache_server/c.in --output output/cache_server/c.out -s;
	./hashd --problem $(PROBLEM) --input inputs/cache_server/d.in --output output/cache_server/d.out -s;
	./hashd --problem $(PROBLEM) --input inputs/cache_server/e.in --output output/cache_server/e.out -s;
	zip -r $(PROBLEM).zip bin lib pubspec.yaml

compete_2022: clean build
	./hashd --problem $(PROBLEM) --input inputs/2022/a.in --output output/2022/a.out -s;
	./hashd --problem $(PROBLEM) --input inputs/2022/b.in --output output/2022/b.out -s;
	./hashd --problem $(PROBLEM) --input inputs/2022/c.in --output output/2022/c.out -s;
	./hashd --problem $(PROBLEM) --input inputs/2022/d.in --output output/2022/d.out -s;
	./hashd --problem $(PROBLEM) --input inputs/2022/e.in --output output/2022/e.out -s;
	zip -r $(PROBLEM).zip bin lib pubspec.yaml


compete: 
	 @if [ $(FAST) = "off" ]; then\
       make clean;\
	   make build;\
     fi;\
	./hashd --problem $(PROBLEM) --input_path inputs/cache_server --output_path output/cache_server;

clean:
	rm -rf *.zip hashd output/**/*.out;

dep_upgrade:
	$(CC) pub upgrade --major-versions
