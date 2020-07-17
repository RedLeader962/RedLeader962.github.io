---
published: false
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

...

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


<!---- Collapsable card ----------------------------------------------------------------------------------------------->
<div class="collapsable-card" style="padding-top: 1em; padding-bottom: 3em; margin-top: 0em">
    <div class="card-shadow">
        <!-- 
        <button class="btn btn-lg btn-block close-icon collapsed shadow-none" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="true" aria-controls="collapseExample">
        A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
        </button>
        <div id="quick-refresher" class="collapse">
        -->
        <button class="btn btn-lg btn-block close-icon shadow-none" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="true" aria-controls="collapseExample">
        A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
        </button>
        <div id="quick-refresher" class="collapse show">
            <div class="card shadow-none">
                <div class="card-body">
                    <p> We need to train two neural network: 
                    <ul class="fa-ul">
                        <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                        the <b>actor network</b> <d-math>\widehat{\pi}_{\theta}</d-math> (the one reponsible for making acting decision in the environment)
                        </li>
                        <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                        the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> (the one responsible for evaluating if <d-math>
                                \widehat{\pi}_\theta</d-math> is doing a good job)
                        </li>
                    </ul>
                    </p>
                    <p>The <b>gradient of the Actor-Critic objective</b> goes like this
                    <d-math block class="card-d-math-display">
                        \nabla_\theta J(\theta) \, \approx \, \frac{1}{N} \sum_{i = 1}^{N} \sum_{t=1}^\mathsf{T} \nabla_\theta \, \log  \, \pi_\theta (\mathbf{a}_{t} | \mathbf{s}_{t} ) \,  \widehat{A}^\pi\left(\mathbf{s}_{t}, r_{t}^{_{(i)}}, \mathbf{s}_{t+1}^{_{(i)}}\right)
                    </d-math>
                    with the <b>advantage</b>
                    <d-math block class="card-d-math-display">
                    \widehat{A}^\pi\left(\mathbf{s}_{t}, r_{t}^{_{(i)}}, \mathbf{s}_{t+1}^{_{(i)}}\right) \:\: = \:\: r_{t+1}^{_{(i)}} \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \ - \ \widehat{V}_\phi^\pi(\mathbf{s}_{t})
                    </d-math>
                    <span class="comment">
                        Note : <d-math>\mathbf{s}_t</d-math> is the current state at timestep <d-math>t</d-math> and was sampled at the previous iteration. On the other hand, both <d-math>r_{t+1}^{_{(i)}}</d-math> and <d-math>\mathbf{s}_{t+1}^{_{(i)}}</d-math> are sampled from the environnement by trying the policy <d-math>\widehat{\pi}_\theta (\mathbf{a}_{t} | \mathbf{s}_{t} ) </d-math> on the current state <d-math>\mathbf{s}_t</d-math> and seeing where it land. 
                    </span>
                    </p>
                    <p> Training the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi\,</d-math> part is a supervised regression problem that we can define as
                        the training data
                            <d-math block class="card-d-math-display" style="margin-bottom: 0.35em;">
                            \mathcal{D}^{\text{train}} \, = \, \Big\{ \, \Big( \ \mathbf{x}^{_{(i)}} \, , \, y^{_{(i)}} \, ) \,  \Big)  \, \Big\} 
                            </d-math>
                        with
                        <ul class="fa-ul" style="margin-left: 3.5em; margin-top: -2.9em; padding-top: -2.9em;">
                            <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                            the <d-math>i^e</d-math> <b>input</b> <d-math>\:\: \mathbf{x}^{_{(i)}} \, := \, \mathbf{s}_{t} \:\:</d-math> 
                            </li>
                            <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                            and the <b>bootstrap target</b>
                                <d-math>
                                \:\: y^{_{(i)}} \: := \: r_{t+1}^{_{(i)}} \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) 
                                </d-math>
                            </li>
                        </ul>
                        and the lost function
                        <d-math block class="card-d-math-display" style="margin-top: 0em; margin-bottom: -1em;">
                            L\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}) \, \middle| \, y^{_{(i)}}  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}) \, - \, y^{_{(i)}}  \, \right\|^2 
                        </d-math>
                    </p>
                </div>
            </div>
        <!-- 
        -->
        </div>
    </div>
</div>
<!--------------------------------------------------------------------------------------- Collapsable card ---(end)---->
 






**Casse 1 - _timestep level_ :** Choosing to do this operation at each timestep instead of doing it over
a batch might make no difference on a [*CartPole-v1* Gym
environment](https://github.com/openai/gym/blob/master/gym/envs/classic_control/cartpole.py)
since you only need to store in RAM at each timestep a 4-digit
observation and that trajectory length is capped at $200$ steps so you
end up with relatively small batches size. Even if that design choice
completely fails to leverage the power of matrix computation framework,
considering the setting, computing $$\widehat{V}_\phi^\pi$$
anywhere would be relatively fast anyway.

...


---

<hr class="remarkDbylineHorizontalRule">

<!-- 
<h5 class="remark-header">
    A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
</h5>
-->

# A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
    
<p class="remark-text" style="margin-bottom: 0em;">
We need to train two neural network:
</p>
<ul class="remark-text" style="margin-left: 1.5em;">
    <li>
    the <b>actor network</b> <d-math>\pi_{\theta}</d-math> (the one reponsible for making acting decision in the environment)
    </li>
    <li>
    the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> (the one responsible for evaluating if <d-math>\pi_\theta</d-math> is doing a good job)
    </li>
</ul>
<p class="remark-text" style="margin-top: 1.5em;">The <b>gradient of the Actor-Critic objective</b> goes like this</p>

$$
    \nabla_\theta J(\theta) \, \approx \, \frac{1}{N} \sum_{i = 1}^{N} \sum_{t=1}^\mathsf{T} \nabla_\theta \, \log  \, \pi_\theta (\mathbf{a}_{t}^{_{(i)}} | \mathbf{s}_{t}^{_{(i)}} ) \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}})
$$

<p class="remark-text" style="padding-top: 0.5em; margin-bottom: 0em;">
    with the <b>advantage</b>
    $
        \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, = \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, - \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}})
    $
</p>
<p class="remark-text" style="margin-top: 2em;">
    Training the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> part is a supervised regression problem that we can define as:
</p>
 
$$
    \mathcal{D}^{\text{train}} \, = \, \Big\{ \, \Big( \ \mathbf{x}^{_{(i)}} \, , \, y^{_{(i)}} \, ) \,  \Big)  \, \Big\} 
$$

<p class="remark-text" style="margin-bottom: 0em;">with</p>
<ul class="remark-text" style="margin-left: 1.5em; padding-bottom: 2em">
    <li>
    the <b>input</b> <d-math>\, \mathbf{x}^{_{(i)}} \, := \, \mathbf{s}_{t}^{_{(i)}} \,</d-math> the state <d-math>\mathbf{s}</d-math> at timestep <d-math>t</d-math> of the <d-math>i^e</d-math> sample 
    </li>
    <li>
    and the <b>bootstrap target</b>
    $
    \, y^{_{(i)}} \, := \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) + \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, \approx \, V^\pi(\mathbf{s}_t) 
    $
    </li>
</ul>
 
 $$
        L\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, \middle| \, y^{_{(i)}}  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, - \, y^{_{(i)}}  \, \right\|^2 
 $$
 
 
<hr class="remarkDbylineHorizontalRule">
<!-- 
-->
