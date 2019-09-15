---
layout: post
title: Introducing Persuade
---

[Persuade](https://persuade.pietroalbini.org) is a small project I worked on in
the past two weeks. It's a simple presenter console (just like the ones Impress
and PowerPoint have), built entirely on web technologies and with support for
PDF files.

It's completly free, you can run it from my hosted instance or offline by just
downloading the source files. The [source code][gh] is released under the GPLv3
license.

![A screenshot of Persuade](/assets/blog/introducing-persuade/loading.png)

### How it works

When you open Persuade, you're asked to load your slides into the application:
you can choose them either from the local device or a remote URL (which must
support cross-origin requests, due to browser limitations). Then, you can
tune a few configuration params before starting.

After the presenter console is ready, a popup is opened by your browser: you
should move the popup to the projector's screen, and then go fullscreen. This
way, you can show the slides to your audience. The talk is then on you.

### What's under the hood

Persuade is technically a static website: there is no backend, and all the
logic is implemented client side with some JavaScript. This is great for a few
reasons:

* You can use Persuade while you don't have any internet connection: you just
  need to download the web page and open the `index.html` with your browser!
* Because everything happens locally, the slides aren't uploaded to a remote
  server: this allows you to use it even if you can't give confidential slides
  to third parties

The rendering of the PDF files is made by [PDF.js][pdfjs], a great project by
Mozilla Labs.

### Why I made this

When I give talks and I don't have my laptop with me, I only bring the PDF file
with the slides, not the whole Impress project. There is too much stuff which
might be missing from the device I'll be using, such as fonts, but even the
software itself. Everyone has a PDF reader though, and PDFs works cross-device
wonderfully.

This works great, but in those cases I miss the presenter console so much: it's
a great aid while talking the ability to see how much time is left and what's
the next slide. Persuade solves this problem perfectly: it works on most
browsers and you can use it offline and bring it with you on a pendrive.

### What's missing

The big missing feature in Persuade is the speaker notes. The problem with them
is not the implementation, which should be easy enough, but the fact I haven't
found a standard for including them in PDF files, and I don't want to include
support for countless different formats.

If you have any idea on what format should be implemented, please [tell
me][gh-1]!

### Try it out

If you want to try Persuade out, you can [use the hosted instance][hosted] or
[download the ZIP file with the sources][zip]. I hope it will be useful to you!

Pietro.

[gh]: https://github.com/pietroalbini/persuade
[pdfjs]: https://github.com/mozilla/pdf.js
[gh-1]: https://github.com/pietroalbini/persuade/issues/1
[hosted]: https://persuade.pietroalbini.org/app/
[zip]: https://persuade.pietroalbini.org/persuade.zip
