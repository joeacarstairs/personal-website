all: clean out

out: microlog blog $(shell find src -type f) $(shell find share -type f) $(shell find bin)
	./bin/mkws https://joeac.net

microlog: src/microlog

src/microlog: $(shell find -L blogs/microlog -type f) bin/blog
	./bin/blog -i microlog -l microlog -t -p gmi2upphtml

blog: src/blog

src/blog: $(shell find -L blogs/blog -type f) bin/blog
	./bin/blog -i blog -l blog -p gmi2upphtml

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog
