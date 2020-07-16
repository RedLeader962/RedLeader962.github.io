---
published: true
layout: distill
title: TEMPLATE - Collapsable card
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


<div style="padding-top: 1em; padding-bottom: 3em; margin-top: 0em">
        <button class="btn btn-lg btn-block button-dark" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="false" aria-controls="collapseExample">
        Quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
        </button>
    <div id="quick-refresher" class="collapse show">
        <div class="card l-body" style="margin-bottom: 1em; padding-top: 0em; margin-top: 0em; z-index:-10;">
    <!-- 
                <div class="card-header remark-card-header">
                    Quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
                </div>
     -->
            <div class="card-body ">
                    <p class="card-text" style="margin-bottom: 0em;">
                    We need to train two neural network:
                    </p>
                    <ul class="card-text" style="margin-left: 1.5em;">
                        <li>
                        the <b>actor network</b> <d-math>\pi_{\theta}</d-math> (the one reponsible for making acting decision in the environment)
                        </li>
                        <li>
                        the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> (the one responsible for evaluating if <d-math>\pi_\theta</d-math> is doing a good job)
                        </li>
                    </ul>
                    <p class="card-text" style="margin-top: 1.5em;">The <b>gradient of the Actor-Critic objective</b> goes like this</p>
                    <d-math block class="card-d-math-display" style="margin-left: 5em; margin-bottom: 1.35em;">
                        \nabla_\theta J(\theta) \, \approx \, \frac{1}{N} \sum_{i = 1}^{N} \sum_{t=1}^\mathsf{T} \nabla_\theta \, \log  \, \pi_\theta (\mathbf{a}_{t}^{_{(i)}} | \mathbf{s}_{t}^{_{(i)}} ) \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}})
                    </d-math>
                    <p class="card-text" style="margin-bottom: 0em;">
                        with the <b>advantage</b>
                        <d-math>
                            \widehat{A}^\pi(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, = \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, - \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}})
                        </d-math>
                    </p>
                <p class="card-text" style="margin-top: 2em;">
                    Training the <b>critic network</b> <d-math>\widehat{V}_\phi^\pi</d-math> part is a supervised regression problem that we can define like this:
                </p>
                <d-math block class="card-d-math-display" style="margin-left: 11em; margin-bottom: 0.35em;">
                    \mathcal{D}^{\text{train}} \, = \, \Big\{ \, \Big( \ \mathbf{x}^{_{(i)}} \, , \, y^{_{(i)}} \, ) \,  \Big)  \, \Big\} 
                </d-math>
                <p class="card-text" style="margin-bottom: 0em;">with</p>
                <ul class="card-text" style="margin-left: 1.5em">
                    <li>
                    the <b>input</b> <d-math>\, \mathbf{x}^{_{(i)}} \, := \, \mathbf{s}_{t}^{_{(i)}} \,</d-math> the state <d-math>\mathbf{s}</d-math> at timestep <d-math>t</d-math> of the <d-math>i^e</d-math> sample 
                    </li>
                    <li>
                    and the <b>bootstrap target</b>
                    <d-math>
                    \, y^{_{(i)}} \, := \, r(\mathbf{s}_{t}^{_{(i)}}, \mathbf{a}_{t}^{_{(i)}}) + \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \, \approx \, V^\pi(\mathbf{s}_t) 
                    </d-math>
                    </li>
                </ul>
                <p class="card-text" style="margin-top: 2em;">
                 <d-math block class="card-d-math-display" style="margin-left: 9.5em">
                        L\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, \middle| \, y^{_{(i)}}  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}^{_{(i)}}) \, - \, y^{_{(i)}}  \, \right\|^2 
                 </d-math></p>
            </div>
        </div>
    <!-- 
    -->
    </div>
</div>
