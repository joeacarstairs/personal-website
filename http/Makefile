include config.mk

src_files := $(filter-out %.args,$(wildcard src/*.upp*))
src_files += $(filter-out %.args,$(wildcard src/**/*.upp*))
src_files_ext := $(suffix $(src_files))
out_deps_ext := $(src_files_ext:.upp%=%)
layout_files := $(wildcard share/layouts/*.layout.upp*)
layouts := $(notdir $(basename $(basename $(layout_files))))
out_deps := $(addprefix out/,$(src_files:src/%=%))
remove_layout_from_out_deps = out_deps := $$(subst $(1).upp,.,$$(out_deps))
$(foreach layout,$(layouts),$(eval $(call remove_layout_from_out_deps,.$(layout))))
$(eval $(call remove_layout_from_out_deps,))

define out_rule =
out/%.$(1): src/%$(2).upp$(1)
	./bin/mkws https://joeac.net "$$$$(realpath $$<)"
endef

blog_post_target = src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml
blog_post_src = blogs/$(blog)/%.$(BLOG_EXT_$(blog)) $$(wildcard bin/*)
define blog_post_rule =
$(blog_post_target): $(blog_post_src)
	./bin/blog \
		-i $(blog) \
		$(if $(BLOG_LAYOUT_$(blog)),-l $(BLOG_LAYOUT_$(blog))) \
		$(BLOG_FLAGS_$(blog)) \
		-f $$*.$(BLOG_EXT_$(blog))
endef

blogs := $(subst blogs/,,$(wildcard blogs/*))

blog_src = $(patsubst \
	blogs/$(blog)/%.$(BLOG_EXT_$(blog)),\
	src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml,\
	$(shell find -L "blogs/$(blog)" -type f -and -name *.$(BLOG_EXT_$(blog))))

define blog_rule =
.PHONY: $(blog)
$(blog): $(blog_src)
endef

define prune_blog_rule =
.PHONY: prune_$(blog)
prune_$(blog):
	./bin/prune_blog $(blog)
endef

all: microlog blog public out

.PHONY: out
out: $(out_deps)

$(foreach ext,$(sort $(out_deps_ext)),\
	$(eval $(call out_rule,$(ext),)))
$(foreach layout,$(layouts),\
	$(foreach ext,$(sort $(out_deps_ext)),\
		$(eval $(call out_rule,$(ext),.$(layout)))))

$(foreach blog,$(blogs),$(eval $(blog_rule)))

$(foreach blog,$(blogs),\
	$(foreach layout,$(layouts),\
		$(eval $(call blog_post_rule,$(blog),$(layout)))))
$(foreach blog,$(blogs),\
	$(eval $(call blog_post_rule,$(blog),)))

.PHONY: public
public: $(subst public/,out/,$(shell find -L public/ -type f))

out/%: public/%
	mkdir -p $(dir $@) && cp $< $@

.PHONY: prune
prune: $(addprefix prune_,$(blogs)) prune_out

.PHONY: prune_out
prune_out:
	./bin/prune_out

$(foreach blog,$(blogs),$(eval $(prune_blog_rule)))

.PHONY: clean
clean:
	rm -rf out src/microlog src/blog
