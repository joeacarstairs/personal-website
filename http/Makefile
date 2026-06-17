include config.mk

all: microlog blog public out

.PHONY: out
out: $(out_files)

blog_src_files = $(patsubst \
	blogs/$(blog)/%.$(BLOG_EXT_$(blog)),\
	src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml,\
	$(shell find -L "blogs/$(blog)" -type f -and -name *.$(BLOG_EXT_$(blog))))

.PHONY: microlog
microlog: $(let blog,microlog,$(blog_src_files))

.PHONY: blog
blog: $(let blog,blog,$(blog_src_files))

.PHONY: public
public: $(subst public/,out/,$(shell find -L public/ -type f))

out/%: public/%
	mkdir -p $(dir $@) && cp $< $@

.PHONY: prune
prune: prune_microlog prune_blog prune_out

.PHONY: prune_out
prune_out:
	./bin/prune_out

.PHONY: prune_microlog
prune_microlog:
	./bin/prune_blog microlog

.PHONY: prune_blog
prune_blog:
	./bin/prune_blog blog

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog

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

blog_src_files = src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml
blog_files = blogs/$(blog)/%.$(BLOG_EXT_$(blog)) $$(wildcard bin/*)
define blog_rule =
$(blog_src_files): $(blog_files)
	./bin/blog \
		-i $(blog) \
		$(if $(BLOG_LAYOUT_$(blog)),-l $(BLOG_LAYOUT_$(blog))) \
		$(BLOG_FLAGS_$(blog)) \
		-f $$*.$(BLOG_EXT_$(blog))
endef

blogs := $(subst blogs/,,$(wildcard blogs/*))
$(foreach blog,$(blogs),\
	$(foreach layout,$(layouts),\
		$(eval $(call blog_rule,$(blog),$(layout)))))
$(foreach blog,$(blogs),\
	$(eval $(call blog_rule,$(blog),)))
