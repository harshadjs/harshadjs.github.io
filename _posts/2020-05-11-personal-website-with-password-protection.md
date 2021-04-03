---
layout: post
title: "Personal website with password protection"
tags: tech jekyll git website
---

After numerous attempts at finding a cheap and easy solution to making a
password protected static website, I finally have settled my mind on one! Before
going over the solution let me go over the requirements that I had in my mind
for the website:

* Cheap
* Static and blog-aware
* Password protection on a part of the website
* Smooth and easy workflow to move content from private part to public
* Preferably, an automatic CI/CD

I tried multiple solutions such as setting up Heroku dynos, CloudCanon
etc. None of the solutions satisfied all the requirements until I found this
option:

**GitHub + Jekyll + Makefile + AWS S3 + AWS Lambda**

Let me paint a high level picture of how the setup looks like:

# Two GitHub Repositories

Website content is split into two parts: public and private repositories. The
[public repository](https://github.com/harshadjs/harshadjs.github.io) works like
any other static website hosted on GitHub.

It contains all the jekyll build material and public posts. Private repository
only contains posts that are private.

# Public Repository Hosting

The public repository gets hosted on GitHub pages as any other static
website. This takes care of the public part of the website.

Setting up private part is slightly complex but it's a one-time effort. I'll try
to provide a high-level overview how that works.

# Password Protection

The private content is hosted in an AWS S3 bucket which only allows AWS
CloudFront to read the contents. I then setup AWS Lambda that runs when a viewer
tries to read content via CloudFront distribution. Here's a [step-by-step
tutorial](http://kynatro.com/blog/2018/01/03/a-step-by-step-guide-to-creating-a-password-protected-s3-bucket/)
on how to set up S3 and CloudFront.

# Building Private Website

In order to build the private website, we are going to need both the public and
private repositories. After cloning the public repository, we create a directory
named `<public_repo>/_posts_private` and clone the private repository in
it. Yeah, we could have used git submodules. But, given that the
`_posts_private` should point to a private repository, if we use submodules, it
will break GitHub's CI/CD for the public website. We don't want that to
break. So, we manually clone the private repository inside `_posts_private`
folder. The magic happens inside the `Makefile`.

|----------------------|---------------------------------------|
| Command              | Action                                |
|----------------------|---------------------------------------|
| `make _site_private` | Build private website                 |
|----------------------|---------------------------------------|
| `make _site_public`  | Build public website                  |
|----------------------|---------------------------------------|
| `make serve_private` | Build and run private website locally |
|----------------------|---------------------------------------|
| `make serve_public`  | Build and run public website locally  |
|----------------------|---------------------------------------|
| `make sync`          | Update private repository on S3       |
|----------------------|---------------------------------------|
| `make clean`         | Clean directory                       |
|----------------------|---------------------------------------|

After running `make sync`, we can see that the private part of the website is
published to S3/CloudFront. If you try to access it via CloudFront URL, you'll
see that a dialog pops up asking for your username and password.

# Tying Private and Public Repositories Together

Ok so we now have public part of the website working on GitHub pages and the
private part of the website working on S3/CloudFront. We are now going to tie
them together using a custom domain name! Domain names are pretty cheap
(10-20$/yr). So, what I did was I bought this domain name and configured the DNS
such that `harshad.me` points to the GitHub URL and `personal.harshad.me` points
to cloudfront URL. Here's how the DNS entries look:

|---------------------------|-------|-----------------------|------------|
| Name                      | Type  | Resolves to           | Comment    |
|---------------------------|-------|-----------------------|------------|
| harshad.me                | A     | 185.199.108.153       | GitHub IPs |
|                           |       | 185.199.109.153       |            |
|                           |       | 185.199.110.153       |            |
|                           |       | 185.199.111.153       |            |
| aws_verifier_key.personal | CNAME | aws_verifier_val.aws. |            |
| personal                  | CNAME | CloudFront URL        |            |
|---------------------------|-------|-----------------------|------------|

...and there you go! At the end of this, I had my public site live at -
[http://harshad.me](http://harshad.me) and the private part of the site is live at
[https://personal.harshad.me](https://personal.harshad.me)!
