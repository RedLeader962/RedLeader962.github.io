---
published: false
layout: post
title: A post with code
date: 2015-07-15 15:09:00
description: an example of a blog post with some code
---

This theme implements a built-in Jekyll feature, the use of **Rouge**, for syntax highlighting.
It supports more than 100 languages.

- [Tutorial on Rouge theming](https://frankindev.com/2017/03/18/syntax-highlight-with-rouge-in-jekyll/) 
- ♜ Doc [**Rouge**](https://github.com/rouge-ruby/rouge)   
- [**Supported language**](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers): 
latex, Tex, Python, cpp, console, shell, sh, bash, java, javascript, matlab, markdown, json, html, css, ...

Note: Pygments is use only for syntax highlight css style 

Use **mardown code bloc** syntax or wrap your code in a **liquid tag**:

{% raw  %}
{% highlight python linenos %}  <br/> code code code <br/> {% endhighlight %}
{% endraw %}

The keyword `linenos` triggers display of line numbers.

---


### Using Markdown syntax

Inline `b, a = a, b`

```python
def compute_TD_target(rewards: list, v_estimates: list, discount) -> np.ndarray:
    """ Compute the Temporal Difference target for the full 
        trajectory in one shot using element wise operation. """
    rew_t = np.array(rewards)
    _, V_tPrime = get_t_and_tPrime_array_view_for_element_wise_op(v_estimates)
    TD_target = rew_t + discount * V_tPrime
    return TD_target
```


### Jekyl liquid tag with highlighter Rouge
 
Inline {% highlight python %} b, a = a, b {% endhighlight %}

{% highlight python linenos %}
def compute_TD_target(rewards: list, v_estimates: list, discount) -> np.ndarray:
    """ Compute the Temporal Difference target for the full 
            trajectory in one shot using element wise operation. """
    rew_t = np.array(rewards)
    _, V_tPrime = get_t_and_tPrime_array_view_for_element_wise_op(v_estimates)
    TD_target = rew_t + discount * V_tPrime
    return TD_target
{% endhighlight %}

---