## Pietro Albini's website

Hey there! This is the source code of my website, which you can found at
[www.pietroalbini.org][website]. The website is powered by [Lektor][lektor], a
static file content management system you can customize from the ground up.

The website's content and source code are released under the Creative Commons
Attribution 4.0 license, see the LICENSE file for more details.

### Building the blog

In order to build the blog, you need to have Python 2 installed on your system,
as well as virtualenv and make. Then, you just need to run this command:

```
$ make
```

The website's HTML files will be located in `build/html`. If you want
auto-rebuild and the Lektor admin interface, you can instead use this command:

```
$ make devel
```

A webserver will be started on port 8000.

[website]: https://www.pietroalbini.org
[lektor]: https://www.getlektor.com
