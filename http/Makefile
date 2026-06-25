include config.mk


#############
# VARIABLES #
#############

src_files := $(filter-out %.args,$(wildcard src/*.upp*))
src_files += $(filter-out %.args,$(wildcard src/**/*.upp*))
src_files_ext := $(suffix $(src_files))
out_deps_ext := $(src_files_ext:.upp%=%)

component_files := $(shell find -L share/components -type f)
layout_files := $(wildcard share/layouts/*.layout.upp*)
layouts := $(notdir $(basename $(basename $(layout_files))))

out_deps := $(addprefix out/,$(src_files:src/%=%))
remove_layout_from_out_deps = out_deps := $$(subst $(1).upp,.,$$(out_deps))
$(foreach layout,$(layouts),$(eval $(call remove_layout_from_out_deps,.$(layout))))
$(eval $(call remove_layout_from_out_deps,))
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
$(blog): $(blog_src)
endef

define blog_post_rule =
$(blog_post_target): $(blog_post_src) $(let ext,html,$(layout_file) $(component_files))
	./bin/blog \
		-i $(blog) \
		$(if $(BLOG_LAYOUT_$(blog)),-l $(BLOG_LAYOUT_$(blog))) \
		$(BLOG_FLAGS_$(blog)) \
		-f $$*.$(BLOG_EXT_$(blog))
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

define prune_blog_rule =
.PHONY: prune_$(blog)
prune_$(blog):
	./bin/prune_blog $(blog) *$(if $(BLOG_LAYOUT_$(blog)),.$(BLOG_LAYOUT_$(blog))).upphtml
endef


#########
# RULES #
#########

all: bin/pp prune $(blogs) public out vendor

bin/pp:
	cd pp && $(MAKE) && cp pp ../bin/pp

share/man/man1/pp.1:
	cp pp/pp.1 share/man/man1/pp.1

.PHONY: out
out: $(out_deps)

$(foreach ext,$(sort $(out_deps_ext)),\
	$(eval $(out_rule)))
$(foreach layout,$(layouts),\
	$(foreach ext,$(sort $(out_deps_ext)),\
		$(eval $(out_rule))))

$(foreach blog,$(blogs),$(eval $(blog_rule)))

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

.PHONY: prune
prune: $(addprefix prune_,$(blogs))

$(foreach file,$(out_deps_without_src),$(eval $(prune_out_file_rule)))

$(foreach blog,$(blogs),$(eval $(prune_blog_rule)))

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
