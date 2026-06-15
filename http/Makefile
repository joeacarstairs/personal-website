all: clean out

.PHONY: remove_deleted_posts
remove_deleted_posts: remove_deleted_microlog_posts remove_deleted_blog_posts

.PHONY: remove_deleted_microlog_posts
remove_deleted_microlog_posts:
	for post in $$(find src/microlog -name *.microlog.upphtml); do \
	  post_basename="$$(basename "$$post")"; \
		post_src="blogs/microlog/$${post_basename::$${#post_basename}-17}.gmi"; \
		if ! [ -f "$$post_src" ]; then \
	    echo "Microlog post source file $${post_src} has been deleted: removing $${post}"; \
			rm -f "$$post" "$${post}.args"; \
		fi; \
	done

.PHONY: remove_deleted_blog_posts
remove_deleted_blog_posts:
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

microlog: src/microlog

src/microlog: $(shell find -L blogs/microlog -type f) bin/blog
	./bin/blog -i microlog -l microlog -t -p gmi2upphtml

blog: src/blog

src/blog: $(shell find -L blogs/blog -type f) bin/blog
	./bin/blog -i blog -l blog -p 'cut_longlog_meta | gmi2upphtml' -a extract_longlog_meta

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog
