all: microlog blog $(shell find src -type f) $(shell find share -type f) $(shell find bin)
	./bin/mkws https://joeac.net

.SILENT: prune_out
.PHONY: prune_out
prune_out:
	for out in $$(find out -type f); do \
		out_basename="$$(basename "$$out")"; \
		out_ext="$${out_basename##*\.}"; \
		rel_path="$$(echo "$${out}" | cut -c5-)"; \
		if [ -f "public/$${rel_path}" ]; then \
			continue 2; \
		fi; \
		base_rel_path="$${rel_path%%.$${out_ext}}"; \
		src_path="src/$${base_rel_path}.upp$${out_ext}"; \
		if [ -f "$$src_path" ]; then \
  		continue 2; \
		fi; \
		for layout in $$(find share/layouts -name "*.layout.upp$${out_ext}"); do \
			layout="$$(basename "$$layout")"; \
			layout="$${layout::$${#layout}-15}"; \
			rel_path="$$(echo "$${out}" | cut -c5-)"; \
			base_rel_path="$${rel_path%%.$${out_ext}}"; \
			src_path="src/$${base_rel_path}.$${layout}.upp$${out_ext}"; \
			if [ -f "$$src_path" ]; then \
				continue 2; \
			fi; \
		done; \
    echo "No source file found to match $${out}: removing it"; \
		rm "$$out"; \
	done

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

define out_rule_for_ext_and_layout =
out/%.$(1): src/%$(2).upp$(1)
	./bin/mkws https://joeac.net "$$$$(realpath $$<)"
endef

$(foreach ext,$(sort $(out_files_ext)),\
	$(eval $(call out_rule_for_ext_and_layout,$(ext),)))
$(foreach layout,$(layouts),\
	$(foreach ext,$(sort $(out_files_ext)),\
		$(eval $(call out_rule_for_ext_and_layout,$(ext),.$(layout)))))

.PHONY: out
out: $(out_files)

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
