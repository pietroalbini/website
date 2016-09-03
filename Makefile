.PHONY: all html clean devel


all: html


# Environment creation

build/env: build/requirements.txt
	@rm -rf build/env
	@mkdir -p build/env
	@virtualenv -p python2 build/env
	@build/env/bin/pip install -r build/requirements.txt

# This only updates the build/requirements.txt file if its content is different
# than the requirements.txt's one. This means, if the requirements.txt file is
# more recent than the environment but its content reflects the environment,
# the virtualenv will not be recreated
build/requirements.txt: requirements.txt
	@mkdir -p build
	@cmp --silent requirements.txt build/requirements.txt || \
		cp requirements.txt build/requirements.txt


html: build/env *
	# Clean the build directory
	@rm -rf build/html
	@rm -rf build/tmp
	@mkdir -p build/html
	@mkdir -p build/tmp
	@mkdir -p build/cache
	# Make a new build
	@XDG_CACHE_HOME=build/cache \
		build/env/bin/lektor build -O build/html -f htmlmin
	# Minify CSS assets
	@build/env/bin/python -m rcssmin < build/html/+assets/style.css \
		> build/tmp/style.css
	@mv build/tmp/style.css build/html/+assets/style.css
	# Remove tmp files
	@rm -rf build/tmp


devel: build/env *
	@build/env/bin/lektor server -p 8000


clean:
	@rm -rf build
