---
layout: post
title: Downloading all the crates on crates.io
---

There are a lot of reasons you might want to download all the crates ever
uploaded to [crates.io], Rust's package registry: code analysis across the
whole public ecosystem, hosting a mirror for your company, or countless other
ideas and projects.

The team behind crates.io receives a lot of support request asking what's the
best and least impactful way to do this, so here is a little guide on how to do
that!

## Getting a list of all the crates

crates.io [offers multiple way][data-access] to interact with its data: the
[crates.io-index] GitHub repository, experimental [daily database dumps][dumps]
and the crates.io API.

The way I recommend to get the list of all the crates is to rely on the index:
the experimental database dumps are more heavyweight and are only updated
daily, while usage of the API is governed by the [crawlers policy][crawlers]
(limiting you to one API call per second). If you *absolutely* need to use the
API please talk with us by emailing [help@crates.io], and we'll figure out a
solution.

The index is [a git repository][crates.io-index], and the format of its content
is defined by [RFC 2141][index-specification]. There are crates such as
[crates-index] that allow you to easily query its contents, and I recommend
using them whenever possible.

## Downloading the packages

The best way to download the packages is to fetch them directly from our CDN.
Compared to calling the crates.io API, the CDN does not have rate limits and is
faster (as the API redirects you to the CDN after updating the download count).
The CDN URLs follow this pattern:

```
https://static.crates.io/crates/{name}/{name}-{version}.crate
```

For example, [here is the link to download Serde 1.0.0][serde-1.0.0]. Packages
are `tar.gz` files.

If you want to ensure the contents of the CDN were not tampered with you can
verify the SHA256 checksum of the file you downloaded by comparing it with the
`cksum` field in the index.

## Keeping your local copy up to date

The best way to keep your local copy up to date is to fetch a fresh list of
crates available on crates.io and check if all of them are present in the local
system, downloading the ones you're missing. I personally recommend this
approach as it's less error-prone, and it heals your copy automatically if for
whatever reason some of the changes are lost during a previous update.

Another interesting approach you could implement is to get the difference since
the last update of the index with `git diff`, parsing its output to get the
list of crates that were added. There are also third-party crates such as
[crates-index-diff] that automate this process for you. This approach is more
fragile and error-prone, but it might be the only sensible solution if checking
whether you downloaded a crate or not is slow or expensive.

## Common issues to be aware of

While the basics of downloading the contents of crates.io are simple, there are
a couple of issues to be aware of when implementing such tooling:

* The crates.io team strives to keep the registry as immutable as possible, but
  we can't always keep that promise. The technology world doesn't exist in a
  bubble, and there are laws everyone needs to abide to. Occasionally we
  receive takedown requests due to trademark or copyright issues, and we have
  to remove the crates both from the registry and the CDN: your tooling should
  handle existing crates disappearing.

* To reduce the download size for cargo users we regularly squash the index
  repository into a single commit, and start the git history from scratch. The
  previous history is kept in a separate branch. To account for this we
  recommend running these commands to update the index:

  ```
  git fetch
  git reset --hard origin/master
  ```

[crates.io-index]: https://github.com/rust-lang/crates.io-index
[crates.io]: https://crates.io
[crates-index]: https://crates.io/crates/crates-index
[crates-index-diff]: https://crates.io/crates/crates-index-diff
[crawlers]: https://crates.io/policies#crawlers
[data-access]: https://crates.io/data-access
[dumps]: https://static.crates.io/db-dump.tar.gz
[help@crates.io]: mailto:help@crates.io
[index-specification]: https://rust-lang.github.io/rfcs/2141-alternative-registries.html#registry-index-format-specification
[serde-1.0.0]: https://static.crates.io/crates/serde/serde-1.0.0.crate
