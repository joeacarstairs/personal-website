all: microlog blog $(shell find src -type f) $(shell find share -type f) $(shell find bin)
	./bin/mkws https://joeac.net

.PHONY: remove_deleted_posts
remove_deleted_posts: remove_deleted_microlog_posts remove_deleted_blog_posts

.PHONY: prune_microlog
prune_microlog:
	for post in $$(find src/microlog -name *.microlog.upphtml); do \
	  post_basename="$$(basename "$$post")"; \
		post_src="blogs/microlog/$${post_basename::$${#post_basename}-17}.gmi"; \
		if ! [ -f "$$post_src" ]; then \
	    echo "Microlog post source file $${post_src} has been deleted: removing $${post}"; \
			rm -f "$$post" "$${post}.args"; \
		fi; \
	done

.PHONY: prune_blog
prune_blog:
	for post in $$(find src/blog -name *.blog.upphtml); do \
	  post_basename="$$(basename "$$post")"; \
		post_src="blogs/blog/$${post_basename::$${#post_basename}-13}.gmi"; \
		if ! [ -f "$$post_src" ]; then \
	    echo "Blog post source file $${post_src} has been deleted: removing $${post}"; \
			rm -f "$$post" "$${post}.args"; \
		fi; \
	done

out: microlog blog $(shell find src -type f) $(shell find share -type f) $(shell find bin)
	./bin/mkws https://joeac.net

.PHONY: microlog
microlog: prune_microlog $(patsubst blogs/microlog/%.gmi,src/microlog/%.microlog.upphtml,$(wildcard blogs/microlog/*.gmi))

src/microlog/%.microlog.upphtml: blogs/microlog/%.gmi bin/blog bin/gmi2upphtml
	./bin/blog -i microlog -l microlog -t -p gmi2upphtml -f $*.gmi

.PHONY: blog
blog: prune_blog $(patsubst blogs/blog/%.gmi,src/blog/%.blog.upphtml,$(wildcard blogs/blog/*.gmi))

src/blog/%.blog.upphtml: blogs/blog/%.gmi bin/blog bin/gmi2upphtml bin/cut_longlog_meta
	./bin/blog -i blog -l blog -p 'cut_longlog_meta | gmi2upphtml' -a extract_longlog_meta -f $*.gmi

.PHONY: public
public: $(subst public/,out/,$(shell find public/ -type f))

out/%: public/%
	mkdir -p $(dir $@) && cp $< $@

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog
