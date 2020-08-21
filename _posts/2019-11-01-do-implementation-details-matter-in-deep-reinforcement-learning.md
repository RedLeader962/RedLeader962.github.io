---
#@formatter:off

published: true
layout: distill
title: Do implementation details matter in Deep Reinforcement Learning?
description: 'A reflection on design, architecture and implementation of DRL algorithms from a software engineering perspective applied to research.
                Spoiler alert … it does matter!'

authors:
  - name: Luc Coupal
    url: "https://redleader962.github.io"
    affiliations:
      name: Université Laval
      url: https://www.ulaval.ca

bibliography: do-implementation-details-matter-in-deep-reinforcement-learning.bib

_styles: >
    d-byline {
        padding: 1.5rem 0;
        padding-bottom: 0em;
        margin-bottom: 0em;
        min-height: 1.8em;
    }
    d-article {
        border-top: 0px solid rgba(0, 0, 0, 0.1);
        padding-top: 0rem;
        margin-top: 0rem;
    }
    
#@formatter:on
---

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
        <div class="col-md-3">
            Prof. 
                <a href="https://www.fsg.ulaval.ca/departements/professeurs/brahim-chaib-draa-166/" target="blank">
                  <span class="supervisorThe"> Brahim Chaib-draa </span>
                </a> 
        </div>
        <div class="col-md-9">
            Directeur du programme de baccalauréat en génie logiciel à l'<a href="https://www.ulaval.ca" target="blank">
            Université Laval
            </a> 
        </div>
    </div>
</div>

<div class="container supervisorDbyline">
    <div class="row">
        <div class="col">
            <p class="supervisorDbylineTitle"> Acknowledgments </p> 
        </div>
        <!-- 
            Force next columns to break to new line 
        -->
        <div class="w-100"></div>
    </div>
        A big thank you to my angel <span class="acknowledgments"> Karen Cadet </span> for her support and precious insight on the english language. 
</div>

<hr class="supervisorDbylineHorizontalRule">


A quest for answers
===================

While I was finishing an essay on *Deep Reinforcement Learning Advantage
Actor-Critic* method, a part of me felt that some important questions
 linked to the applied part were  unanswered or disregarded.  

<!-- 
Those questions were linked to design & architectural aspects of Deep
Reinforcement Learning from a software engineering perspective applied
to research.
-->

<p class="text-center myLead" >
Which design & architecture should I choose?<br>
Which implementation details are impactful or critical?<br>  
Does it even make a difference?<br>
</p>

This essay is my journey through that reflection process and the lessons
I have learned on the importance of design decisions, architectural
decisions and implementation details in Deep Reinforcement Learning
(specificaly regarding the class of policy gradient algorithms).

<i class="fas fa-th-large"></i> Clarification on ambiguous terminology
--------------------------------------

<div class="definition">
    <dl class="row">
      <dt class="col-md-3">The setting</dt> 
      <dd class="col-md-9 ml-auto">
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
      <dd class="col-md-9 ml-auto">
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
      <dd class="col-md-9 ml-auto">
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
        In the ML field, it often refers to choices made regarding improvement
        techniques, hyperparameters, algorithm type, math computation…
      </dd>
      <dt class="col-md-3">Implementation details</dt> 
      <dd class="col-md-9 ml-auto">
        This is a term often a source of confusion in software engineering 
        <d-footnote>I recommend this very good post on the topic of <i>Implementation details</i> by Vladimir Khorikov: <a href="https://enterprisecraftsmanship.com/posts/what-is-implementation-detail/" target="blank">What is an implementation detail?</a></d-footnote>. 
        The
        consensus is the following:
        <!-- 
        <p class="text-center" style="padding-top: 0.75em;">
        everything that should not leak outside
        a public API is an implementation detail.
        </p>
        -->
        <blockquote class="blockquote text-justify">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            everything that should not leak outside a public API is an implementation detail.
        </blockquote>
        <p>So it’s closely linked to the definition and specification of an API but it’s not just code. 
        <b>The meaning feels blurier in the machine learning
        field as it often gives the impression that it’s usage implicitly means:</b> 
        <blockquote class="blockquote text-justify">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            everything that is not part of the math formula or the high-level algorithm is an implementation detail.
        </blockquote>
        and also that:
        <blockquote class="blockquote text-justify">
            <div class="">
            <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
            <span style="font-weight: bolder">those are just</span> implementation details.
            </div>
        </blockquote>
        </p>
      </dd>
    </dl>
</div>
  

<i class="fas fa-th-large"></i> Going down the rabbit hole
--------------------------

Making sense of *Actor-Critic* algorithm scheme definitively ticked my curiosity. 
Studying the theoretical part was a relatively straight forward process as there is a lot of literature covering the 
core theory with well-detailed analysis & explanation. On the other hand, studying the applied part has been puzzling. 
Here's why.

I took the habit when I study a new algorithm-related subject, to first
implement it by myself without any code example. After I’ve done the
work, I look at other published code examples or different framework
codebases. This way I get an intimate sense of what’s going on under the
hood and it makes me appreciate other solutions to problems I have
encountered that often are very clever. It also helps me to highlight
details I was not understanding or for which I was not giving enough
attention. Proceeding this way takes more time, it’s often a reality
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
at personal touch taken lightly or **was I looking at well considered,
deliberate, impactful design & architectural decision**?  

While going down that rabbit hole, the path became even blurrier when I
began to realize that some design implementation related to theory and
others related to speed optimization were not having just plus value,
they could have a tradeoff on certain settings.  

Still, a part of me was seeking for a clear choice like some kind of
*best practice*, *design patern* or *most effective architectural
pattern*. Which led me to those next questions:

<p class="text-center myLead">
    Which design & architecture should I choose?<br>  
    Which implementation details are impactful or critical?<br>  
    Does it even make a difference?<br>  
</p>

<div id="sec-does-it-even-matter"> </div>

### <i class="fas fa-th"></i> Does it even make a difference?

Apparently, it does a great deal as Henderson, P. et al. demonstrated in
their paper *Deep reinforcement learning that matters* <d-cite key="Henderson2018"></d-cite>  (from McGill’s
university and Microsoft Malumba Montreal). Their goal was to highlight
many recurring problems regarding reproducibility in DRL publication.
Even though my concerns were not on reproducibility, I was astonished by
how much the questions and doubts I was experiencing at that time were
related to some of their findings.

<div id="subsec-regarding-implementation-details"> </div>

#### Regarding implementation details: 
One disturbing result they got was on one experiment they conducted on
the performance of a given algorithm across different code base. Their
goal was “to draw attention to the variance due to implementation
details across algorithms”. As an example they compared 3 high quality
implementations of TRPO: OpenAI Baselines<d-cite key="Plappert2017"></d-cite> , OpenAI rllab<d-cite key="Duan2016"></d-cite>  and the
original TRPO<d-cite key="Schulman2015a"></d-cite> codebase. 

The way I see it, those are all codebase linked to publish papers so they
were all implemented by experts and must have been extensively peer
reviewed. So I would assume that given the same settings (same
hyperparameters, same environment) they would all have similar
performances. As you can see, that assumption is wrong.


<figure id="trpo-codebase-comparison-henderson-2018" class="l-body-outset">
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/trpo_codebase_result2_drlthatMatter.png' | relative_url }}" />
        </div>
    </div>
    <figcaption>
    TRPO codebase comparison using a default set of hyperparameters.<br>
    <span class="captionSource"><b>Source:</b> Figure 35 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite></span>
    </figcaption>
</figure>


They also did the same experiment with DDPG and got similar results and this is what they found:

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    <b>... implementation differences which are often not reflected in
    publications can have dramatic impacts on performance</b> ... This
    [result] demonstrates the necessity that implementation details be
    enumerated, codebases packaged with publications ...
    <footer class="blockquote-footer text-right"> <cite title="Source Title">Henderson et al.</cite></footer>
</blockquote>


This does not answer my question about “Which implementation details are
impactful or critical?” however <span style="font-weight: bold;">it certainly tells me that SOME
implementation details ARE impactful or critical</span> and this is an aspect
that deserves a lot more attention.

<div id="subsec-regarding-the-setting"></div>

#### Regarding the setting:
 In another experiment, they examined the impact an environment choice
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


To me, that sounds like an important detail. If putting an algorithm in a
given environment has such a huge impact on its performance, would it
not be wise to take it into consideration before planning the
implementation as it could clearly affect the outcome. <span style="font-weight: bolder; ">Otherwise it’s
like expecting a Formula One to perform well in the desert during a
Paris-Dakar race on the basis that it holds a top speed record of 400
km/h</span>. They concluded that:

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
    Comparing Policy Gradients across various environments.<br>
    <span class="captionSource"><b>Source:</b> Figure 26 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite></span>
    </figcaption>
</figure>


#### Regarding design & architecture: 
They have also shown how policy gradient class algorithms can be
affected by choices of network structures, activation functions and
reward scale. Here are a few examples:

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
    Significance of Policy Network Structure and Activation Functions PPO
(left), TRPO (middle) and DDPG (right).<br>
    <span class="captionSource"><b>Source:</b> Figure 2 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite></span>
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
    ACKTR Value Network Structure.<br>
    <span class="captionSource"><b>Source:</b> Figure 11 from <i>Deep reinforcement learning that matters</i> <d-cite key="Henderson2018"></d-cite></span>
    </figcaption>
</figure>

They make the following conclusions regarding network structure and
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
algorithm can be highly sensitive to small changes, enough to make it fall
or fly if not considered properly.

#### Ok it does matter! ... What now?
Like I said earlier, the goal of their paper was to highlight problems
regarding reproducibility in DRL publication. As a by-product, they
clearly establish that DRL algorithm can be very sensitive to change
like environment choice or network architecture. I think it also showed
that the applied part of DRL, whether it’s about implementation details
or design & architectural decisions, play a key role and is detrimental
to a DRL project success just as much as the mathematic and the theory
on top of which they are built. By the way, I really liked that part of
their closing thought, which reads as follows:

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
memory management. Of course it could, any book on data structure or
algorithm analysis support that claim. On the other end, there is this famous
say in the computer science community :
<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    Early optimization is a sin.
</blockquote>

Does it apply to the ML/RL field? Anyone that has been waiting for an
experiment to conclude after a few strikes will say that waiting for
result is playing with their mind and that speed matters **a lot** to them at the moment. Aside from mental health, the reality is that **the
faster you can iterate between experiments, the faster you get feedback
from your decisions, the faster you can make adjustments towards your
goals.** So optimizing for speed sooner than later is impactful indeed
in ML/RL. It’s all about choosing what is a good optimization investment. 



<!---- Collapsable card ----------------------------------------------------------------------------------------------->
<div class="collapsable-card" style="padding-top: 1em; padding-bottom: 3em; margin-top: 0em">
    <div class="card-shadow">
        <button class="btn btn-lg btn-block close-icon shadow-none" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="true" aria-controls="collapseExample">
        A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
        </button>
        <div id="quick-refresher" class="collapse show">
        <!-- 
            <button class="btn btn-lg btn-block close-icon collapsed shadow-none" style="margin-bottom: -0.3em;" type="button" data-toggle="collapse" data-target="#quick-refresher" aria-expanded="true" aria-controls="collapseExample">
            A quick refresher on <b>Advantage Actor-Critic</b> method with <b>bootstrap target</b>
            </button>
            <div id="quick-refresher" class="collapse">
        -->
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
                        \:\: \widehat{A}^\pi\left(\mathbf{s}_{t}, r_{t}^{_{(i)}}, \mathbf{s}_{t+1}^{_{(i)}}\right) \:\: = \:\: r_{t+1}^{_{(i)}} \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) \ - \ \widehat{V}_\phi^\pi(\mathbf{s}_{t})
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
                             <!-- 
                             <br>
                             <span class="comment">Note: <d-math>\mathbf{s}_t</d-math> is the current state at timestep <d-math>t</d-math></span>
                             -->
                            </li>
                            <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>
                            and the <b>bootstrap target</b>
                                <d-math>
                                \:\: y^{_{(i)}} \: := \: r_{t+1}^{_{(i)}} \, + \, \widehat{V}_\phi^\pi(\mathbf{s}_{t+1}^{_{(i)}}) 
                                <!-- 
                                \: \approx \: V^\pi(\mathbf{s}_t)
                                --> 
                                </d-math>
                                <!-- 
                                <br>
                                <span class="comment">Note: <d-math>r_{t+1}^{_{(i)}}</d-math>  and <d-math>\mathbf{s}_{t+1}^{_{(i)}}</d-math> are both sampled from the environnement by trying the policy <d-math>\widehat{\pi}_\theta</d-math> at the current state <d-math>\mathbf{s}_t</d-math> and seeing where it land. </span>
                                -->
                            </li>
                        </ul>
                        and the loss function
                            <!-- 
                            <div class="center">
                            -->
                                <d-math block class="card-d-math-display" style="margin-top: 0em; margin-bottom: -1em;">
                                    \mathcal{L}\left( \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}) \, \middle| \, y^{_{(i)}}  \, \right) \, = \, \frac{1}{2} \sum_{i = 1}^{N} \left\| \, \widehat{V}_\phi^\pi(\mathbf{s}_{t}) \, - \, y^{_{(i)}}  \, \right\|^2 
                                </d-math>
                            <!-- 
                            </div>
                            -->
                    </p>
                </div>
            </div>
        <!-- 
        -->
        </div>
    </div>
</div>
<!--------------------------------------------------------------------------------------- Collapsable card ---(end)---->
 

So we now need to look for 2 types of implementation details: 
 
<ul class="fa-ul">
    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>those related to algorithm performance</li>
    <li><span class="fa-li"> <i class="fas fa-caret-right"></i> </span>and those related to wall clock speed.</li>
</ul>
 
That’s when things get trickier. Take for example the *value estimate* computation of the **critic** <d-math>\widehat{V}_\phi^\pi(\mathbf{s}) \, \approx \, V^\pi(\mathbf{s})</d-math>in a **batch Actor-Critic** algorithm with a **bootstraps target** design.
I won't dive in the details here, but keep in mind that in the end, we just need <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math> to compute the **critic bootstrap target** and
the **advantage** at the update stage. 
Knowing that, what’s the best place to compute <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math>? 
Is it at *timestep level* close to the *collect process* or at *batch level* close to the *update process*? 
 
<p class="text-center myLead" style="padding-top: 0em; padding-bottom: 0em">Does it even make a difference?</p>


**Casse 1 - _timestep level_ :** Choosing to do this operation at each timestep instead of doing it over
a batch might make no difference on a [*CartPole-v1* Gym
environment](https://github.com/openai/gym/blob/master/gym/envs/classic_control/cartpole.py)
since you only need to store in RAM at each timestep a 4-digit
observation and that trajectory length is capped at $200$ steps so you
end up with relatively small batches size. Even if that design choice
completely fails to leverage the power of matrix computation framework,
considering the setting, computing <d-math>\widehat{V}_\phi^\pi</d-math>
anywhere would be relatively fast anyway.

**Casse 2 - _batch level_ :** On the other hand, using the same design in an environment with very
high dimensional observation space like the [*PySc2
Starcraft*](https://github.com/deepmind/pysc2) environment <d-footnote>PySc2 have multiple observation output. As an example, minimap observation is an RGB representation of 7 feature layers with resolution ranging from 32 − 2562<sup>2</sup> where most pixel value give important information on the game state.</d-footnote>, will make
that same operation slower, potentially to a point where it could become
a bottleneck that will considerably impair experimentation speed. So
maybe a design where you compute <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math>
at *batch level* would make more sense in that setting.

**Casse 3 - _trajectory level_ :** Now let’s consider trajectory length. As an example, a 30-minute *PySc2
Starcraft* game is  <d-math>\sim 40, 000</d-math> steps long. In order to compute <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math> at batch level, you need to store
in RAM memory each timestep observation for the full batch, so given the observation space size and the range of trajectory length, in that
setting you could end up with RAM issues. If you have access to powerful hardware like they have in Google Deepmind laboratory it won’t really be
a problem, but if you have a humble consumer market computer, it will matter. So maybe in that case, keeping only observations from the
current trajectory and computing <d-math>\widehat{V}_\phi^\pi(\mathbf{s})</d-math>
at trajectory end would be a better design choice.  

What I want to show with this example is that **some implementation details might have no effect in some settings but can be a game changer in others.**  

This means that it’s a **setting sensitive** issue and the real question we need to ask ourselves is:

<p class="text-center myLead">
    How do we recognize <b>when</b> an implementation detail<br> becomes impactful or critical?   
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
use for RL experiment at the time were those results where found. 
As such, those new empirical results show that, in the context of DRL, MC methods might be back being a top contender in 
certain settings. Those results contrast with how MC methods where performing in the RL setting where they were left in the dust
by TD methods.

<blockquote class="blockquote text-justify">
    <i class="fas fa-quote-left fa-1x fa-pull-left"></i>
    We find that while TD is at an advantage in tasks with simple perception, long planning horizons, or terminal 
    rewards, MC training is more robust to noisy rewards, effective for training perception systems from raw sensory 
    inputs, and surprisingly successful in dealing with sparse and delayed rewards. 
    <footer class="blockquote-footer text-right">  <cite title="Source Title">Amiranashvili et al.</cite></footer>
</blockquote>

We also saw earlier that there was no clear winner amongst policy gradient class algorithms <d-footnote>Refer to the 
subsection: <a href="#subsec-regarding-the-setting">Regarding the setting</a></d-footnote>. 
So we can safely say that performance of DRL algorithm can be significantly affected by the setting in wich they are trained.
It’s also clear now that for a given type of algorithm and with respect to certain settings, implementation details, design decisions and
architectural decisions can have a huge impact<d-footnote>Refer to the subsection: <a href="#subsec-regarding-implementation-details" data-reference-type="ref">Regarding implementation details</a></d-footnote> so that aspect deserves a lot of attention.  

We are now left with the following unanswered questions:

<p class="text-center myLead">
    <b>Why</b> choose a design & architecture over another?<br>  
    How do I recognize <b>when</b> an implementation detail becomes impactful<br> or critical?
</p>

I don’t think there is a single answer to those questions and gaining experience
at implementing DRL algorithm might probably help, but
it’s also clear that none of those questions can be answered without
doing a proper assessment of the settings. I think that design &
architectural decisions **need to be well thought out, planned prior to development and based on multiple considerations** like the
following:

<ul class="fa-ul">
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>output requirement (eg. robustness, generalization performance, learning speed, ...)</li>
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>environment to tackle (eg. action space dimensionality, observation type ...)</li>
    <li><span class="fa-li"><i class="fas fa-caret-right"></i></span>resource available to do it (eg. computation power, data storage ...)</li>
</ul>

<p class="text-center myLead">
One thing for sure, those decisions <b>cannot be</b> <br>
a <b>“flavour of the month”</b>-based decision.  
</p>

I will argue that **learning to recognize when** implementation details
becomes important or critical **is a valuable skill that needs to be
developed**.  

<h1 class="mainH1">Closing thoughts</h1>

In retrospect, I have the feeling that the many practical aspects of DRL
are maybe sometimes undervalued in the literature at the moment but my
observation led me to conclude that it probably plays a greater role in
the success or failure of a DRL project and it’s a must study.


---
##### Cite as:

```bibtex
@article{lcoupal2019implementation,
  author   = {Coupal, Luc},
  journal  = {redleader962.github.io/blog},
  title    = {% raw  %}{{Do implementation details matter in Deep Reinforcement Learning?}}{% endraw %},
  year     = {2019},
  url      = {https://redleader962.github.io/blog/2019/do-implementation-details-matter-in-deep-reinforcement-learning/},
  keywords = {Deep reinforcement learning,Reinforcement learning,policy gradient methods,Software engineering}
}
```