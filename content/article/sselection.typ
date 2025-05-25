#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Sexual Selection, what's the point?",
  desc: [Random notes],
  date: "2025-05-23T14:00:00",
  tags: ("evolution", "notes"),
)

The canonical answer in biology class is "genetic diversity", but this isn't such an obvious win. Here are some of the disadvantages. 

#block(inset: 1em)[
  + Imagine I have a sexual population equal parts male and female. If every female gives birth to two children, then the population size won't change. In an asexual population, every individual can reproduce, and so the population size could've doubled. Hence, sexual populations need to work much harder to maintain growth. 
  + Suppose I've evolved a really good set of genes. In an asexual population, my set of genes would get propogated, virtually unchanged, to the next generation. In a sexual population, half the genes would get thrown out and replaced with my mate's dna. In this case, sexual selection actually made my descendents do worse! 
  + Another way to view the above is with cards. Let's say I'm playing a card game and drew a really good hand. If I had the choice between keeping my hand and mixing it with someone elses, I would probably keep my hand, because I know in the next round the hand will still be good. Sexual selection, on the other hand, would have me shuffle some cards in from the deck.
]

So then why is sexual reproduction so common?
#block(inset: 1em)[
  + In most environments, pathogens and parasites create a constantly changing environment. Hence, reusing good genes from the previous generation is not enough to guarantee success, as those genes might not be good anymore.
  + Asexual selection suffers from many forms of internal gene competition.
    - If two good mutations arise at the same time, the two will battle it out for dominance. In a sexual population, the two traits could stack rather then compete.
    - Asexual populations rely on a class of highly fit individuals to pass on the good genes. If those invididuals were to die, then the population is screwed. Sexual populations are capable of reproducing that set of highly fit individuals every generation. Sexual populations are "fault-tolerant".
  + Bad traits can "go along for the ride" in asexual populations. E.g. whatever traits (good or bad) are on the members of the species with dominant positive mutations will eventually become a part of the entire population. In sexual populations, the set of traits on the fit organism are not as coupled, allowing deleterous mutations to die off.
]







