#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Massive Input 1",
  desc: "",
  date: "2025-07-12T13:04:49-04:00",
  tags: ("notes", "bio"),
)

This is an idea I saw from this #link("https://nintil.com/massive-input-spaced-repetition/")[blog post]. The question we're trying to solve is what is an effective strategy to learn things. There's two main approaches.

/ Bottom-Up: Build your knowledge gradually, learning each and every core component. After doing this for a while, you will have a great understanding about the subject matter with few holes.
/ Top-Down: Learn about the things you want to know, recursing into your knowledge gaps as necessary.

*Bottom-Up* is great when you're early in the learning stage, where you're learning the basics upon which every advanced topic will require an excellent understanding. 

*Top-Down* is great when you want exposure, when you're trying to learn something as fast as possible, and when you're trying to maximize for engagement. It's also the only viable approach when trying to gain an understanding of a truly massive space in a short-time.

To that end, I'm going to use a *Top-down* approach to try and learn as much about *Bio*, *Robotics*, and anything else I stumble upon that seems remotely interesting.

== Notes
#set quote(block: true)
=== #link("https://deepmind.google/discover/blog/alphagenome-ai-for-better-understanding-the-genome/")[AlphaGenome]

#quote[Our AlphaGenome model takes a long DNA sequence as input — up to 1 million letters, also known as base-pairs — and predicts thousands of molecular properties characterising its regulatory activity. It can also score the effects of genetic variants or mutations by comparing predictions of mutated sequences with unmutated ones.]

Ok in a nutshell this predicts the effects of non-coding sequences of DNA, such as their effects on where genes start, and how much RNA these regulatory genese induce.

=== #link("https://www.retro.bio/science")[Retro Biosciences]

==== #link("https://febs.onlinelibrary.wiley.com/doi/10.1002/1873-3468.13681")[Article on HSC Reprogramming]
/ In Vitro: Doing a biological process outside of a living organism.
/ In Vivo: The opposite of *In Vitro*
/ Exogenous Gene Expression: The expression of a gene foreign to the organism.
/ Retrovirus: Reverse transcribes it's RNA into DNA and injects that into the hosts DNA. The host cell has altered DNA for life. A normal virus would just give the cells instructions to produce different kinds of proteins, not fundamentally rewire it.
/ Transcription Factors: Proteins that gets stuck to sequences of DNA. It's chemical properties can increase the odds that RNA polymerase will start transcribing this DNA region, or decrease them.
/ Protein: Chain of Amino Acids
/ Enzyme: Special type of protein that speeds up chemical reactions.
/ Acid: Substance which donates protons. I remember this.
/ Nucleic Acid: Less reactive, stable, good for information storage (buildling block of DNA).
/ Amino Acid: Acidic, Basic, Polar, Nonpolar, a lot more types, form much more complex shapes, can do much crazier things. Building block of Proteins.
/ Hematology: The branch of medicine focused on the study of blood.
/ Haematopoietic Lineage Decisions: Basically how certain stem cells decide to be certain blood cells.
/ Transduced: Transferring genetic material from once cell to another.
/ Cytokines: Small proteins that are transmitted between cells as a means of communication.
Ok... I get the idea, take some stem cell and use it to make blood cells. Currently, there's no way to mass manufacture blood cells, which is kind of surprising now that I think about it.

==== #link("https://www.nature.com/scitable/topicpage/the-discovery-of-lysosomes-and-autophagy-14199828/?utm_source=chatgpt.com")[Article on Autophagy]
/ Metabolism: The set of reactions that occur in cells involved with growth, reproduction and maintenance.
/ Anabolism: The subset of metabolism related to creating stuff.
/ Catabolism: The subset of metabolism related to destroying stuff.
/ Autophagy: Means "self-eating", it's a catabolic process which delivers stuff to the lysosomes who break it down for digestion.
/ Lysosome: Basically bags of enzymes, used to break stuff down.
/ Autophagosomes: Literal membranes spheres that wrap some portion of stuff inside a cell and then transport it to Lysosomes.
There's some evidence it can protect against cancer and celluar damage in general. Which makes sense, having a garbage collector seems helpful.

==== #link("https://jneuroinflammation.biomedcentral.com/articles/10.1186/s12974-024-03015-9?utm_source=chatgpt.com")[Microglia Therapeutics]
/ Central Nervous System (CNS): The Brain and Spinal Chord
/ Microglia: The immune cells which live in the Central Nervous System. More specifically, they are brain-resident macrophages.

Wait WTF?
#quote[Nearly one in six of the world’s population suffers from neurological disorders, encompassing neurodegenerative and neuroautoimmune diseases, most with dysregulated neuroinflammation involved.]

/ Major Histocompatibility Complex (MHC): The group of genese that encode the fancy antigen presenting proteins (e.g. proteins which showcase things of concern to the surface of the cell) so that T-Cells can distinguish between foreign and native cells.
/ Axons: Thread like things attached to nerve cells which transmit electrical signals.
/ Myelin: The stuff which coats Axons... and somehow helps transmit signals?

*Some relevant neuroscience*
Here's some more in-depth info on this. The brain doesn't really transmit charge across Axons. Instead, it transmits "spikes" of current. Initiailly, the inside of the Axon is negatively charged, then a ton of current floods in to the inside of the Axon. At some point the gradient between the inside and outside is large enough that the charge rushes to the outside, causing a spike in the charge of the outside of the membrane, which quickly drains off. 

This spike in voltage on the membrane can trigger the release of chemicals which start the process over again at some other portion of membrane. It's like a chain of dominos. There's even a mechanism akin to amplifiers. Like imagine your're a neuron with an axon to another neuron. Suppose the other neuron is very far away. If you just used an axon, the signal would decay far too much to be detectable. So instead, things are segmented into patched, and tiny little amplifiers ensure that the signal propogates with full strength across the entire Axon.

What Myelin really does is prevent charge from inside the membrane from easily leaking outside of the membrane, thereby increasing the amount of distance before you need another amplifier. The fewer amplifiers you need, the faster the connection! You can't get rid of amplifiers entirely though, because there is still other sources of electrical leakage.

*Microglia* can help eliminate *myelin* debris, which partially explains why it's important for mitigating neurodegenerative disease. They also just clean up all the junk apoptosis remains after an inflamation response, the state of your brain clean.

/ Phagocyte: Type of cell which consumes bacteria and other small particles.
/ Homeostasis: The process by which you maintian a stable internal environment despite external changes.
/ Constitutively Activate Protein: A protein which is perpetually in the active state.
/ ROS-laden: A state where something contains reactive oxygen species. Makes for unstable cell environments.

If your *Microglia* are perpetually activate, then they'll be constantly secreting cytokines asking for an immune response. This will do a lot of damage to your neurons. Point being, under or over activity of these immune cells can cause a lot of damage to the brain.

/ NK-Cells: Natural Killer Cells, unlike T-Cells which kill thing if they don't present proper antigens, these guys have different mechanisms which allow them to efficiently detect and kill problematic cells.

There are a lot of medical approaches which just do something to Microglia cells. Just as an overview, using the cells to deliver drugs, suppressing their activity, boosting their activity, etc. I might come back to this section and try to learn precisely how one or two of these approaches work.

==== #link("https://jbioleng.biomedcentral.com/articles/10.1186/s13036-019-0144-9")[Tissue Reprogramming]
/ Pluripotent: capable of becoming many other types of cells (think stem cells)
/ iPSC Reprogramming: Turn the cell back into a Pluripotent state, then use transcription factors to guide it down to the cell type you want. Typically takes a few months, and if it doesn't fully finish differentiating the cell, can end up creating cancerous cells (somehow).
/ Direct Reprogrmaming: Directly transform one somatic cell to another using transcription factors. It is much less likely to produce mutations or tumor formation, and way faster.
/ Non-Dividing Cells: Did you know not all cells divide? The canonical example is the neuron. They can still get made, e.g. through stem cells reproducing and differentiating, but they do not themselves reproduce.

The general pipeline seems to work like this. You couple an antibiotic resistant gene and some genes the will boost the transcription factors you want into a single virus. Then, you infect all the cells with that virus (it's a retrovirus, so it gets inserted into the genome). You employ antibiotics and prune out all the cells which didn't successfully integrate the virus. Everything else will now hopefully differentiate into the desired cell type.

Currently, the method for choosing what transcription factors to over-express isn't very efficient, a lot of researchers do some form of guess and check.

It's somewhat hard to get any real insight into any of the specific approaches. It feels like a long list of "this person tried X and achieved Y".

