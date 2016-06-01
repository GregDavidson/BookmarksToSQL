%.tags: %.html
	sed -e 's+\([<>]\)+ \1+g' -e 's+\([^<]\)/+\1 /+g' $^ | tr -s '[[:space:]]' '\n' | sed -n '/^<\(\/\?\)\(..*\)/s//\2\1/p' | sort -u -o $@
#	sed 's+\([<>/]\)+ \1+g' $^ | tr -s '[[:space:]]' '\n' | sed -n '/^<\(..*\)/s//\1/p' | sort -u -o $@
%.vars: %.html
	egrep -i '^[[:space:]]*\<(FEED|FEEDURL|WEBSLICE|ISLIVEPREVIEW|PREVIEWSIZE|ICON_URI)=' $^ | tee $@
%.tidy-xml: %.html
	tidy -wrap 0 -utf8 -asxml $^ 2>/dev/null | sed 's/<html[^>]*>/<html>/' > $@
%.sql: %.tidy-xml
	xsltproc -o $@ tidy-bookmarks-to-sql.xsl $^
