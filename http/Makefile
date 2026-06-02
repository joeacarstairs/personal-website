all: clean out

out: $(shell find src -type f) $(shell find share -type f) $(shell find bin)
	./bin/mkws https://joeac.net

.PHONY: clean
clean:
	rm -rf out
