---
layout: post
title: Civilization V paintings as your Linux wallpapers
---

[Sid Meier's Civilization V](http://store.steampowered.com/app/8930) is a great
turn-based strategy game, and it comes with a lot of art and music assets
bundled with it. I really like the paintings used as the loading screen's
background, so I wrote a small tool to extract those from the game files and to
rotate them as your favourite Linux distro's wallpaper.

![One of the paintings, representing an industrial era factory](/assets/blog/civ5-paintings-as-your-linux-wallpapers/desktop-1.jpg)

The tool I wrote is a Python 3 package, and it's made to be easy to use: it
extracts the wallpapers from the game files and it can configure cron to rotate
wallpapers. **You must have a copy of the game installed** on your computer in
order to extract wallpapers from it: I don't want to distribute them illegally,
and you're not wasting your money buying it, it's such a great game.

Also, the wallpaper rotation currently supports only the GNOME and Unity
desktop environments, but you can still extract the wallpapers from the game
files if you have another DE such as KDE or XFCE.

### Installing and configuring the tool

Before installing the tool, make sure you have Python 3 and ImageMagick
installed on your computer: without them the tool won't run properly. On
Debian/Ubuntu, you can install those by opening a terminal and executing this
command:

```
$ sudo apt install python3 imagemagick
```

Then you can execute the following commands to start using the tool:

```
$ sudo python3 -m pip install civ5-wallpapers
$ civ5-wallpapers setup
```

The first command fetches and installs the tool from the Python Packages Index,
and the second one is an interactive setup which helps you extract the
wallpapers and configure the rotation.

![Another painting, representing the International Space Station](/assets/blog/civ5-paintings-as-your-linux-wallpapers/desktop-2.jpg)

### Source code and advanced usage

All the source code of the tool is available under the GNU-GPL v3 (or later)
license in its [git repository][git]. I'd like to thank LRN from the
CivFanatics forum for its [game files unpacker][unfpk.py], which I then
[optimized and adapted][fpk] for this tool.

The tool currently lacks support for a lot of desktop environments in its
automatic rotation feature: if you want to implement it for your favourite one,
feel free to send a pull request and I'll happily release the changes!

There are also a few extra features in the tool, such as manually extracting
the wallpapers to a directory and manually change the current wallpaper. Check
out the [README][readme] for more details about that.

![A painting representing the Globe Teather](/assets/blog/civ5-paintings-as-your-linux-wallpapers/desktop-3.jpg)

*#OneMoreTurn*

[git]: https://github.com/pietroalbini/civ5-wallpapers
[unfpk.py]: http://forums.civfanatics.com/threads/civ-be-fpk-unpacker.540490/
[fpk]: https://github.com/pietroalbini/civ5-wallpapers/blob/master/civ5_wallpapers/fpk.py
[readme]: https://github.com/pietroalbini/civ5-wallpapers/blob/master/README.md
