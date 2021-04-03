---
layout: page
title: Chords Book
category: chords
sidebar_sort_order: 3
---


{%- if site.posts.size > 0 -%}
    {%- for post in site.posts -%}
        {%- if post.categories contains page.category -%}
            {%- assign date_format = site.plainwhite.date_format | default: "%b %-d, %Y" -%}

<div class="boxed">
<a href="{{post.url}}">{{post.title | remove: "chords" | remove: "Chords"}}</a>
</div>


      {%- endif -%}
    {%- endfor -%}
{%- endif -%}
