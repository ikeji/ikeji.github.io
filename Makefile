all:
	jekyll build

publish:
	git push

serve:
	jekyll serve

post:
	test -n "$(title)" || read -p "Enter a title for your post: " title; \
		export title_slug=`echo $${title:-Untitled} | sed -E -e 's/[^[:alnum:]]/-/g' -e 's/^-+|-+$$//g' | tr -s '-' | tr A-Z a-z`; \
		export post_path=_posts/`date +%Y-%m-%d`-$$title_slug.markdown; \
		test -f $$post_path && { echo "Error: $$post_path already exists" ; exit 1; }; \
		echo "Creating $$post_path"; \
		echo "---"                                      >> $$post_path; \
		echo "layout: post"                             >> $$post_path; \
		echo "title: \"$$title\""                       >> $$post_path; \
		echo "date: `date +"%Y-%m-%d %H:%M:%S %z"`"     >> $$post_path; \
		echo "categories: "                             >> $$post_path; \
		echo "---"                                      >> $$post_path;

clean:
	rm -rf _site
