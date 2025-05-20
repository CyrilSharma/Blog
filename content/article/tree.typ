#import "/typ/templates/blog.typ": main
#import "@preview/arborly:0.3.1": tree
#show: main.with(
  title: "Tree",
  desc: [Drawing a Tree],
  date: "2025-05-19",
  tags: ("random",),
)

#let args = (stroke: white, parent-line: (stroke: white, stroke-width: 2pt))

// https://forum.typst.app/t/how-to-export-cetz-diagrams-in-html/3034/5
// https://github.com/pearcebasmanm/arborly/blob/main/docs/manual.pdf
// If we make cetz drawings in the future, we should wrap this functionality in a function.
// That way, if we change our export format, we only have to change one function.
#html.frame(
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