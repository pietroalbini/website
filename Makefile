build: install
	bundle exec jekyll build

serve: install
	bundle exec jekyll serve -P 8000

install:
	bundle install --path vendor/bundle
