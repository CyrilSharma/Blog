#import "@preview/arborly:0.3.1": tree
#import "/typ/templates/blog.typ": main, graphic
#show: main.with(
  title: "Tree",
  desc: "Drawing a Tree",
  date: "2025-05-19",
  tags: ("random",),
)

#let args = (stroke: white, text: (fill: blue), parent-line: (stroke: blue, stroke-width: 2pt))

// https://forum.typst.app/t/how-to-export-cetz-diagrams-in-html/3034/5
// https://github.com/pearcebasmanm/arborly/blob/main/docs/manual.pdf
// If we make cetz drawings in the future, we should wrap this functionality in a function.
// That way, if we change our export format, we only have to change one function.

// Doesn't work on the tinymist renderer because the compiler is not up to date.
#align(center)[
  #graphic(
    tree(style: args)[Root
      [Left
        [Left.Left]
        [Left.Right]
      ]
      [Right
        [Right.Left]
        [Right.Right]
      ]
    ]
  )
]
