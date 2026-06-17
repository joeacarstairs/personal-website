BLOG_LAYOUT_blog := blog
BLOG_EXT_blog := gmi
BLOG_FLAGS_blog = -p 'cut_longlog_meta | gmi2upphtml' -a extract_longlog_meta

BLOG_LAYOUT_microlog := microlog
BLOG_EXT_microlog := gmi
BLOG_FLAGS_microlog := -t -p gmi2upphtml
