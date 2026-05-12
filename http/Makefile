all: public

public: $(shell find src -type f) $(shell find share -type f)
	./bin/mkws https://joeac.net

.PHONY: clean
clean:
	rm -rf public
