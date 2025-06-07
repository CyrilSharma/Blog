#import "/typ/templates/blog.typ": main, graphic
#show: main.with(
  title: "The Pareto Frontier",
  desc: ["time allocation"],
  date: "2025-06-06T19:18:47-04:00",
  tags: ("musings",),
)

#import "@preview/lilaq:0.3.0" as lq

Recently I've been surrounded by a lot of really cool people. Some of them are
"everymen", highly competent in dance, climbing, piano, AI, name any field. Some of them are
specialists, who exhibit a high degree of agency and can actively steer the
direction and priorities of the company. More often then not, they're some mix
of both. 

One way to model this is as a
#link("https://en.wikipedia.org/wiki/Pareto_front")[Pareto frontier] of
talent, with the main constraint being time. 

#let indices = range(5)
#align(center)[
  #graphic(
    lq.diagram(
      lq.plot(indices, indices.map(x => 5 - calc.pow(x, 3) / 4)),
      xaxis: (ticks: ((4, ""),), mirror: false, label: "Breadth of Skills"),
      yaxis: (ticks: ((5, ""),), mirror: false, label: "Depth of Skills"),
      grid: none,
    )
  )
]

The idea of this Pareto frontier is it's impossible to do better in both breadth
and depth of skill then any point (or person) on this curve, under certain
assumptions like being healthy, sleeping enough, and being a great friend / SO /
etc. 

People on the interior of the curve (myself included), can improve in either
breadth or depth without sacrificing anything. In other words, they have the
potential to reallocate time to more fulfilling activities.

It's important to note that I'm not saying you should never spend time on activities that
aren't "productive". However, what is wrong is being _compelled_ to do
things, e.g. if you are addicted to late-night benges, or you use it as a means
of procrastination. Moving "closer to the curve" is about allocating your time
more deliberately to the things that will improve your life.

Over time, I think I've gradually been moving closer and closer to the curve.
+ I use a fair amount of my free time for personal development, learning, self-reflection, etc.
+ I've scaled down obvious time-wasting, like impulsive benging of Youtube, shows, etc.
+ I put more effort into trying to learn things efficiently. E.g. if I have significant interest in a topic (like Evolutionary Biology), it probably makes sense to learn about it in a structured way (textbook, class, etc.), rather then consuming a collection of books / articles / etc. over a broad time scale which repeat each other and only give the topic a shallow treatment. This is the main reason I've switched to almost entirely consuming long-form content, like books!

Still, I think there's quite a lot of room to grow. One way is by focusing more
on creating rather then pure learning. If I spent more time drying to
deepen my knowledge rather then broaden it, I believe I could create a lot more
value.

#align(center)[
  #graphic(
    lq.diagram(
      lq.plot(range(5).map(x => x * 4), range(5).map(x => 5 - (2 - x) * (2 - x))),
      xaxis: (ticks: range(5).map(x => x * 4), mirror: false, label: "Time Spent Building"),
      yaxis: (ticks: none, mirror: false, label: "Ability To Create Value"),
      grid: none,
      lq.xaxis(position: top, label: "Time Spent Learning Things",
        ticks: range(5).map(x => (x*4, str(16 - 4*x))))
    )
  )
]


As a sidenote, I'm sort of convinved the following graph is true.

#let indices = range(5);
#align(center)[
  #graphic(
    lq.diagram(
      lq.plot(indices, indices.map(x => 1 / (1 + x))),
      xaxis: (ticks: ((4, ""),), mirror: false, label: "How Interesting You Are
      To Talk Too"),
      yaxis: (ticks: ((5, ""),), mirror: false, label: "Depth of Interest"),
      grid: none,
    )
  )
]

If you spend 16 hours a day grinding this highly specialized thing, then when
the conversation switches to anything else you're kind of screwed. On the other
hand, I can imagine there's lots of ways to get around this. You can have a lot
of "musings" conversations, where you just bring up some idea and discuss it for
a while. This is good if you have a light interest in a lot of areas. Still, I
think finding good musings is hard. At least personally, it feels the more
specialized I become, the harder it is to find things to discuss.

=== How I made these graphs
Typst has this really nice library,
#link("https://lilaq.org/docs/examples/dual-axis")[lilaq]. The graphs look
something like this, 
```typst
#align(center)[
  #graphic(
    lq.diagram(
      lq.plot(indices, indices.map(x => 5 - calc.pow(x, 3) / 4)),
      xaxis: (ticks: ((4, ""),), mirror: false, label: "Breadth of Skills"),
      yaxis: (ticks: ((5, ""),), mirror: false, label: "Depth of Skills"),
      grid: none,
    )
  )
]
```

Unlike Latex code, I find this fast and intuitive. There are also library
function like linspace and whatnot which make this even easier. I can also read
data from files, which should enable cool plots based on real data. There's even
stuff for plotting nodes and edges, and basically any construct you could think
of. I think I'm becoming more convinced this is an upgrade over an obsidian
blog. Actually, the rendering is all messed up in the website... sigh...



