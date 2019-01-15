.PHONY: all html clean devel build-update-requirements


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
build-update-requirements:
	@mkdir -p build
	@cmp --silent requirements.txt build/requirements.txt || \
		cp requirements.txt build/requirements.txt


html: build-update-requirements build/env *
	@rm -rf build/html
	@mkdir -p build/html
	@mkdir -p build/cache
	@XDG_CACHE_HOME=build/cache \
		build/env/bin/lektor build -O build/html -f minify


devel: build-update-requirements build/env *
	@mkdir -p build/cache
	@XDG_CACHE_HOME=build/cache \
		build/env/bin/lektor server -p 8000 -O build/html -f minify


clean:
	@rm -rf build
