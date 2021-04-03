---
layout: post
title: "Writing song chords in markdown"
tags: tech jekyll
visibility: public
---

I often struggled to keep chords for songs I played in a handy
place. For a couple of years I have been maintaining chords in a
Google Doc. Given the forgetful person that I'm, storing all the
chords in one place has come as a blessing. Having all the chords in
one place has helped me to be more organized about my music. It has
helped me collaborate better with other musicians.

However, using Google Docs for organizing chords has not since scaled
as I added more and more songs. Besides, I was maintaining all the
chords in one file. Maybe having individual files would have helped
the cause but it was nowhere close to what for example [UltimateGuitar
provides](https://tabs.ultimate-guitar.com/tab/bryan-adams/summer-of-69-chords-843137).

So, I thought, why not use technologies that work well for organizing
and presenting source code to organize music chords? The technologies
I'm referring to here are `git`, `markdown`, `jekyll` and `css`.

I have migrated all my chords from the Google doc to `markdown` files that I
maintain on GitHub. I have posted an example of chords here in my posts. This
has worked wonders for me and this post is meant to give a high level idea of
how you can use `Markdown/Liquid`, `Jekyll` and `Git` to organize and present
chords for your songs!

### Chords in Markdown + Liquid

To start off, I defined a new `category` type called `chords`. For
every `chords` post, I define the category at the beginning of the post.
```
---
layout: post
categories: chords
---
```

### Marking Chords in Markdown

I defined a new `<chords>` tag (note that this is not a HTML tag) as a way to
indicate that all the content following this tag should be rendered as
chords. This is ugly but it works for my usecase. Chords marker makes Liquid
templating language use a `<pre>` with a CSS class for all the content that
follows. As you will see in the following section, it's **critical** that you
use monospace font for rendering this `<pre>`formatted text in order to maintain
the mapping of where chords change according to lyrics.

```
<chords>
   I got my first real six-string,   Bought it at the five-and-dime
```

The next step is to write chords for the songs. I first place chords
just above the lyrics where the chords change and then annotate (and
differentiate) chords (from lyrics) by placing them in square
brackets.  Square brackets encountered after `<chords>` tag tell
Liquid templating language that these are chords and should have a
special css style assigned to it.
```
<chords>
[D                                  A]
   I got my first real six-string,   Bought it at the five-and-dime
```

Song sections (such as chorus, verse, prechorus) in the song use
`<ctag></ctag>` tag.
```
[D                              A]
   Jimmy quit, Joey got married,   I shoulda known we'd never get far
 
<ctag>Chorus</ctag>
[Bm             A              D                        G]
    Oh, when I look back now,    That summer seemed to last forever
```

### Liquid Templating to Render Chords

I then have following code in my layout file that renders chords.

*Note: In order to not confuse Liquid Templating used for this post, I
have left spaces between `{`, `}` and `%` characters.*

```
    { % if page.categories contains "chords" % }
      { % assign var content_split =  content | split:"<chords>" % }
      { { content_split[0] } }
      <pre class='highlight'>{ { content_split[1] |
        replace: "[", "<span class='chords'>" |
        replace: "]", "</span>" |
        replace: "<chords>", "<pre class='highlight'>" |
        replace: "<ctag>", "<span class='ctag'>" |
        replace: "</ctag>", "</span>" } }</pre>
    { % else % }
      { { content } }
    { % endif % }
```

### JS Tricks

I also have added a few Javascript tricks to implement some interesting
functions such as `Transpose` and `Auto-scroll` which I first found on
UltimateGuitar. These functions come very handy! For those who are interested
here's how the JS code for each look like. Just place these in the appropriate
location (right before the `{ { content_split[0] } }` line) in the above
template.

#### Auto-scroll

```
        window.scroll_state = 0;
        function autoscroll() {
          if (window.scroll_state == 0) {
            scroll = setInterval(function() { window.scrollBy(0, 1);
            console.log('start');}, 100);
            window.scroll_state = 1;
           } else {
            window.scroll_state = 0;
            clearInterval(scroll);
            console.log('stop');
          }
        }
	<button onclick="autoscroll();">Autoscroll</button>
```
#### Transpose
```
        function transpose(direction) {
          var ele = document.getElementsByClassName('chords');
          // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
          // C,C#, D,D#, E, F,F#, G,G#, A,A#, B
          for(var i=0;i<ele.length;i++) {
             var text  = ele[i].textContent;
             if (direction == 1) {
              text = text.replace(/C/g, "##");
              text = text.replace(/D/g, "####");
              text = text.replace(/E/g, "######");
              text = text.replace(/F/g, "#######");
              text = text.replace(/G/g, "#########");
              text = text.replace(/A/g, "###########");
              text = text.replace(/B/g, "#");
             } else {
              text = text.replace(/C/g, "############");
              text = text.replace(/D/g, "##");
              text = text.replace(/E/g, "####");
              text = text.replace(/F/g, "#####");
              text = text.replace(/G/g, "#######");
              text = text.replace(/A/g, "#########");
              text = text.replace(/B/g, "###########");
             }
             text = text.replace(/#############/g, "C");
             text = text.replace(/############/g, "B");
             text = text.replace(/###########/g, "AA");
             text = text.replace(/##########/g, "A");
             text = text.replace(/#########/g, "GG");
             text = text.replace(/########/g, "G");
             text = text.replace(/#######/g, "FF");
             text = text.replace(/######/g, "F");
             text = text.replace(/#####/g, "E");
             text = text.replace(/####/g, "DD");
             text = text.replace(/###/g, "D");
             text = text.replace(/##/g, "CC");
             text = text.replace(/#/g, "C");
             text = text.replace(/AA/g, "A#");
             text = text.replace(/GG/g, "G#");
             text = text.replace(/FF/g, "F#");
             text = text.replace(/DD/g, "D#");
             text = text.replace(/CC/g, "C#");
             ele[i].textContent = text;
          }
        }
      <button onclick="transpose(1);">+1</button>
      <button onclick="transpose(0);">-1</button>    
```
[Click here](/chords/2020/05/05/summer-of-69.html) to see how these chords
get rendered! Have fun adding chords to your blog!
