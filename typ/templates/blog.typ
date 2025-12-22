#import "@preview/cetz:0.4.2"
#import "/typ/templates/utils.typ": *
#import "/typ/templates/notes.typ": *

#let sys-is-html-target = ("target" in dictionary(std))

#let author = "Cyril Sharma"
#set heading(numbering: "1.1.")

#let main(
  title: "Untitled",
  desc: [This is a blog post.],
  date: "2024-08-15",
  updatedDate: "",
  tags: [],
  body,
) = {
  // set basic document metadata
  set document(
    author: (author),
    title: title,
  )

  if not sys-is-html-target {
    // Mimic a Title.
    align(center, text(18pt, weight: "bold", title))
    align(center, block(above: 8pt)[#date.split("T").at(0)])
    align(center, {
      let colors = (
        rgb("f2d7d9"), // Warm blush pink
        rgb("e0e0e0"), // Light gray
        rgb("c9d6d5"), // Muted teal-gray
        rgb("f6e9d7"), // Soft cream
        rgb("d9cfe6"), // Pastel lavender
        rgb("f2d7d9")  // Warm blush pink
      );

      for (i, tag) in tags.enumerate() [
        #box(tag, fill: colors.at(calc.rem(i, colors.len())), radius: 4pt, outset: 4pt)
        #h(1em)
      ]
    })
  }
  
  [
    #metadata((
      title: title,
      author: author,
      desc: desc,
      date: date,
      updatedDate: updatedDate,
      tags: tags,
    )) <frontmatter>
  ]

  // Main body.
  set par(justify: true)

  html_rules[#body]
}
