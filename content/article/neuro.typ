#import "/typ/templates/blog.typ": main
#import "/typ/templates/notes.typ": *
#import "@preview/mitex:0.2.6": *
#show: main.with(
  title: "Neuroscience",
  desc: "How does memory work?",
  date: "2025-12-15",
  updatedDate: "2025-12-22",
  tags: ("notes",),
)
#show: note_page

= Engrams
The heart of memory research is to precisely state the storage and retrieval mechanism. The storage mechanism is called an engram, and it usually involves some kind of long-term change to the neurons (like Long Term Potentiation).

#definition(name: "Engram")[The enduring change in the brain that an experience produces.] <emgram>
#definition(name: "Long Term Potentiation")[A persistent strengthening of synapses based on recent patterns of activity.]

What we've learned is that *Engrams* are typically a sparse subset of neurons. Investigation in CA3 pyramidal neurons shows that these while these neurons are initially typical, they rapidly become more excitable over the course of a day past when the memory was made. More precisely, there's a lot more eletrical inputs that trigger action potentials, and a lot more prolonged spiking activity. Interestingly, there's also a lot more inhibitory inputs. This kind of makes sense, for the engram to be useful we need it activate if and only if a reasonable context arises. I'm not sure why this can't be achieved with just excitatory inputs, but perhaps those cannot create a precise enough context by themselves.

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

This model also explains how an inhibitory current works. If the ion channels suddenly have lower resistance, then there will be a brief spike in current alongside a slight voltage drop across the spiking channel, and so the likelyhoods of action potentials will drop.

== Engram Retrieval
One interesting thing about engrams is that they become more sparse over time.
#notefig[
  #figure(
    image("../img/Retrieval.png", format: "png", width: 75%),
    supplement: none
  )
]

Initially, you have a bunch of nodes that are weakly connected to each other, but over time you end up with a smaller number of tighly connected nodes. This implies your brain is constantly culling and refining your memories. This servers a purpose, the smaller your engrams, the more of them you can hold and the tighter the set of inputs they respond to can be. Sparsity has another advantage, which is that barely any of your brain has to be activated to retrieve a memory. If your entire brain had to turn on retrieve stuff, it wouldn't be efficient at all.

This makes me think the brain is similar to some kind of #link("https://en.wikipedia.org/wiki/Hierarchical_navigable_small_world")[HNSW] scheme, or like an MOE model with a bunch of gates that lead you down to an enormous number of experts, each with potentially a lot of shared parameters.

= Todo
+ The brain has so much memory capacity (estimated 2.5PB) what on Earth is it using it all for? Furthermore, Is the number of synapse states (which is where the estimate comes from) close to the memory capacity, or are synapses weights far more constrained?
+ Write up some stuff insights from Memory Augmented Transformers: super-short term memory (sensory buffer), short-term memory (neuron loops), long-term memory (synapses)...

= Sources
+ #link("https://arxiv.org/pdf/2506.01659")[Engram Memory Encoding]
+ #link("https://en.wikipedia.org/wiki/Hodgkin%E2%80%93Huxley_model")[Hodgkin-Huxley Model]
+ #link("https://arxiv.org/pdf/2508.10824")[Memory-Augmented Transformers]