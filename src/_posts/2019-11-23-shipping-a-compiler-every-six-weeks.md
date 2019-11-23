---
layout: post
title: Shipping a compiler every six weeks
---

*This blog post is a slightly edited version of the live transcript of the talk
I gave at [RustFest 2019] in Barcelona on November 10th, 2019. As it's a
transcript some parts of it are a bit repetitive or badly worded, but I hope
the message behind the talk will be conveyed by this post anyway.*

*The original transcript was provided by the RustFest organizers, and it's
released under the [Creative Commons Attribution-ShareALike 4.0 International
License][cc-by-sa].*

*You can also [download the slides][slides] or [watch the recording of the
talk][yt].*

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/

---

Hi, everyone. In this talk I am going to shed a bit of light on how the Rust
release process works and why we do it that way.  As they said, I'm Pietro, a
member of the Rust Release team and the co-lead of the Infrastructure Team.
I'm actually a member of other teams: I do a lot of stuff in the project.

I think everyone is aware by now that we actually got a release out a few days
ago, with some features everyone awaited for, for a long time but that's not
the only release. Six weeks earlier we released 1.38 which was released in
September and [changed a hundred thousands lines of code][diff-1.38]. Users
just reported [5 regressions][reg-1.38] after the release came out. And only two of them
broke valid code, the other ones were just performance regressions or worse
error messages.

[diff-1.38]: https://github.com/rust-lang/rust/compare/1.37.0...1.38.0
[reg-1.38]: https://gist.github.com/pietroalbini/b02cadb117cfe49ad17e0168ce543e2d#1380

Six weeks earlier, there was another release, 1.37, and this changed [tens of
thousands of lines of code][diff-1.37] and we just got [3
regressions][reg-1.37] reported, and unfortunately all of them broke valid
code, but it's a very little number. Even before, we got 1.36 out in July with
just [4 regressions][reg-1.36] reported. I wanted to explain a little bit why
we do releases this fast, which creates a lot of problems for us, and how can
we prevent regressions, and just get very few reported after the release is
out?

[diff-1.37]: https://github.com/rust-lang/rust/compare/1.36.0...1.37.0
[reg-1.37]: https://gist.github.com/pietroalbini/b02cadb117cfe49ad17e0168ce543e2d#1370
[reg-1.36]: https://gist.github.com/pietroalbini/b02cadb117cfe49ad17e0168ce543e2d#1360

So why do we have this schedule? The question is interesting because it's
really unusual in the compiler world. I collected some stats on some of the
most popular languages. While there are some efforts to shorten the release
cycles (Python [recently announced][python-yearly] that they are going to
switch to a yearly schedule), Rust is the only compiler except for browsers
that's sort of popular and has a six-week release cycle. In the compiler world
that's pretty fast, but there is a simple reason why we do that: we have no
pressure to ship things.

[python-yearly]: https://www.python.org/dev/peps/pep-0602/

If a feature is not ready, we have issues, we can just delay it by a few weeks,
and nobody is going to care if it's going to get stabilised today or in a month
and a half. And we actually do that a lot. The most obvious example is [a few
weeks ago][await-a-bit-more], when we decided that async/await wasn't ready
enough to be shipped into Rust 1.38, because it turns out it wasn't actually
stabilised when the beta freeze happened and there were blocking issues so we
would have to rush the feature and backport the stabilization, and that's
something that we would not love to do.

[await-a-bit-more]: https://github.com/rust-lang/rust/pull/63209#issuecomment-520741844

We actually tried long release cycles, especially with the edition, and it
turns out they don't work for us. The stable edition came out in early December
and in September we still had questions on how to make the module system work.
We had [a proposal][module-1] in early September which was [not implemented
yet][module-2], and that's what actually was released, but the proposal had no
time to bake on nightly, users didn't have much time to test it. It broke a lot
of our internal processes.

[module-1]: https://github.com/rust-lang/rust/issues/53130#issuecomment-418824862
[module-2]: https://github.com/rust-lang/rust/issues/53130#issuecomment-418913061

We actually did this thing which is something I'm not comfortable with still,
which is we actually [landed a change][module-3] in the behaviour of the module
system directly on the beta branch, two weeks before the stable release came
out, and if we did a mistake there we would have no way to roll it back before
the next edition, and we don't even know if we are going to do a 2021 edition
yet. This PR broke almost all the policies we have, but we had to do it,
otherwise we would not have been be able to ship a working edition, and
thankfully it ended great.

[module-3]: https://github.com/rust-lang/rust/pull/56053

The 2018 edition works, I'm not aware of any huge mistakes we made but if we
actually made them it would've been really bad because we would have to wait a
lot to fix them and we would be stuck in the 2018 edition with a broken
features set for backward compatibility reasons.

So with such fast release cycles, how can we actually prevent regressions from
reaching the stable channel? Of course, the first answer is the compiler's test
suite, because rustc has a lot of tests. We have thousands of them that test
both the compiled output but also the error messages, and the tests run a lot:
we have 60 CI builders that run for each PR taking three to four hours. So, we
actually do a lot of testing but that's not enough because a test suite can't
really express everything that Rust language can do.

So we use the compiler to build the compiler itself: for every release we use
the previous one to build the compiler. On nightly we used beta, on beta we
used stable and on stable we used the previous stable. That allows us to catch
some corner cases, as the compiler codebase uses a lot of unstable features and
also it's a bit old so there are a lot of quirks in it. But still, that can't
actually catch everything.

We get bug reports from you all. We get them mostly from nightly, not from
beta, because people don't actually use beta. Asking our users to test beta is
something we can't really do: with such a fast cycle you don't have time to
test everything manually with the new compiler every six weeks. Languages with
long release cycles can afford to say "Hey, test the new beta release", but we
can't, and even when we ask, people don't really do that.

So we had an idea. Why don't we test our users' code ourselves? This is an idea
that seems really bad and seems to waste a lot of money but it actually works
and it's [Crater].

[Crater]: https://github.com/rust-lang/crater

Crater is a project that [Brian Anderson][brson] started and I'm now the
maintainer of, which creates experiments which get all the source code
available on [crates.io] and [all the Rust repositories on GitHub][rust-repos]
with a `Cargo.lock`, so if you create an "Hello World" repo on GitHub, or an
[Advent of Code][aoc] solutions repository, that's actually tested for every
release to catch regressions.

[brson]: https://github.com/brson
[crates.io]: https://crates.io
[rust-repos]: https://github.com/rust-lang/rust-repos
[aoc]: https://adventofcode.com/

For each project we run `cargo test` two times, once with stable and one with
beta, and if `cargo test` runs on stable but fails on beta then that's a
regression, and we get a nice colourful report where we can inspect.

[This is the actual report for 1.39][report-1.39] and we got just 46 crates
that failed and those are regressions nobody reported before. The Release Team
manually goes through each (I hope we didn't break any of yours), manually
checks the log and then files issues. The Compiler Team looks at the issues,
fixes them and ships the fix to you all.

[report-1.39]: https://crater-reports.s3.amazonaws.com/beta-1.39-1/full.html

1.39 went pretty well. [This is 1.38][report-1.38] and we had 600 crates that
were broken, so if we didn't have Crater there is a good chance your project
wouldn't compile anymore when you updated, and this would break the trust you
have in the stable channel.

[report-1.38]: https://crater-reports.s3.amazonaws.com/beta-1.38-1/full.html

We know it's not perfect. We don't test any kind of private code because of
course we don't have access to your source code. But also we only test
crates.io and GitHub, and not other repositories such as GitLab, mostly because
nobody got around to write scrapers yet. Also not every crate can be built in a
sandbox environment (of course we have a sandbox, we can't just run any code
without protection because turns out people on the Internet are bad).

Crater is not really something we can scale forever in the long term because it
uses a lot of compute resources already, which thankfully are sponsored, but if
the usage of Rust skyrockets we are going to reach a point where it's not
economically feasible to run Crater in a timely fashion anymore.

Those are real problems but for now it works great. It allows to catch tens of
regressions that often affect hundreds of crates and it's the real reason why
we can afford to make such fast releases. Without it, this is my personal
opinion, but I know it's shared by other members of the Release Team, I
wouldn't be comfortable making releases every six weeks without Crater because
they would be so buggy I wouldn't use them myself.

So to recap, the fast release cycles that we have allow the team not to burn
out and to simply ignore deadlines, and that's great especially for a community
of mostly volunteers. And Crater is the real reason why we can afford to do
that. It's a tool that wastes a lot of money but actually gets us great
results.

So I'm going to be around the conference today so if you have any questions,
you want to implement support for other open source repositories, reach out to
me, I'm happy to talk to you all. Thanks!

## Questions from the audience

**You were hinting that maybe the edition idea wasn't such a success for us.
Would you think that jeopardises a possible 2021 edition of the language?**

The main issue wasn't really the edition itself; it was that we actually
started working on it really late. So basically we went way over time with
implementing the features. This is my personal opinion, it's not the official
opinion of the project, but if we make another edition I want explicit phases
where we won't accept any more changes after this date and to actually enforce
that because we nearly burnt out most of the team with the edition.  There were
people that were just for months fixing regressions and fixing bugs and that's
not sustainable, especially because most of the contributors to the compiler
are volunteers.

**For private repository, of course you cannot run Crater, but how could
somebody who has a private repository, a private crate setup, would run Crater,
or is that possible now?**

Someone could just test on beta and create bug reports if they fail to compile.
We have some ideas on how to create a Crater for enterprises but it's just a
plan, an idea, and at the moment we don't have enough development resources to
actually do the implementation, test and documentation work that such a project
would require.

**A lot of crates have peculiar requirements about their environments.  Can
you talk about how Crater handles that and specifically is it possible to
customise the environment in which my crates are built on Crater?**

So the environment doesn't have any kind of network access for obvious security
reasons, so you can't install the dependencies yourself but the build
environment runs inside Docker. We have [these big Docker images][build-env],
4GB, which have most of the system dependencies used in the ecosystem
installed. You can easily check whether your crate works or not with [docs.rs]:
since recently it uses the same build code as Crater, so if it builds on
docs.rs it builds on Crater as well.  And if it doesn't build, you can file an
issue, probably the [docs.rs issue tracker][docsrs-issue] is the best place,
and if there are Ubuntu 18.04 packages available we are just going to install
them on the build environment, and then your package will work.

[build-env]: https://github.com/rust-lang/crates-build-env
[docs.rs]: https://docs.rs
[docsrs-issue]: https://github.com/rust-lang/docs.rs/issues

**How long does it take to run Crater on all of the crates?**

Okay, so that actually varies a lot because we are making constant changes to
the build environment, changes with the virtual machines and such. I think at
the moment running `cargo test` on the entire ecosystem takes a week and
running `cargo check`, which we actually do for some PRs, takes three days: if
there is a pull request that we know is risky and could break code, we usually
run Crater beforehand just on that and in those cases we usually do `cargo
check` because is faster. The times really vary mostly because we make a lot of
changes to the virtual machines.

**Is it possible to supply the Crater run with more runners to speed up the
process?**

I think we could. At the moment, we are just in a sweet spot because we have
enough experiments that we fill out the servers, we don't have any idle time,
and the queue is not that long. If we had more servers then the end result is
that for a bunch of time the server is going to be idle so we are just wasting
resources. We have actually more sponsorship offers from corporations, so if we
reach a point where the queue is not sustainable anymore we are going to get
agents from them before asking the community. Also Crater is really heavy on
resources: at the moment I think we have 24 cores and 48GB of RAM, 4 terabytes
of disk space, so it's not something where you can throw out some small virtual
machine and get meaningful results out of it.

[RustFest 2019]: https://barcelona.rustfest.eu
[slides]: /assets/blog/shipping-a-compiler-every-six-weeks/slides.pdf
[yt]: https://youtu.be/LPpulLUUVCc?t=10470
