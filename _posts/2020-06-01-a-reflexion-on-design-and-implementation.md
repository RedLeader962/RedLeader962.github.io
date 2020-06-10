---
published: false
layout: distill
title: A reflection on design, architecture and implementation details in Deep Reinforcement Learning
description: My journey through that reflection process and the lessons I have learned on the importance of design decisions, architectural decisions and implementation details in Deep Reinforcement Learning.

authors:
  - name: Luc Coupal
    url: "https://redleader962.github.io"
    affiliations:
      name: Université Laval
      url: https://www.ulaval.ca

bibliography: ProjetDeLecture2019.bib

_styles: >
    .supervisorDbyline {
        contain: style;
        font-size: 0.8rem;
        line-height: 0.75em;
        min-height: 0.75em;
        padding: 0rem 0;
        border-down: 1px solid rgba(0, 0, 0, 0.1);
        margin: 0rem 0;
    }
    .supervisorDbyline h3 {
        font-size: 0.6rem;
        font-weight: 400;
        color: rgba(0, 0, 0, 0.5);
        text-transform: uppercase;
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
    .definition h5 {
        padding-top: 1em;
        padding-bottom: 0em; 
        margin-bottom: 0em;
        font-size: 0.8em;
        font-weight: bold;
        text-transform: none;
    }
    .definition dt {
        padding-top: 1em;
    }
    .definition dd {
        padding-top: 1em;
    }
---
<div style=""></div>

<div class="container supervisorDbyline">
    <div class="row">
        <div class="col">
            <h3> Supervisor </h3> 
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

---


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

Clarification on ambiguous terminology
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
        <blockquote class="blockquote text-justify" style="margin: 0em">
            <div class="mb-0" style="font-size: smaller;">
            “ refers to the fundamental structures of a software system and the
            discipline of creating such structures and systems. Each structure
            comprises software elements, relations among them, and properties of
            both elements and relations.”</div>
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
        <blockquote class="blockquote text-justify" style="margin: 0em">
            <div class="mb-0" style="font-size: smaller;">
            “ the process by which an agent creates a specification of a software
        artifact, <b>intended to accomplish goals</b>, using a set of primitive
        components and <b>subject to constraints</b>. ”</div>
            <footer class="blockquote-footer text-right"> <cite title="Source Title">Ralf & Wand</cite></footer>
        </blockquote>
        In the ML field, it often refer to choices made regarding improvement
        technique, hyperparameter, algorithm type, math computation…
      </dd>
      <dt class="col-md-3">Implementation details</dt> 
      <dd class="col-sm-9 ml-auto">
        This is a term often a source of confusion in software engineering . The
        consensus is the following*:
        <p class="text-center" style="padding-top: 0.75em">
        <b>everything that should not leak outside</b>
        <b>a public API</b> is an implementation detail.
        </p>
        <p>So it’s closely linked to the definition & specification of an API but it’s not just code. <b>The meaning feel blurier in the machine learning
        field</b> as I often have the impression that it’s usage implicitly mean “everything that is not part of the math formula or the high-level
        algorithm is an implementation detail” and also that</p>
        <p class="text-center" style="font-size: larger; font-weight: bolder;">
        “<span style="font-weight: bold">it’s just</span> implementation details”.
        </p>
      </dd>
    </dl>
</div>
  
---

Going down the rabbit hole
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
various *Actor-Critic* class algorithm .  

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
pattern*.  
Which led me to those next questions:

**Which design & architecture** should I choose?  
**Which implementation details** are impactful or critical?  
**Does it even matter?**  

### Does it even matter?

Apparently, it does a great deal as Henderson, P. et al. demonstrated in
their paper *Deep reinforcement learning that matters*  (from McGill’s
university and Microsoft Malumba Montreal). Their goal was to highlight
many recurring problems regarding reproducibility in DRL publication.
Even though my concerns were not on reproducibility, I was astonished by
how much the questions and doubts I was experiencing at that time were
related to some of their findings.

#### Regarding implementation details:

One disturbing result they got was on one experiment they conducted on
the performance of a given algorithm across different code base. Their
goal was “to draw attention to the variance due to implementation
details across algorithms”. As an example they compared 3 high quality
implementations of TRPO: OpenAI Baselines , OpenAI rllab  and the
original TRPO codebase .  
The way I see it, those are all codebase linked to publish paper so they
were all implemented by experts and they must have been extensively peer
reviewed. So I would assume that given the same setting (same
hyperparameters, same environment) they would all have similar
performances. As you can see, that assumption was wrong.


<figure id="basic-structure" class="l-page">
    <div class="row">
        <div class="col">
            <img src="{{ '/assets/img/post_a_reflexion_on_design_and_implementation/trpo_codebase_result2_drlthatMatter.png' | relative_url }}" />
        </div>
    </div>
</figure>

<figure id="basic-structure" class="l-page-outset">
    <div class="row">
        <div class="col two">
            <img src="{{ site.baseurl }}/assets/img/post_a_reflexion_on_design_and_implementation/trpo_codebase_result2_drlthatMatter.png" />  
        </div>
    </div>
</figure>

TRPO codebase comparison using a default set of hyperparameters.  
Source: Figure 35 from *Deep reinforcement learning that matters*  <span
id="a01575a08d494e02a8dbc64c3af85484"
label="a01575a08d494e02a8dbc64c3af85484">\[a01575a08d494e02a8dbc64c3af85484\]</span>

They also did the same experiment with DDPG and got similar results.
They found that

> “ **…implementation differences which are often not reflected in
> publications can have dramatic impacts on performance**   …  This
> (result) demonstrates the necessity that implementation details be
> enumerated, codebases packaged with publications   … ”

This does not answer my question about “Which implementation detail are
impactful or critical?” but it certainly tells me **that some
implementation details are impactful or critical** and this is an aspect
that deserves a lot more attention.

#### Regarding the setting:

In another experiment, they examine the impact an environment choice
could have on policy gradient family algorithm performances. They made a
comparison using 4 different environments with 4 different algorithms.  

Maybe I’m naive, but when I read on an algorithm, I usually get the
impression that it outperforms all benchmark across the board.
Nevertheless, their result showed that:

> “…**no single algorithm can perform consistently better in all
> environments**.”

That sounds like an important detail to me. If putting an algorithm in a
given environment has such a huge impact on its performance, would it
not be wise to take it into consideration before planning the
implementation as it could clearly affect the outcome. Otherwise it’s
like expecting a Formula One to perform well in the desert during a
Paris-Dakar race on the basis that it holds a top speed record of 400
km/h.  
They concluded that

> “ In continuous control tasks, often the environments have random
> stochasticity, shortened trajectories, or different dynamic properties
> …as a result of these differences, algorithm performance can vary
> across environments … ”

<img class="img-fluid rounded z-depth-1" src="{{ site.baseurl }}/assets/img/post_a_reflexion_on_design_and_implementation/environment_impact_on_performance_DRLThatMatter_1de2.png" alt="image" style="width:17cm" />  
<img class="img-fluid rounded z-depth-1" src="{{ site.baseurl }}/assets/img/post_a_reflexion_on_design_and_implementation/environment_impact_on_performance_DRLThatMatter_2de2.png" alt="image" style="width:17cm" />  
Comparing Policy Gradients across various environments.  
Source: Figure 26 from *Deep reinforcement learning that matters*  <span
id="fb3a3962240c48ebaeef4ea6d5737bf3"
label="fb3a3962240c48ebaeef4ea6d5737bf3">\[fb3a3962240c48ebaeef4ea6d5737bf3\]</span>

#### Regarding design & architecture:

They have also shown how policy gradient class algorithms can be
affected by choices of network structures, activation functions and
reward scale. As an example:

> “ Figure 2 shows how significantly performance can be affected by
> simple changes to the policy or value network ”

<img class="img-fluid rounded z-depth-1" src="{{ site.baseurl }}/assets/img/post_a_reflexion_on_design_and_implementation/policyNetwork_structure_big_drlThatMatter.png" alt="image" style="width:16.5cm" />  
Significance of Policy Network Structure and Activation Functions PPO
(left), TRPO (middle) and DDPG (right).  
Source: Figure 2 from *Deep reinforcement learning that matters*  <span
id="c34d30526bf1481babaf6c88e1c1ad54"
label="c34d30526bf1481babaf6c88e1c1ad54">\[c34d30526bf1481babaf6c88e1c1ad54\]</span>

> “ Our results show that the value network structure can have a
> significant effect on the performance of ACKTR algorithms. ”

<img class="img-fluid rounded z-depth-1" src="{{ site.baseurl }}/assets/img/post_a_reflexion_on_design_and_implementation/ACKTR_architecture_drlThatMatter.png" alt="image" style="width:16.5cm" />  
ACKTR Value Network Structure.  
Source: Figure 11 from *Deep reinforcement learning that matters*  <span
id="fb3a3962240c48ebaeef4ea6d5737bf3"
label="fb3a3962240c48ebaeef4ea6d5737bf3">\[fb3a3962240c48ebaeef4ea6d5737bf3\]</span>

They make the following conclusion regarding network structure and
activation function:

> “ The effects are not consistent across algorithms or environments.
> This inconsistency **demonstrates how interconnected network
> architecture is to algorithm methodology**. ”

It’s not a surprise that hyperparameter has an effect on the
performance. To me, the key takeaway is that policy gradient class
algorithm can be highly sensitive to small change, enough to make it fly
or fall if not considered properly.

#### Ok it does matter! What now?

Like I said earlier, the goal of their paper was to highlight problems
regarding reproducibility in DRL publication. As a by-product, they
clearly establish that DRL algorithm can be very sensitive to change
like environment choice or network architecture. I think it also showed
that the applied part of DRL, whether it’s about implementation details
or design & architectural decisions, play a key role and is detrimental
to a DRL project success just as much as the mathematic and the theory
on top of which they are built. By the way, I really liked that part of
their closing thought:

*“ Maybe new methods should be answering the
question:                                      
                                    **in what settings would this work
be useful?** ”*

### Which implementation details are impactful or critical?

We have established in the previous section
<a href="#par:RegardingImplementationDetail" data-reference-type="ref" data-reference="par:RegardingImplementationDetail">1.2.1.1</a>
that implementation details could be impactful in regards to the
performance of an algorithm: if it converges to an optimal solution and
how fast it does.  
Could it be impactful else where? Like wall clock speed for example or
memory management. Of course it does, any book on data structure or
algorithm analysis will say so. On the other end, there is this famous
say in the computer science community: “early optimization is a sin”.  
Does it apply to the ML/RL field? Anyone that has been waiting for an
experiment to conclude after a few strikes will say that waiting for
result is playing with their mind and that speed matters a lot to them
at the moment. Aside from mental health, the reality is that **the
faster you can iterate between experiments, the faster you get feedback
from your decisions, the faster you can make adjustments towards your
goals.** So optimizing for speed sooner than later is impactful indeed
in ML/RL. It’s all about choosing what it a good optimization
investment.  
So we now need to look for 2 types of implementation details: those
related to algorithm performance and those related to wall clock speed.
That’s when things get trickier. Take for example the *value estimate*
computation *V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**) in a *batch
Actor-Critic with bootstraps target* design. In the end, we just need
*V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**) to compute the critic target and
the advantage at the update stage. Ok, then what’s the best place to
compute *V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**)? Is it at *timestep
level* close to the *collect process* or at *batch level* close to the
*update process*?  
Does it matter?

#### Casse 1 - *timestep level*:

Choosing to do this operation at each timestep instead of doing it over
a batch might make no difference on a [*CartPole-v1* Gym
environment](https://github.com/openai/gym/blob/master/gym/envs/classic_control/cartpole.py)
since you only need to store in RAM at each timestep a 4-digit
observation and that trajectory length is capped at 200 steps. So you
end up with relatively small batches size. Even if that design choice
completely fails to leverage the power of matrix computation framework,
considering the setting, computing *V̂*<sub>*ϕ*</sub><sup>*π*</sup>
anywhere would be relatively fast anyway.

#### Casse 2 - *batch level*:

On the other hand, using the same design in an environment with very
high dimensional observation space like the [*PySc2
Starcraft*](https://github.com/deepmind/pysc2) environment, will make
that same operation slower, potentially to a point where it could become
a bottleneck that will considerably impair experimentation speed. So
maybe a design where you compute *V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**)
at *batch level* would make more sense in that setting.

#### Casse 3 - *trajectory level*:

Now let’s consider trajectory length. As an example, a 30-minute *PySc2
Starcraft* game is  ∼ 40, 000 steps long. In order to compute
*V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**) at batch level, you need to store
in RAM memory each timestep observation for the full batch, so given the
observation space size and the range of trajectory length, in that
setting you could end up with RAM issues. If you have access to powerful
hardware like they have in Google Deepmind laboratory it won’t really be
a problem, but if you have a humble consumer market computer, it will
matter. So maybe in that case, keeping only observations from the
current trajectory and computing *V̂*<sub>*ϕ*</sub><sup>*π*</sup>(**s**)
at trajectory end would be a better design choice.  
What I want to show with this example is that

**some implementation details might have no effect in some settings  
but be a game changer in others**.

This means that it’s a **setting sensitive** issue and the real question
I need to ask myself is:

How do I recognize **when** an implementation detail becomes impactful
or critical?  

### Asking the right questions.

From my understanding, there is no cookbook defining the recipe of a
*one best* design & architecture that will outperform all the other ones
in every setting, maybe there was at one point, but not anymore. Like
I’ve talked about previously in the part 1 introduction, even
Monte-Carlo variations are back in the game in DRL, outperforming
bootstraping variations on certain settings . The section also showed
that there was no clear winner in policy gradient class algorithms.  
It’s also clear now that implementation details, design decisions and
architectural decisions can have a huge impact in various settings
<a href="#Subsubsec:DoesItEvenMatter" data-reference-type="ref" data-reference="Subsubsec:DoesItEvenMatter">1.2.1</a>
so that aspect deserves a lot of attention.  
So we are now left with those unanswered questions:

**Why** choose a design & architecture over another?  
How do I recognize **when** an implementation detail becomes impactful
or critical?

I don’t think there is a single answer to those questions and experience
at implementing DRL algorithm might probably play an important role, but
it’s also clear that none of those questions can be answered without
doing a proper assessment of the setting. I think that design &
architectural decisions **need to be well thought out, planned at an
early development stage and based on multiple considerations** like the
following:

-   output requirement (eg. robustness, generalization performance,
    learning speed, …)

-   environment to tackle (eg. action space dimensionality, observation
    type …)

-   resource available to do it (eg. computation power, data storage …)

One thing for sure, those decisions cannot be a “flavour of the
month”-based decision.  
I will argue that **learning to recognize when** implementation details
become important or critical **is a valuable skill that needs to be
developed**.  

Closing thoughts
================

In retrospect, I have the feeling that the many practical aspects of DRL
are maybe sometimes undervalued in the literature at the moment but my
observation led me to conclude that it probably plays a greater role in
the success or failure of a DRL project and it’s a must study in my
quest for seeking *Actor-Critic* method proficiency.

