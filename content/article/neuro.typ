#import "/typ/templates/blog.typ": main, graphic
#import "/typ/templates/notes.typ": *
#import "@preview/mitex:0.2.6": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#show: main.with(
  title: "Neuroscience",
  desc: "How does memory work?",
  date: "2025-12-15",
  updatedDate: "2025-12-31",
  tags: ("notes",),
)
#show: note_page

= Memory
== Types of Memory
#definition(name: "Sensory Memory")[
  An extremely short-term buffer of sensory information (audio, visual, etc.). This doesn't last longer then a second and cannot be consciously controlled. This is responsible for the "after-image" when you close your eyes. Unlike many forms of memory, you can't increase the capacity of sensory memory with practice.
]
#definition(name: "Short-term Memory")[
  A memory system which allows stores information on the scale of seconds to minutes. In #link("https://en.wikipedia.org/wiki/The_Magical_Number_Seven,_Plus_or_Minus_Two")[The Magical Number Seven, Plus or Minus Two], experimental tests showed most people can only track 5 to 9 objects at a time. Objects can have sizable complexity, so it is more efficient to remember a phone number as 3 3-4 digit numbers than as a 10 digit string.
]
#definition(name: "Episodic Memory")[
  Part of Long-term Memory. This type of memory holds past personal experiences and can be explicitly recalled.
]
#definition(name: "Semantic Memory")[
  Part of Long-term Memory. This holds facts and other conceptual information. It's usually not tied to the specific experience of acquiring the memory.
]
#definition(name: "Procedural Memory")[
  Part of Long-term Memory. This type of memory consists of skills you remember how to do. It's not tied to the experience of acquiring the skill. It's the type of memory responsible for improvement with practice despite no new recollections. Example things it might store are how to ride a bike, shuffle a deck of cards, and compute a derivative.
]

== Engram Creation
The heart of memory research is to precisely state the storage and retrieval mechanism. The storage mechanism for long-term memory is called an engram, and it requires some permanent change to the neurons (like Long Term Potentiation).

#definition(name: "Engram")[The enduring change in the brain that an experience produces.] <emgram>
#definition(name: "Long Term Potentiation")[A persistent strengthening of synapses based on recent patterns of activity.]

*Engrams* are typically a sparse subset of neurons. Investigation in CA3 pyramidal neurons shows that these while these neurons are initially typical, they rapidly become more excitable over the course of a day past when the memory was made. More precisely, there's a lot more electrical inputs that trigger action potentials and lead to prolonged spiking activity. There's also more inputs that _inhibit_ action potentials.

#let mdiagram(..args) = {
  diagram(
    node-stroke: 2pt,
    edge-stroke: 1pt,
    node-shape: fletcher.shapes.circle, ..args
  )
}
#notefig[
  #graphic[
    #grid(columns: 2, column-gutter: 50pt,
      mdiagram($
        "Pan" edge("dr", "-|>") & "Hot" edge("d", "-|>") & "Cold" edge("dl", "-|>") \
        "Other" edge("-|>")& "Pain"
      $),
      mdiagram($
        "Pan" edge("dr", "=|>") & "Hot" edge("d", "=|>") & "Cold" edge("dl", "=|>") \
        "Other" edge("--|>")& "Pain"
      $)
    )
  ]
]
Here's my understanding of this. Human memory takes as input a situation, and outputs a relevant memory. For example, suppose I burn my hand touching a hot pan. We want the "Pain" neuron to trigger (eliciting the memory of pain) if I'm in a similar situation. Originally, I needed the combined signal from neurons "heat", "pan", and "touch" to make the pain neuron fire, but now we want something like "hot" + "pan" or "pan" + "touch" to trigger the pain neuron (so I remember _before_ I burn myself). If we amplify the signal strength of "hot", "pain", and "touch" then we can achieve this, but now I might retrieve this memory too much. Hence, we also need to make other neurons more likely to inhibit the signal, to create a precise context for when we retrieve this memory.

== Engram Retrieval
Engrams become more sparse over time.
#notefig[
  #figure(
    image("../img/Retrieval.png", format: "png", width: 75%),
    supplement: none
  )
]

Initially, you have a bunch of nodes that are weakly connected to each other, but over time you end up with a smaller number of tightly connected nodes. This implies your brain is constantly culling and refining your memories. This serves a purpose, the smaller your engrams, the more of them you can hold and the tighter the set of inputs they respond to can be. Sparsity has another advantage, which is that barely any of your brain has to be activated to retrieve a memory. If your entire brain had to turn on to retrieve stuff, it wouldn't be efficient at all.

This makes me think the brain is similar to some kind of #link("https://en.wikipedia.org/wiki/Hierarchical_navigable_small_world")[HNSW] scheme, or like an MOE model with a bunch of gates that lead you down to an enormous number of experts, each with potentially a lot of shared parameters.

== Neuron Spiking
Prolonged spiking activity is interesting, because it implies a single input can cause a neuron to spike many times, and indeed this is true! Consider the Hodgkin-Huxley model.

#notefig[
  #figure(
    image("../img/Hodgkin-Huxley.svg", format: "png", width: 50%),
    caption:[The lipid bilayer is represented as a capacitance ($C_m$). Voltage-gated and leak ion channels are represented by nonlinear ($g_n$) and linear ($g_L$) conductances, respectively. The electrochemical gradients driving the flow of ions are represented by batteries ($E$), and ion pumps and exchangers are represented by current sources ($I_p$).],
    supplement: none
  )
]

The system obeys the following differential equations.
#align(center)[
  #mitex(`
    {\displaystyle I=C_{m}{\frac {{\mathrm {d} }V_{m}}{{\mathrm {d} }t}}+{\bar {g}}_{\text{K}}n^{4}(V_{m}-V_{K})+{\bar {g}}_{\text{Na}}m^{3}h(V_{m}-V_{Na})+{\bar {g}}_{l}(V_{m}-V_{l}),} \\
    {\displaystyle {\frac {dn}{dt}}=\alpha _{n}(V_{m})(1-n)-\beta _{n}(V_{m})n} \\
    {\displaystyle {\frac {dm}{dt}}=\alpha _{m}(V_{m})(1-m)-\beta _{m}(V_{m})m} \\
    {\displaystyle {\frac {dh}{dt}}=\alpha _{h}(V_{m})(1-h)-\beta _{h}(V_{m})h}
  `)
]


In order for a spike to occur, there has to be a large voltage drop across the voltage-gated channel. After the current spike, the capacitor gets over saturated and starts to discharge, effectively ending the spike. However, the resistors are also time-varying. Let's just look at $n$. When $n$ is large, the voltage drop is also large, so right after a spike $n$ is high and $V_m$ is high. Hence, $n$ is decreasing rapidly. Once the capacitor starts discharging, $n$ starts to increase again and eventually the voltage drop again will reach critical levels. This is an example of how repeated spiking can occur with a single neuron. Note that this isn't guaranteed to happen, the system could just decay to a steady state instead of overshooting, it all depends on how much current is being pumped in.

This model also explains how an inhibitory current works. If the ion channels suddenly have lower resistance, then there will be a brief spike in current alongside a slight voltage drop across the spiking channel, and so the likelihoods of action potentials will drop.



= To-do
+ The brain has so much memory capacity (estimated 2.5PB) what on Earth is it using it all for? Furthermore, Is the number of synapse states (which is where the estimate comes from) close to the memory capacity, or are synapses weights far more constrained?

= Sources
+ #link("https://arxiv.org/pdf/2506.01659")[Engram Memory Encoding]
+ #link("https://en.wikipedia.org/wiki/Hodgkin%E2%80%93Huxley_model")[Hodgkin-Huxley Model]
+ #link("https://arxiv.org/pdf/2508.10824")[Memory-Augmented Transformers]
+ #link("https://en.wikipedia.org/wiki/Memory")[Memory Overview]