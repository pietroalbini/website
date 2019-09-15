## Pietro Albini's website

Hey there! This is the source code of my website, which you can found at
[www.pietroalbini.org][website]. The website is powered by [Jekyll].

The website's content and source code are released under the Creative Commons
Attribution 4.0 license, see the LICENSE file for more details.

### Building the blog

In order to build the blog you need to have Ruby and Bundler installed on your
system, as well as make. Then, you just need to run this command:

```
$ make
```

The website's HTML files will be located in `build`. If you want to
auto-rebuild the website on any change and serve it locally you can instead use
this command:

```
$ make serve
```

A webserver will be started on port 8000.

[website]: https://www.pietroalbini.org
[Jekyll]: https://jekyllrb.com
