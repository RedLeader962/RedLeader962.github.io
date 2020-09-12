---
published: false
layout: distill
title: a Distill post with code
date: 2015-07-15 15:09:00
description: an example of a blog post with some code
---


### Using Distill html syntax 

- Using **Distill template** html tag `d-code` 
    - Supported language: python, clike, lua, bash, go, markdown, julia
    - See [template/d-code.js at master · distillpub/template](https://github.com/distillpub/template/blob/master/src/components/d-code.js) for detail on `d-code`
    - ♜ ref: [distillpub/template: This is the repository for the distill web framework](https://github.com/distillpub/template)
- Distill syntax highlighter use [**Prism**](https://prismjs.com/index.html) 
    - Prism [basic usage](https://prismjs.com/index.html#basic-usage) 
    - [Download ▲ Prism](https://prismjs.com/download.html#themes=prism-okaidia&languages=markup+css+clike+javascript+bash+latex+lua+python+regex+yaml) (with my selected language)

```markup
<d-code block language="python">
code code code code 
</d-code>
```

Inline <d-code language="python">b, a = a, b</d-code>

<d-code block language="python">
def compute_TD_target(rewards: list, v_estimates: list, discount) -> np.ndarray:
    """ Compute the Temporal Difference target for the full 
            trajectory in one shot using element wise operation. """
    rew_t = np.array(rewards)
    _, V_tPrime = get_t_and_tPrime_array_view_for_element_wise_op(v_estimates)
    TD_target = rew_t + discount * V_tPrime
    return TD_target
</d-code>

Use `myCode-body-outset` to make a larger code box
```markup
<d-code block language="python" class="myCode-body-outset">
code code code code
</d-code>
```

<d-code block language="bash" class="myCode-body-outset">
@article{lcoupal2019implementation,
  author   = {Coupal, Luc},
  journal  = {redleader962.github.io/blog},
  title    = {% raw  %}{{Do implementation details matter in Deep Reinforcement Learning?}}{% endraw %},
  year     = {2019},
  url      = {https://redleader962.github.io/blog/2019/do-implementation-details-matter-in-deep-reinforcement-learning/},
  keywords = {Deep reinforcement learning,Reinforcement learning,policy gradient methods,Software engineering}
}
</d-code>

### Using Markdown syntax


```Tex
@article{lcoupal2019implementation,
  author   = {Coupal, Luc},
  journal  = {redleader962.github.io/blog},
  title    = {% raw  %}{{Do implementation details matter in Deep Reinforcement Learning?}}{% endraw %},
  year     = {2019},
  url      = {https://redleader962.github.io/blog/2019/do-implementation-details-matter-in-deep-reinforcement-learning/},
  keywords = {Deep reinforcement learning,Reinforcement learning,policy gradient methods,Software engineering}
}
```

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
(!) So far it mess up with the _Distill web framework_ if you use `linenos` in the **_liquid tag_**
 
Inline {% highlight python %} b, a = a, b {% endhighlight %}

{% highlight python %}
def compute_TD_target(rewards: list, v_estimates: list, discount) -> np.ndarray:
    """ Compute the Temporal Difference target for the full 
            trajectory in one shot using element wise operation. """
    rew_t = np.array(rewards)
    _, V_tPrime = get_t_and_tPrime_array_view_for_element_wise_op(v_estimates)
    TD_target = rew_t + discount * V_tPrime
    return TD_target
{% endhighlight %}



