---
layout: page
---


{%- if site.posts.size > 0 -%}
    {%- for post in site.posts -%}
        {%- assign date_format = site.plainwhite.date_format | default: "%b %-d, %Y" -%}
---
### [{{post.title}}]({{post.url}})
{{post.excerpt}}
  <div class="posts-index-date"> {{post.date | date: date_format }} </div>
    {%- endfor -%}
{%- endif -%}
