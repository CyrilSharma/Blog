
#import "/typ/templates/blog.typ": main
#show: main.with(
  title: "Evolution of Complexity",
  desc: [Trying to answer some basic evolutionary questions],
  date: "2025-05-23T17:00:00",
  tags: ("evolution", "notes"),
)

I like to understand how the world works. I realized the other day that I don't _really_ get how evolution works. Here are some of the questions I was wondering.


*If every step of evolution must confer a selection advantage, then how did complex structures which seem to only be useful when fully formed evolve?*

From what I can find, almost every complex structure was useful to some extent as it was evolving.

- For example, the eye was probably initially just a patch of light sensitive cells, which gradually became more and more specialized. However, at every point, those cells conferred an advantage, the ability to interpret light information. The proteins inside your eye which are clear and refract light (crystallins) are actually very similar to other proteins throughout your body, hence the first steps towards forming an eye are pretty easy for me to rationalize.

- Things like wings are a bit harder to rationalize. A lot of explanations rely on exaptations, the repurposing of a body part for some new function. For example, it's theorized dinosaurs had feathers which they used to keep warm, and a lot of the pre-requisites for wing devlopment happened because winged dinosaurs needs to run quickly, jump, glide, etc. 

Also, it's possible for entire structures to be generated with a small genetic change. There have been experiments done on flies which turn these appendanges attached near the wings into another set of fully formed wings. So although the phenotypes of some changes might be very different, the genetic distance might be pretty small. 

*Can acquired characteristics (e.g. my swimming ability) be inherrited?*

From what I could find, there is almost no mechanisms by which #link("https://en.wikipedia.org/wiki/Lamarckism")[Lamarckian] evolution occurs. Lamarckian evolution is the idea that organsism can adept to their environment, and that these adaptations are inherited.

The main reason why this doesn't occur is because somatic cells (the cells of your lungs, your skins, etc.) are distinct and isolated from germ cells (the cells which pass on your genes). Specifically, they live in different places of your body, and have chemical incompatibilities. This is interesting because rather then seeming arbitrary, this makes me think we evolved _not_ to have Lamarckian evolution. As a brief though on why, imagine how terrible it would be if every skin cell mutation (probably from sun exposure) made its way into your genes. The isolation of the germ cells acts as a safeguard from the wear-and-tear of life.

*How can random genotypic change allow evolution to occur at a reasonable rate?*

+ One of the problems with random change is that it doesn't depend on the environment. Of course, we have natural selection which biases persistent changes in the right direction, but this feels too slow.
  - If Lamarckian evolution was prevalent, then genetic change itself would be biased towards the adaptations animals accrue over the course of their life, so we wouldn't have this problem.

  - While this is not the case, there is a similar mechanism: _inheritable adaptability_. The insight is that a single genotype can encode a variety of phenotypes. When a new environment change happens, organisms with genes that let them adapt the most are selected for. In this way it's not the adaptations that are inheritted (like Lamarckian evolution posits), but rather the _capacity for adaptation_. Over time, the organisms genetics can gradually catch up, making the organism have to adapt less and less with every passing generation.

  - This makes the speed of evolution seem more reasonable. An organism can adapt to its environment, and in doing so amplify the effects of natural selection.

  - As a sidenote, this help explains a common observation, namely if person A's parents tend to be good atheletes, then person A is often one too, _even if person A's parents weren't obviously genetically gifted_ (they didn't have a near optimal ratios of muscle fibers, V$0_2$ max, etc.). The fact that both parents were able to _become_ good athletes implies they have a high capacity for adaptation, so you would expect the kid to have that too. 


+ However, this isn't enough to answer the question. If change was totally random, then it could be something like I spawn a random cell somewhere in my body. This is too unstructured and minute for evolution to happen in a reasonable timeframe. Evidently, random genetic change must produce "somewhat useful" phenotypical change. Here are some of the mechanisms.
  - There is a lot of evidence that genes have coupling (e.g. genes that dictate the size of your left arm also dictate the size of your right arm). This helps bias random genetic change in reasonable directions. You would expect coupling because a species with gene coupling would be more adaptable then a species without it, and hence there is a selection bias for this feature.
  - Duplication of entire genes happen all the time. This makes it easy to evolve traits which increase or decrease the amount of a protein your produce. As a sidenote, the reason this happens is because your DNA makes proteins by constantly bumping into RNA transcribers, who then spit out mRNA for your ribosomes to template proteins off of. Hence having more of a gene linearly scales up the number of transcriptions.
  - Genetic pathways are like a highly structured piece of code. There are individual genes which can turn off and on various limbs. There are individual genes which decide which body part should be which. Hence, flipping one base pair to another can produce a very structured change (like the toggling of a switch).

*How do we can quantitaviely attain confidence then some feature could've evolved in some time frame?*
+ You would expect a trait to spread to fixation within a logarithmic number of generations (will right the derivation at some point). 