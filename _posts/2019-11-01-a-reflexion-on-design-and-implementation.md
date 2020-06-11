---
published: true
layout: distill
title: A reflection on design, architecture and implementation details in Deep Reinforcement Learning
description: 'Lessons learned studing DRL algortihm from a software engineering perspective applied to research. Asking question like:
<i>Does implementation details realy matters? Which one does, when & why?</i>'

authors:
  - name: Luc Coupal
    url: "https://redleader962.github.io"
    affiliations:
      name: Université Laval
      url: https://www.ulaval.ca

bibliography: 2019-11-01-a-reflexion-on-design-and-implementation.bib

_styles: >
    d-byline {
        padding: 1.5rem 0;
        padding-bottom: 0em;
        margin-bottom: 0em;
        min-height: 1.8em;
    }
    .supervisorDbyline {
        contain: style;
        overflow: hidden;
        font-size: 0.8rem;
        line-height: 1.8em;
        padding: 1.5rem 0;
        min-height: 1.8em;
        padding-bottom: 0em;
        margin-bottom: 0em;
      }
    .supervisorDbylineTitle {
        font-size: 0.6rem;
        font-weight: 400;
        line-height: 1.8em;
        color: rgba(0, 0, 0, 0.5);
        text-transform: uppercase;
        margin: 0rem 0;
        padding: 0rem 0;
      }
    .supervisorDbyline a {
        color: rgba(0, 0, 0, 0.8);
        text-decoration: none;
        border-bottom: none;
      }
    .supervisorDbyline a:hover {
        text-decoration: none;
        color: #828282;
        border-bottom: none;
     }
    .supervisorThe {
        font-weight: 500;
    }
    .supervisorDbylineHorizontalRule {
        display: block;
        margin-top: 1.75em;
        height:1px;
        border-width:0;
        color:rgba(0, 0, 0, 0.1);
        background-color:rgba(0, 0, 0, 0.1)
    }
    d-article {
        border-top: 0px solid rgba(0, 0, 0, 0.1);
        padding-top: 0rem;
        margin-top: 0rem;
    }
---

<div style=""></div>

<!-- Bibtex citation key
Henderson2018
Plappert2017
Duan2016
Schulman2015a
Amiranashvili2018
-->

<div class="container supervisorDbyline">
    <div class="row">
        <div class="col">
            <p class="supervisorDbylineTitle"> Supervisor </p> 
        </div>
        <!-- 
            Force next columns to break to new line 
        -->
        <div class="w-100"></div>
        <div class="col">
            Professor 
                <a href="https://www.fsg.ulaval.ca/departements/professeurs/brahim-chaib-draa-166/" target="blank">
                  <span class="supervisorThe"> Brahim Chaib-draa </span>
                </a> 
        </div>
        <div class="col-md-8">
            Directeur du programme de baccalauréat en génie logiciel à l'<a href="https://www.ulaval.ca" target="blank">
            Université Laval
            </a> 
        </div>
    </div>
</div>

<hr class="supervisorDbylineHorizontalRule">


A quest for answers
===================

While I was finishing an essay on *Deep Reinforcement Learning -
Actor-Critic* method, a part of me felt that some important questions
 linked to the applied part were  unanswered or disregarded.  

Those questions were linked to design & architectural aspects of Deep
Reinforcement Learning from a software engineering perspective applied
to research.

<p class="text-center" style="font-weight: bolder;">
Which design & architecture should I choose?<br>
Which implementation details are impactful or critical?<br>  
Does it even matter?<br>
</p>

This essay is my journey through that reflection process and the lessons
I have learned on the importance of design decisions, architectural
decisions and implementation details in Deep Reinforcement Learning
(specificaly regarding the class of policy gradient algorithms).

<i class="fas fa-th-large"></i> Clarification on ambiguous terminology
--------------------------------------

<div class="definition">
    <dl style="padding-left: 0em;" class="row">
      <dt class="col-md-3">The setting</dt> 
      <dd class="col-sm-9 ml-auto">
        In this essay, with respect to an algorithm implementation, the term
        "setting" will refer to any outside element like the following:
        <h5>- implementation requirement:</h5>  
        method signature, choice of hyperparameter to expose or capacity to run
        multi-process in parallel…
        <h5>- output requirement:</h5>  
        robustness, wall clock time limitation, minimum return goal…
        <h5>– inputed environment:</h5>  
        observation space dimensionality, discreet vs. continuous action space,
        episodic vs. infinite horizon…
        <h5>– computing ressources:</h5>  
        available number of cores, RAM capacity…
      </dd>
      <dt class="col-md-3">Architecture (Software)</dt> 
      <dd class="col-sm-9 ml-auto">
        From the <a href="https://en.wikipedia.org/wiki/Software_architecture" target="blank">wikipedia page on Software
        architecture</a>
        <blockquote class="blockquote text-justify">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            refers to the fundamental structures of a software system and the
            discipline of creating such structures and systems. Each structure
            comprises software elements, relations among them, and properties of
            both elements and relations.
            <footer class="blockquote-footer text-right"> <cite title="Source Title">Clements et al.</cite></footer>
        </blockquote>
        In the ML field, it often refers to the computation graph structure,
        data handling and algorithm structure.
      </dd>
      <dt class="col-md-3">Design (Software)</dt> 
      <dd class="col-sm-9 ml-auto">
        There are a lot of different definitions and the line between design and
        architectural concern is often not clear. Let’s use the first definition
        stated on the 
        <a href="https://en.wikipedia.org/wiki/Software_design#cite_note-2" target="blank">wikipedia page on Software
        design</a>
        <blockquote class="blockquote text-justify">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            the process by which an agent creates a specification of a software
        artifact, <b>intended to accomplish goals</b>, using a set of primitive
        components and <b>subject to constraints</b>.
            <footer class="blockquote-footer text-right"> <cite title="Source Title">Ralf & Wand</cite></footer>
        </blockquote>
        In the ML field, it often refer to choices made regarding improvement
        technique, hyperparameter, algorithm type, math computation…
      </dd>
      <dt class="col-md-3">Implementation details</dt> 
      <dd class="col-sm-9 ml-auto">
        This is a term often a source of confusion in software engineering 
        <d-footnote>I recommend this very good post on the topic of <i>Implementation details</i> by Vladimir Khorikov: <a href="https://enterprisecraftsmanship.com/posts/what-is-implementation-detail/" target="blank">What is an implementation detail?</a></d-footnote>. 
        The
        consensus is the following:
        <p class="text-center lead" style="padding-top: 0.75em">
        <b>everything that should not leak outside</b>
        <b>a public API</b> is an implementation detail.
        </p>
        <p>So it’s closely linked to the definition & specification of an API but it’s not just code. <b>The meaning feel blurier in the machine learning
        field as I often have the impression that it’s usage implicitly mean</b> 
        <blockquote class="blockquote text-justify">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            everything that is not part of the math formula or the high-level algorithm is an implementation detail
        </blockquote>
        and also that
        <blockquote class="blockquote text-justify">
            <div class="lead">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            <span style="font-weight: bold">those are just</span> implementation details
            </div>
        </blockquote>
        </p>
      </dd>
    </dl>
</div>
  

<i class="fas fa-th-large"></i> Going down the rabbit hole
--------------------------

Making sense of *Actor-Critic* algorithm scheme definitively ticked my
curiosity. Studying the theoretical part was a relatively straight
forward process as there is a lot of literature covering the core theory
with well-detailed analysis & explanation.  

On the other hand, studying the applied part has been puzzling. I took
the habit when I study a new algorithm-related subject, to first
implement it by myself without any code example. After I’ve done the
work, I look at other published code examples or different framework
codebases. This way I get a intimate sense of what’s going on under the
hood and it makes me appreciate other solutions to problems I have
encountered that often are very clever. It also helps me to highlight
details I was not understanding or for which I was not giving enough
attention. Proceeding this way takes more time, it’s sometimes a reality
check and a self-confidence shaker, but in the end, I get a deeper
understanding of the studied subject.  

So I did exactly that. I started by refactoring my *Basic Policy
Gradient* implementation toward an *Advantage Actor-Critic* one. I made
a few attempts with unconvincing results and finally managed to make it
work. I then started to look at other existing implementations. Like it
was the case for the theoretical part, there was also a lot of
available, well-crafted code example & published implementation of
various *Actor-Critic* class 
algorithm <d-footnote>
    - <a href="https://github.com/openai/baselines" target="blank">OpenAI Baseline</a><br>
    - <a href="https://github.com/Breakend/DeepReinforcementLearningThatMatters" target="blank">DeepReinforcementLearningThatMatters on GitHub</a> The accompanying code for the paper "<a href="https://arxiv.org/abs/1709.06560" target="blank">Deep Reinforcement Learning at Matters</a>"<d-cite key="Henderson2018"></d-cite><br>
    - <a href="https://github.com/openai/spinningup/blob/master/spinup/algos/vpg/vpg.py" target="blank">OpenAI: Spinning Up</a>, by Josh Achiam;<br>
    - <a href="https://github.com/dennybritz/reinforcement-learning/blob/master/PolicyGradient" target="blank">Ex Google Brain resident Denny Britz GitHub</a><br>
    - <a href="https://github.com/lilianweng/deep-reinforcement-learning-gym/blob/master/playground/policies/actor_critic.py" target="blank">Lil’Log GitHub by Lilian Weng</a>, research intern at OpenAI<br> 
</d-footnote>. 

However, I was surprised to find that most of serious implementations
were very different. The high-level ideas were more or less the same,
taking into account what flavour of *Actor-Critic* was the implemented
subject, but the implementation details were more often than not very
different. To the point where I had to ask myself if I was missing the
bigger picture. Was I looking at esthetical choices with no implication,
at personal touch taken likely or **was I looking at well considered,
deliberate, impactful design & architectural decision**?  

While going down that rabbit hole, the path became even blurrier when I
began to realize that some design implementation related to theory and
others related to speed optimization were not having just plus value,
they could have a tradeoff on certain settings.  

Still, a part of me was seeking for a clear choice like some kind of
*best practice*, *design patern* or *most effective architectural
pattern*. Which led me to those next questions:

<p class="text-center myLead">
    <b>Which design & architecture</b> should I choose?<br>  
    <b>Which implementation details</b> are impactful or critical?<br>  
    <b>Does it even matter?</b><br>  
</p>

<div id="sec-does-it-even-matter"> </div>

### <i class="fas fa-th"></i> Does it even matter?

Apparently, it does a great deal as Henderson, P. et al. demonstrated in
their paper *Deep reinforcement learning that matters* <d-cite key="Henderson2018"></d-cite>  (from McGill’s
university and Microsoft Malumba Montreal). Their goal was to highlight
many recurring problems regarding reproducibility in DRL publication.
Even though my concerns were not on reproducibility, I was astonished by
how much the questions and doubts I was experiencing at that time were
related to some of their findings.

<div id="subsec-regarding-implementation-details"> </div>

**Regarding implementation details:** One disturbing result they got was on one experiment they conducted on
the performance of a given algorithm across different code base. Their
goal was “to draw attention to the variance due to implementation
details across algorithms”. As an example they compared 3 high quality
implementations of TRPO: OpenAI Baselines<d-cite key="Plappert2017"></d-cite> , OpenAI rllab<d-cite key="Duan2016"></d-cite>  and the
original TRPO<d-cite key="Schulman2015a"></d-cite> codebase. 

The way I see it, those are all codebase linked to publish paper so they
were all implemented by experts and they must have been extensively peer
reviewed. So I would assume that given the same setting (same
hyperparameters, same environment) they would all have similar
performances. As you can see, that assumption was wrong.


<figure id="trpo-codebase-comparison-henderson-2018" class="l-body-outset">
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/trpo_codebase_result2_drlthatMatter.png' | relative_url }}" />
        </div>
    </div>
    <figcaption>
    <strong>TRPO codebase comparison using a default set of hyperparameters.</strong><br>
    <b>Source:</b> Figure 35 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite>
    </figcaption>
</figure>


They also did the same experiment with DDPG and got similar results.
They found that 

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    <b>... implementation differences which are often not reflected in
    publications can have dramatic impacts on performance</b> ... This
    (result) demonstrates the necessity that implementation details be
    enumerated, codebases packaged with publications ...
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


This does not answer my question about “Which implementation detail are
impactful or critical?” but it certainly tells me **that some
implementation details are impactful or critical** and this is an aspect
that deserves a lot more attention.

<div id="subsec-regarding-the-setting"></div>

**Regarding the setting:** In another experiment, they examine the impact an environment choice
could have on policy gradient family algorithm performances. They made a
comparison using 4 different environments with 4 different algorithms. <d-footnote>Environment: Hopper, HalfCheetah, Swimmer and Walker are continuous control task from OpenAI MuJoCo Gym Algorithm: TRPO, PPO, DDPG and ACKTR (Note: DDPG and ACKTR are Actor-Critic class algorithm)</d-footnote>  

Maybe I’m naive, but when I read on an algorithm, I usually get the
impression that it outperforms all benchmark across the board.
Nevertheless, their result showed that:

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    <b>no single algorithm can perform consistently better in all
    environments.</b>
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


That sounds like an important detail to me. If putting an algorithm in a
given environment has such a huge impact on its performance, would it
not be wise to take it into consideration before planning the
implementation as it could clearly affect the outcome. Otherwise it’s
like expecting a Formula One to perform well in the desert during a
Paris-Dakar race on the basis that it holds a top speed record of 400
km/h. They concluded that

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    In continuous control tasks, often the environments have random
    stochasticity, shortened trajectories, or different dynamic properties
    ... as a result of these differences, algorithm performance can vary
    across environments ...
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


<figure id="comparing-policy-gradients-across-various-environments-henderson-2018" class="l-body-outset">
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/environment_impact_on_performance_DRLThatMatter_1de2.png' | relative_url }}" />
        </div>
    </div>
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/environment_impact_on_performance_DRLThatMatter_2de2.png' | relative_url }}" />
        </div>
    </div>
    <figcaption>
    <strong>Comparing Policy Gradients across various environments.</strong><br>
    <b>Source:</b> Figure 26 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite>
    </figcaption>
</figure>


**Regarding design & architecture:** They have also shown how policy gradient class algorithms can be
affected by choices of network structures, activation functions and
reward scale. As an example:

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    Figure 2 shows how significantly performance can be affected by simple changes to the policy or value network
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


<figure id="significance-of-policy-network-structure-and-activation-henderson-2018" class="l-page" >
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/policyNetwork_structure_big_drlThatMatter.png' | relative_url }}" />
        </div>
    </div>
    <figcaption>
    <strong>Significance of Policy Network Structure and Activation Functions PPO
(left), TRPO (middle) and DDPG (right).</strong><br>
    <b>Source:</b> Figure 2 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite>
    </figcaption>
</figure>

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    Our results show that the value network structure can have a significant effect on the performance of ACKTR algorithms.
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


<figure id="acktr-value-network-structure-henderson-2018" class="l-body-outset" >
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/ACKTR_architecture_drlThatMatter.png' | relative_url }}" />
        </div>
    </div>
    <figcaption>
    <strong>ACKTR Value Network Structure.</strong><br>
    <b>Source:</b> Figure 11 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite>
    </figcaption>
</figure>

They make the following conclusion regarding network structure and
activation function:

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    The effects are not consistent across algorithms or environments.
    This inconsistency <b>demonstrates how interconnected network
    architecture is to algorithm methodology</b>.
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>

It’s not a surprise that hyperparameter has an effect on the
performance. To me, the key takeaway is that policy gradient class
algorithm can be highly sensitive to small change, enough to make it fly
or fall if not considered properly.

**Ok it does matter! What now?** Like I said earlier, the goal of their paper was to highlight problems
regarding reproducibility in DRL publication. As a by-product, they
clearly establish that DRL algorithm can be very sensitive to change
like environment choice or network architecture. I think it also showed
that the applied part of DRL, whether it’s about implementation details
or design & architectural decisions, play a key role and is detrimental
to a DRL project success just as much as the mathematic and the theory
on top of which they are built. By the way, I really liked that part of
their closing thought:

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    Maybe new methods should be answering the question: <b>in what settings would this work be useful?</b>
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


<p id="subsec-which-implementation-details-are-impactful-or-critical"></p>

### <i class="fas fa-th"></i> Which implementation details are impactful or critical?

We have established 
<a href="#subsec-regarding-implementation-details">previously</a>
that implementation details could be impactful with regards to the
performance of an algorithm eg.: how fast it converges to an optimal solution or
 if it converges at all.  

Could it be impactful else where? Like wall clock speed for example or
memory management. Of course it does, any book on data structure or
algorithm analysis will say so. On the other end, there is this famous
say in the computer science community: <i>“early optimization is a sin”</i>.  

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
$$\widehat{V}_\phi^\pi(\mathbf{s}) \, \approx \, V^\pi(\mathbf{s})$$ 
in a **batch Actor-Critic** algorithm with a **bootstraps target** design.
I won't dive in the detail here, but keep in mind that in the end, we just need $$\widehat{V}_\phi^\pi(\mathbf{s})$$ to compute the **critic bootstrap target** and
the **advantage** at the update stage. 
Knowing that, what’s the best place to compute $$\widehat{V}_\phi^\pi(\mathbf{s})$$? 
Is it at *timestep level* close to the *collect process* or at *batch level* close to the *update process*? 
 
<p class="text-center lead" style="padding-top: 0em; padding-bottom: 0em">Does it even matter?</p>

<div style="padding-top: 1em; padding-bottom: 1.5em;" class="l-body-outset">
    <div class="card border-dark mb-3">
        <div class="card-header" style="font-size: inherit; color: white; background-color: rgb(14, 14, 26)">
            Quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
        </div>
        <div class="card-body text-dark">
            <div class="container card-text" style="font-size: unset;">
                <div class="row">
                    <div class="col">
                        The Actor-Critic <b>objective</b> goes like this
                        <d-math block="" class="card-d-math-display">
                            \nabla_\theta J(\theta) \, \approx \, \frac{1}{N} \sum_{i = 1}^{N} \sum_{t=1}^\mathsf{T} \nabla_\theta \, \log  \, \pi_\theta (\mathbf{a}_{i, t} | \mathbf{s}_{i, t} ) \widehat{A}^\pi(\mathbf{s}_{i, t}, \mathbf{a}_{i, t})
                        </d-math>
                        with the <b>advantage</b>
                        <d-math block="" class="card-d-math-display">
                            \widehat{A}^\pi(\mathbf{s}_{i, t}, \mathbf{a}_{i, t}) \, = \, r(\mathbf{s}_{i,t}, \mathbf{a}_{i,t}) \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{i,t+1}) \, - \, \widehat{V}_\phi^\pi(\mathbf{s}_{i,t})
                        </d-math>
                        Training the <b>critic</b> <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math> is a supervised regression problem that we can define like this:
                        <d-math block="" class="card-d-math-display">
                            \mathcal{D}^{\text{train}} \, = \, \Big\{ \, \Big( \ \mathbf{x}_i \, , \, \mathbf{y}_i \, ) \,  \Big)  \, \Big\} \\[-1em]
                        </d-math>
                        with 
                        <ul>
                            <li>
                            the <b>input</b> <d-math>\, \mathbf{x}_i \, := \, \mathbf{s}_{i, t} \,</d-math> with the state <d-math>\mathbf{s}</d-math> at timestep <d-math>t</d-math> of the <d-math>i^e</d-math> sample 
                            </li>
                            <li>the <b>bootstrap target</b>
                            <d-math>
                            \, \mathbf{y}_i \, := \, r(\mathbf{s}_{i, t}, \mathbf{a}_{i, t}) + \widehat{V}_\phi^\pi(\mathbf{s}_{i, t+1}) \, \approx \, V^\pi(\mathbf{s}_t) \\[0em]
                            </d-math>
                            </li>
                        </ul>
                        <d-math block="" class="card-d-math-display">
                            L\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{i, t}) \, \middle| \, \mathbf{y}_i  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{i, t}) \, - \, \left( \, r(\mathbf{s}_{i, t}, \mathbf{a}_{i, t}) \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{i, \, t+1}) \, \right)  \, \right\|^2 
                        </d-math>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


**Casse 1 - _timestep level_:** Choosing to do this operation at each timestep instead of doing it over
a batch might make no difference on a [*CartPole-v1* Gym
environment](https://github.com/openai/gym/blob/master/gym/envs/classic_control/cartpole.py)
since you only need to store in RAM at each timestep a 4-digit
observation and that trajectory length is capped at $200$ steps. So you
end up with relatively small batches size. Even if that design choice
completely fails to leverage the power of matrix computation framework,
considering the setting, computing $$\widehat{V}_\phi^\pi$$
anywhere would be relatively fast anyway.

**Casse 2 - _batch level_:** On the other hand, using the same design in an environment with very
high dimensional observation space like the [*PySc2
Starcraft*](https://github.com/deepmind/pysc2) environment <d-footnote>PySc2 have multiple observation output. As an example, minimap observation is an RGB representation of 7 feature layers with resolution ranging from 32 − 2562<sup>2</sup> where most pixel value give important information on the game state.</d-footnote>, will make
that same operation slower, potentially to a point where it could become
a bottleneck that will considerably impair experimentation speed. So
maybe a design where you compute $$\widehat{V}_\phi^\pi(\mathbf{s})$$
at *batch level* would make more sense in that setting.

**Casse 3 - _trajectory level_:** Now let’s consider trajectory length. As an example, a 30-minute *PySc2
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

What I want to show with this example is that

<p class="text-center myLead">
    some implementation details might have no effect in some settings<br> 
    but be a game changer in others.  
</p>

This means that it’s a **setting sensitive** issue and the real question I need to ask myself is:

<p class="text-center myLead">
    How do I recognize <b>when</b> an implementation detail<br> becomes impactful or critical?   
</p>



### <i class="fas fa-th"></i> Asking the right questions

From my understanding, there is no cookbook defining the recipe of a
*one best* design & architecture that will outperform all the other ones
in every setting, maybe there was at one point, but not anymore. 
 
As a matter of fact, it was well establish since de 90's that **Temporal-Diference** RL method were superior to 
**Monte-Carlo** RL method. Never the less, it was recently highlithed by Amiranashvili et al. 
(2018)<d-cite key="Amiranashvili2018"></d-cite> 
that **RL theorical and empirical result might not systematicaly hold up in the context of DRL**. 
They point out that modern problem tackled in DRL research deal with a much more rich and complex state space than those
use for RL experiment at the time were those result where found. 
As such, those new empirical result show that, in the context of DRL, MC methods might be back being a top contender in 
certain setting. Those result contrast with how MC methods where performing in the RL setting where they were left in the dust
by TD methods.

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    We find that while TD is at an advantage in tasks with simple perception, long planning horizons, or terminal 
    rewards, MC training is more robust to noisy rewards, effective for training perception systems from raw sensory 
    inputs, and surprisingly successful in dealing with sparse and delayed rewards. 
    <footer class="blockquote-footer text-right">  <cite title="Source Title">Amiranashvili et al.</cite></footer>
</blockquote>

We also saw earlier that there was no clear winner in policy gradient class algorithms <d-footnote>Refer to the 
subsection: <a href="#subsec-regarding-the-setting">Regarding the setting</a></d-footnote>. 
So we can safely say that performance of DRL algorithm can be significantly affected by the setting in wich they are trained.
It’s also clear now that for a given type of algorithm and with respect to certain settings, implementation details, design decisions and
architectural decisions can have a huge impact<d-footnote>Refer to the subsection: <a href="#subsec-regarding-implementation-details" data-reference-type="ref">Regarding implementation details</a></d-footnote> so that aspect deserves a lot of attention.  

So we are now left with those unanswered questions:

<p class="text-center myLead">
    <b>Why</b> choose a design & architecture over another?<br>  
    How do I recognize <b>when</b> an implementation detail becomes impactful<br> or critical?
</p>

I don’t think there is a single answer to those questions and experience
at implementing DRL algorithm might probably play an important role, but
it’s also clear that none of those questions can be answered without
doing a proper assessment of the setting. I think that design &
architectural decisions **need to be well thought out, planned at an
early development stage and based on multiple considerations** like the
following:

<ul class="fa-ul">
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>output requirement (eg. robustness, generalization performance, learning speed, ...)</li>
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>environment to tackle (eg. action space dimensionality, observation type ...)</li>
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>resource available to do it (eg. computation power, data storage ...)</li>
</ul>

One thing for sure, those decisions cannot be a “flavour of the
month”-based decision.  

I will argue that **learning to recognize when** implementation details
become important or critical **is a valuable skill that needs to be
developed**.  

<h1 class="mainH1">Closing thoughts</h1>

In retrospect, I have the feeling that the many practical aspects of DRL
are maybe sometimes undervalued in the literature at the moment but my
observation led me to conclude that it probably plays a greater role in
the success or failure of a DRL project and it’s a must study.

