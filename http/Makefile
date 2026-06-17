all: microlog blog public out

.PHONY: prune
prune: prune_microlog prune_blog prune_out

.PHONY: prune_out
prune_out:
	./bin/prune_out

.SILENT: prune_microlog
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

.SILENT: prune_blog
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

src_files := $(filter-out %.args,$(wildcard src/*.upp*))
src_files += $(filter-out %.args,$(wildcard src/**/*.upp*))
src_files_ext := $(suffix $(src_files))
out_files_ext := $(src_files_ext:.upp%=%)
layout_files := $(wildcard share/layouts/*.layout.upp*)
layouts := $(notdir $(basename $(basename $(layout_files))))
out_files := $(addprefix out/,$(src_files:src/%=%))
remove_layout_from_out_files = out_files := $$(subst $(1).upp,.,$$(out_files))
$(foreach layout,$(layouts),$(eval $(call remove_layout_from_out_files,.$(layout))))
$(eval $(call remove_layout_from_out_files,))

define out_rule =
out/%.$(1): src/%$(2).upp$(1)
	./bin/mkws https://joeac.net "$$$$(realpath $$<)"
endef

$(foreach ext,$(sort $(out_files_ext)),\
	$(eval $(call out_rule,$(ext),)))
$(foreach layout,$(layouts),\
	$(foreach ext,$(sort $(out_files_ext)),\
		$(eval $(call out_rule,$(ext),.$(layout)))))

define blog_rule =
src/$(1)/%$(if $(2),.$(2)).upphtml: blogs/$(1)/%.gmi $$(wildcard bin/*)
	./bin/blog -i $(1) $(if $(2),-l $(2)) -t -p gmi2upphtml -f $$*.gmi
endef

blogs := $(subst blogs/,,$(wildcard blogs/*))
$(foreach blog,$(blogs),\
	$(foreach layout,$(layouts),\
		$(eval $(call blog_rule,$(blog),$(layout)))))
$(foreach blog,$(blogs),\
	$(eval $(call blog_rule,$(blog),)))

.PHONY: out
out: $(out_files)

.PHONY: microlog
microlog: $(patsubst blogs/microlog/%.gmi,src/microlog/%.microlog.upphtml,$(wildcard blogs/microlog/*.gmi))

.PHONY: blog
blog: $(patsubst blogs/blog/%.gmi,src/blog/%.blog.upphtml,$(wildcard blogs/blog/*.gmi))

.PHONY: public
public: $(subst public/,out/,$(shell find -L public/ -type f))

out/%: public/%
	mkdir -p $(dir $@) && cp $< $@

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog
