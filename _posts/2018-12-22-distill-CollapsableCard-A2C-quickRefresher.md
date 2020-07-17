---
published: true
layout: distill
title: TEMPLATE - Collapsable CARD
description: Quick refresher on Advantage Actor-Critic method with bootstrap target
date: 2018-12-22

authors:
  - name: Albert Einstein
    url: "https://en.wikipedia.org/wiki/Albert_Einstein"
    affiliations:
      name: IAS, Princeton
  - name: Boris Podolsky
    url: "https://en.wikipedia.org/wiki/Boris_Podolsky"
    affiliations:
      name: IAS, Princeton
  - name: Nathan Rosen
    url: "https://en.wikipedia.org/wiki/Nathan_Rosen"
    affiliations:
      name: IAS, Princeton
      
bibliography: 2018-12-22-distill.bib

# Below is an example of injecting additional post-specific styles.
# If you use this post as a template, delete this _styles block.
_styles: >
  .fake-img {
    background: #bbb;
    border: 1px solid rgba(0, 0, 0, 0.1);
    box-shadow: 0 0px 4px rgba(0, 0, 0, 0.1);
    margin-bottom: 12px;
  }
  .fake-img p {
    font-family: monospace;
    color: white;
    text-align: left;
    margin: 12px 0;
    text-align: center;
    font-size: 16px;
  }

---


<p id="subsec-which-implementation-details-are-impactful-or-critical"></p>

### <i class="fas fa-th"></i> Which implementation details are impactful or critical?

We have established 
<a href="#subsec-regarding-implementation-details">previously</a>
that implementation details could be impactful with regards to the
performance of an algorithm eg.: how fast it converges to an optimal solution or
 if it converges at all.  

Could it be impactful else where? Like wall clock speed for example or
memory management. Of course it could, any book on data structure or
algorithm analysis support that claim. On the other end, there is this famous
say in the computer science community :
<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    Early optimization is a sin.
</blockquote>

Does it apply to the ML/RL field? Anyone that has been waiting for an
experiment to conclude after a few strikes will say that waiting for
result is playing with their mind and that speed matters **a lot** to them
at the moment. Aside from mental health, the reality is that **the
faster you can iterate between experiments, the faster you get feedback
from your decisions, the faster you can make adjustments towards your
goals.** So optimizing for speed sooner than later is impactful indeed
in ML/RL. It’s all about choosing what is a good optimization investment.  

So we now need to look for 2 types of implementation details: 
 
<ul class="fa-ul">
    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>those related to algorithm performance</li>
    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>and those related to wall clock speed.</li>
</ul>
 
That’s when things get trickier. Take for example the *value estimate* computation of the **critic** 
$\widehat{V}_\phi^\pi(\mathbf{s}) \, \approx \, V^\pi(\mathbf{s})$ 
in a **batch Actor-Critic** algorithm with a **bootstraps target** design.
I won't dive in the details here, but keep in mind that in the end, we just need $$\widehat{V}_\phi^\pi(\mathbf{s})$$ to compute the **critic bootstrap target** and
the **advantage** at the update stage. 
Knowing that, what’s the best place to compute $$\widehat{V}_\phi^\pi(\mathbf{s})$$? 
Is it at *timestep level* close to the *collect process* or at *batch level* close to the *update process*? 
 
<p class="text-center myLead" style="padding-top: 0em; padding-bottom: 0em">Does it even make a difference?</p>


<div class="collapsable-card l-body-outset" style="padding-top: 1em; padding-bottom: 3em; margin-top: 0em">
    <button class="btn btn-lg btn-block" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="false" aria-controls="collapseExample">
    A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
    </button>
    <!-- 
    <div id="quick-refresher" class="collapse">
    -->
    <div id="quick-refresher" class="collapse show">
        <div class="card">
            <div class="card-body">
                <p> We need to train two neural network: 
                <ul class="fa-ul">
                    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                    the <b>actor network</b> <d-math>\pi_{\theta}</d-math> (the one reponsible for making acting decision in the environment)
                    </li>
                    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                    the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> (the one responsible for evaluating if <d-math>\pi_\theta</d-math> is doing a good job)
                    </li>
                </ul>
                </p>
                <p>The <b>gradient of the Actor-Critic objective</b> goes like this
                <d-math block class="card-d-math-display">
                    \nabla_\theta J(\theta) \, \approx \, \frac{1}{N} \sum_{i = 1}^{N} \sum_{t=1}^\mathsf{T} \nabla_\theta \, \log  \, \pi_\theta (\mathbf{a}_{t}^{_{(i)}} | \mathbf{s}_{t}^{_{(i)}} ) \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}})
                </d-math>
                with the <b>advantage</b>
                <d-math>
                    \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, = \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, - \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}})
                </d-math>
                </p>
                <p style="margin-top: 2em;">
                    Training the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi\,</d-math> part is a supervised regression problem that we can define as
                    the training data
                        <d-math block class="card-d-math-display" style="margin-bottom: 0.35em;">
                        \mathcal{D}^{\text{train}} \, = \, \Big\{ \, \Big( \ \mathbf{x}^{_{(i)}} \, , \, y^{_{(i)}} \, ) \,  \Big)  \, \Big\} 
                        </d-math>
                    with
                    <ul class="fa-ul" style="margin-left: 3.5em; margin-top: -2.9em; padding-top: -2.9em;">
                        <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                        the <b>input</b> <d-math>\, \mathbf{x}^{_{(i)}} \, := \, \mathbf{s}_{t}^{_{(i)}} \,</d-math> the state <d-math>\mathbf{s}</d-math> at timestep <d-math>t</d-math> of the <d-math>i^e</d-math> sample 
                        </li>
                        <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                        and the <b>bootstrap target</b>
                            <d-math>
                            \, y^{_{(i)}} \, := \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) + \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, \approx \, V^\pi(\mathbf{s}_t) 
                            </d-math>
                        </li>
                    </ul>
                    and the lost function
                        <d-math block class="card-d-math-display" style="margin-top: 0em; margin-bottom: -1em">
                        L\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, \middle| \, y^{_{(i)}}  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, - \, y^{_{(i)}}  \, \right\|^2 
                        </d-math>
                </p>
            </div>
        </div>
    <!-- 
    -->
    </div>
</div>


**Casse 1 - _timestep level_ :** Choosing to do this operation at each timestep instead of doing it over
a batch might make no difference on a [*CartPole-v1* Gym
environment](https://github.com/openai/gym/blob/master/gym/envs/classic_control/cartpole.py)
since you only need to store in RAM at each timestep a 4-digit
observation and that trajectory length is capped at $200$ steps so you
end up with relatively small batches size. Even if that design choice
completely fails to leverage the power of matrix computation framework,
considering the setting, computing $$\widehat{V}_\phi^\pi$$
anywhere would be relatively fast anyway.

**Casse 2 - _batch level_ :** On the other hand, using the same design in an environment with very
high dimensional observation space like the [*PySc2
Starcraft*](https://github.com/deepmind/pysc2) environment <d-footnote>PySc2 have multiple observation output. As an example, minimap observation is an RGB representation of 7 feature layers with resolution ranging from 32 − 2562<sup>2</sup> where most pixel value give important information on the game state.</d-footnote>, will make
that same operation slower, potentially to a point where it could become
a bottleneck that will considerably impair experimentation speed. So
maybe a design where you compute $$\widehat{V}_\phi^\pi(\mathbf{s})$$
at *batch level* would make more sense in that setting.

**Casse 3 - _trajectory level_ :** Now let’s consider trajectory length. As an example, a 30-minute *PySc2
Starcraft* game is  $$\sim 40, 000$$ steps long. In order to compute
$$\widehat{V}_\phi^\pi(\mathbf{s})$$ at batch level, you need to store
in RAM memory each timestep observation for the full batch, so given the
observation space size and the range of trajectory length, in that
setting you could end up with RAM issues. If you have access to powerful
hardware like they have in Google Deepmind laboratory it won’t really be
a problem, but if you have a humble consumer market computer, it will
matter. So maybe in that case, keeping only observations from the
current trajectory and computing $$\widehat{V}_\phi^\pi(\mathbf{s})$$
at trajectory end would be a better design choice.  

What I want to show with this example is that **some implementation details might have no effect in some settings but can be a game changer in others.**  

This means that it’s a **setting sensitive** issue and the real question we need to ask myself is:

<p class="text-center myLead">
    How do I recognize <b>when</b> an implementation detail<br> becomes impactful or critical?   
</p>

