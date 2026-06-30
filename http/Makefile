include config.mk


#############
# VARIABLES #
#############

src_files := $(filter-out %.args,$(wildcard src/*.upp*)) $(filter-out %.args,$(wildcard src/**/*.upp*))
src_files_ext := $(suffix $(src_files))
out_deps_ext := $(src_files_ext:.upp%=%)

component_files := $(shell find -L share/components -type f)
layout_files := $(wildcard share/layouts/*.layout.upp*)
layouts := $(notdir $(basename $(basename $(layout_files))))

remove_all_layouts = $(call remove_layouts,$(layouts),$(1))
remove_layouts = $(let first rest,$(1),$(call remove_layout,$(first),$(if $(rest),$(call remove_layouts,$(rest),$(2)),$(2))))
remove_layout = $(subst .$(1).upp,.,$(2))
out_deps := $(subst .upp,.,$(call remove_all_layouts,$(addprefix out/,$(src_files:src/%=%))))
out_deps_without_src := $(filter-out $(out_deps),$(shell find -L out -type f))
out_deps += $(out_deps_without_src)

blogs := $(subst blogs/,,$(wildcard blogs/*))


#############
# FUNCTIONS #
#############

blog_post_target = src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml
blog_post_src = blogs/$(blog)/%.$(BLOG_EXT_$(blog)) $$(wildcard bin/*)
blog_src = $(patsubst \
	blogs/$(blog)/%.$(BLOG_EXT_$(blog)),\
	src/$(blog)/%$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml,\
	$(shell find -L "blogs/$(blog)" -type f -and -name *.$(BLOG_EXT_$(blog))))
blog_src_without_post_src = $(filter-out $(blog_src),$(shell find -L "src/$(blog)" -type f -and -name *.$(BLOG_LAYOUT_$(blog)).upphtml))
default_layout_file = $(if \
	$(shell [ -f "share/layouts/default.layout.$(ext)" ] && echo 1),\
	share/layouts/default.layout.$(ext))
layout_file = $(if $(layout),share/layouts/$(layout).layout.upp$(ext),$(default_layout_file))

define out_rule =
out/%.$(ext): src/%$(if $(layout),.$(layout)).upp$(ext) $(layout_file) $(component_files)
	./bin/mkws https://joeac.net "$$$$(realpath $$<)"
endef

define blog_rss_feed_rule =
out/$(blog)/rss.xml: src/$(blog)/rss.uppxml $(blog_src) $(wildcard bin/*)
	./bin/mkws https://joeac.net "$$(realpath src/$(blog)/rss.uppxml)"
endef

define blog_rule =
.PHONY: $(blog)
$(blog): $(blog_src_without_post_src) $(blog_src) out/$(blog).html
endef

define blog_post_rule =
$(blog_post_target): $(blog_post_src) $(let ext,html,$(layout_file) $(component_files))
	./bin/blog \
		-i $(blog) \
		$(if $(BLOG_LAYOUT_$(blog)),-l $(BLOG_LAYOUT_$(blog))) \
		$(BLOG_FLAGS_$(blog)) \
		-f $$*.$(BLOG_EXT_$(blog))
endef

define blog_index_rule =
out/$(blog).html: src/$(blog).upphtml $(blog_src) $(wildcard bin/*)
	./bin/mkws https://joeac.net "$$(realpath src/$(blog).upphtml)"
endef

define prune_blog_src_file_rule =
$(let rel_basename,$(patsubst src/$(blog)/%.$(BLOG_LAYOUT_$(blog)).upphtml,%,$(file)),
blogs/$(blog)/$(rel_basename).$(BLOG_EXT_$(blog)):
	rm $(file)
)
endef

define prune_blog_out_file_rule =
$(let rel_basename,$(patsubst src/$(blog)/%.$(BLOG_LAYOUT_$(blog)).upphtml,%,$(file)),
$(file):
	rm out/$(rel_basename).html
)
endef

define prune_out_file_rule =
$(let orig_ext,$(patsubst .%,%,$(suffix $(file))),
$(let ext,$(patsubst upp%,%,$(orig_ext)),
$(let rel_basename,$(patsubst out/%.$(orig_ext),%,$(file)),
$(let src_file,src/$(rel_basename).upp$(ext),
$(let src_files_with_layouts,$(foreach layout,$(layouts),src/$(rel_basename).$(layout).upp$(ext)),
$(let public_file,public/$(rel_basename).$(orig_ext),
$(src_file) $(src_files_with_layouts) $(public_file):
	rm $(file)
))))))
endef


#########
# RULES #
#########

all: $(blogs) public out vendor
	$(MAKE) out # if blog posts have been pruned, outfiles must be re-calculated

share/man/man1/pp.1:
	cp pp/pp.1 share/man/man1/pp.1

.PHONY: out
out: bin/pp $(out_deps)

bin/pp:
	cd pp && $(MAKE) && chmod +x pp && cp pp ../bin/pp

$(foreach ext,$(sort $(out_deps_ext)),\
	$(eval $(out_rule)))
$(foreach layout,$(layouts),\
	$(foreach ext,$(sort $(out_deps_ext)),\
		$(eval $(out_rule))))

$(foreach blog,$(blogs),$(eval $(blog_rule)))
$(foreach blog,$(blogs),$(eval $(blog_index_rule)))

$(foreach blog,$(blogs),\
	$(foreach layout,$(layouts),\
		$(eval $(call blog_post_rule,$(blog),$(layout)))))
$(foreach blog,$(blogs),\
	$(eval $(call blog_post_rule,$(blog),)))

$(foreach blog,$(blogs),$(eval $(blog_rss_feed_rule)))

.PHONY: public
public: $(subst public/,out/,$(shell find -L public/ -type f))

out/%: public/%
	mkdir -p $(dir $@) && cp $< $@

$(foreach file,$(out_deps_without_src),$(eval $(prune_out_file_rule)))
$(foreach blog,$(blogs),$(foreach file,$(blog_src_without_post_src),$(eval $(prune_blog_src_file_rule))))

vendor: composer.json composer.lock
	composer install

.PHONY: clean
clean:
	rm -rf \
	vendor \
	out \
	$(foreach blog,$(blogs), \
		$(foreach ext,upphtml upphtml.args,\
			src/$(blog)/*$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).$(ext)))
