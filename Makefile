all:
	bundle2.7 exec jekyll serve --host 0.0.0.0

clean:
	rm -rf _site
