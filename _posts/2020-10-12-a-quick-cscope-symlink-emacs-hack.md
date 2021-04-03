---
layout: post
title: "A quick emacs+cscope hack for broken symlinks"
tags: tech jekyll
visibility: public
---

I use cscope in emacs as my primary code browsing tool for Linux kernel
development. However, I started to get annoyed by `cscope` errors for broken
symlinks. What is happening is that during the Linux kernel build process, a few
symlinks get created which are not needed once the kernel is built. I presume
that the build tooling doesn't clean up these symlinks after they are removed
and that confuses the cscope program. This results in the following annoying
messages when I try to lookup definition or text or anything:

```txt
======================================================================
Finding symbol: EXT4_FC_TAG_LINK
Database directory: /usr/local/google/home/harshads/repo/github-harshadjs-linux/

cscope: cannot find file include/dt-bindings/input/linux-event-codes.h

cscope: cannot find file include/dt-bindings/clock/qcom,dispcc-sm8150.h

cscope: cannot find file tools/testing/selftests/powerpc/nx-gzip/include/vas-api.h

cscope: cannot find file tools/testing/selftests/powerpc/vphn/vphn.c

cscope: cannot find file tools/testing/selftests/powerpc/vphn/asm/lppaca.h

cscope: cannot find file tools/testing/selftests/powerpc/primitives/asm/ppc_asm.h

cscope: cannot find file tools/testing/selftests/powerpc/primitives/asm/asm-compat.h

cscope: cannot find file tools/testing/selftests/powerpc/primitives/asm/feature-fixups.h

cscope: cannot find file tools/testing/selftests/powerpc/primitives/asm/asm-const.h

cscope: cannot find file tools/testing/selftests/powerpc/primitives/word-at-a-time.h

*** fs/ext4/fast_commit.h:
<global>[10]                   #define EXT4_FC_TAG_LINK 0x0004

*** fs/ext4/fast_commit.c:
__ext4_fc_track_link[443]      args.op = EXT4_FC_TAG_LINK;
ext4_fc_replay_link[1360]      trace_ext4_fc_replay(sb, EXT4_FC_TAG_LINK, darg.ino,
tag2str[1776]                  case EXT4_FC_TAG_LINK:
ext4_fc_replay_scan[1951]      case EXT4_FC_TAG_LINK:
ext4_fc_replay[2056]           case EXT4_FC_TAG_LINK:
```

These `cannot find file` messages get flooded in the cscope tiny buffer. For
now, I have implemented a quick fix where I have added a wrapper around `cscope`
that directs the messages wrote to `stderr` to `/dev/null`. Here's how it looks:

```sh
#!/bin/bash

cscope-bin $@ 2>/dev/null
```

With this, now the cscope buffer looks pretty again!

```txt
======================================================================
Finding symbol: EXT4_FC_TAG_LINK
Database directory: /usr/local/google/home/harshads/repo/github-harshadjs-linux/

*** fs/ext4/fast_commit.h:
<global>[10]                   #define EXT4_FC_TAG_LINK 0x0004

*** fs/ext4/fast_commit.c:
__ext4_fc_track_link[443]      args.op = EXT4_FC_TAG_LINK;
ext4_fc_replay_link[1360]      trace_ext4_fc_replay(sb, EXT4_FC_TAG_LINK,
darg.ino,
tag2str[1776]                  case EXT4_FC_TAG_LINK:
ext4_fc_replay_scan[1951]      case EXT4_FC_TAG_LINK:
ext4_fc_replay[2056]           case EXT4_FC_TAG_LINK:
```
