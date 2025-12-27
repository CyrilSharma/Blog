#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Learning How To Use Typst",
  desc: "Typst is like Latex but redesigned to be a usable programming language.",
  date: "2025-05-18",
  tags: ("typst", "tutorial"),
)

#set text(
  font: "New Computer Modern",
  size: 11pt
)

#set quote(block: true)

Typst is like Latex but redesigned to be a usable programming language. It has many other improvements, such as incremental compilation, which lets me see this PDF update in real time. I can even click on lines in the PDF and jump to the exact point in the code which generated them (I'm using the Tinymist VSCode extension).

== Features
Subheader made with ```typst == Features```

There are for loops and function calls making table generation and other tasks relatively trivial.



#block(inset: 1em)[
  ```typst
  #for (word, color) in ("apple", "bannana", "carrot").zip((blue, green, red)) [
    The word #word has #ctext(fill: color)[#word.len()] characters.
  ]
  ```
  Produces...\ 
  #for (word, color) in ("apple", "bannana", "carrot").zip((blue, green, red)) [
    The word #word has #ctext(fill: color)[#word.len()] characters.
  ]
]

To produce indented content like above you can use ```typst#block(args)[content]```.

You can also define variables with the following syntax.
#block(inset: 1em)[
  ```typst
  #let ooga = 5 - 3
  #ooga // prints 2
  ```
]

Math mode is activated by putting things in between ```typst $$``` If there's a leading and trailing space, then it will be put in a seperate block. Otherwise, it will be shown inline.

#block(inset: 1em)[
  Block Mode ```typst $integral_(1)^(infinity) 1/r^2 dif r =  -1/r bar.v_(1)^(infinity) = 1$``` $ integral_(1)^(infinity) 1/r^2 dif r =  -1/r bar.v_(1)^(infinity) = 1 $
  Inline Mode - $integral_(1)^(infinity) 1/r^2 dif r =  -1/r bar.v_(1)^(infinity) = 1$
]

We can do aligned math using the \& syntax. (Very surprised that worked without any modifications).
$
  a + b &= c, \
  d &= e + f + g, \
  x^2 + y^2 &= z^2 \
$


You can define your own functions!
#block(inset: 1em)[
  ```typst
  #let helloWorld() = {
    ctext(fill: red)[Hello World.]
  }

  #helloWorld()
  ```
  #let helloWorld() = {
    ctext(fill: red)[Hello World.]
  }

  Prints: #helloWorld()
]

You can make bullet points with ```typst -```. 
- *Point 1*
- _Point 2_

Or numbered lists with +. 
+ #lorem(10)
+ #lorem(12)
I used ```typst #lorem``` to generate the above.

There are even objects and data structures!

// #align(
//   a + b = c,
//   d = e + f + g,
//   x^2 + y^2 = z^2
// )



We can also change the alignment of text using ```typst align```.
#block(inset: 1em)[
  ```typst
  #for item in (left, center, right) [
    #align(item)[
      #block[Text!]
    ]
  ]
  ```

  #for item in (left, center, right) [
    #align(item)[
      #block[Text!]
    ]
  ]
]


We can do footnotes #footnote[These work natively in Typst 14.0!]. Websites are kind of one massive page, so they'll all be at the very bottom. That's probably fine though.

We can also do fancy graphics and callouts, but sadly all such things require exporting to SVG, and Typst doesn't support selectable text for this. I think this will be useful for plotting graphs and tables though.
#align(center)[
  #graphic(
    box(
      fill: luma(240),
      inset: 12pt,
      radius: 6pt,
    )[
      *Tip:* Save often to avoid losing work.
    ]
  )
]

There's also a bunch of meta-programming in the language (like show rules, argument spreading, sinks, etc.) which I had to deal with to get the HTML export to work. It mainly boiled down to wrapping the Typst functions in custom HTML functions, and then emitting appropriate CSS.

Over time, I might be able to get rid of all this styling though. The library is maintained quite actively. Thanks to #link("https://github.com/typst/typst/blob/2c515a86383d9e338597ba2f2cfa6501dcb74865/tests/suite/text/deco.typ")[PR] which came out like a day or two ago, I can do #strike[Struck], #highlight[Highlighted], #underline[Underlined], and #overline[Overlined].

I can do quotes!
#quote[Typst is pretty cool guys]

I can also do terms.
/ Agency: The ability to choose your path independently of the environment you're placed in.
/ Book: A fun thing people should use more.

// #set table(
//   stroke: none,
//   gutter: 0.2em,
//   fill: (x, y) =>
//     if x == 0 or y == 0 { gray },
//   inset: (right: 1.5em),
// )
//
// #show table.cell: it => {
//   if it.x == 0 or it.y == 0 {
//     set text(white)
//     strong(it)
//   } else if it.body == [] {
//     // Replace empty cells with 'N/A'
//     pad(..it.inset)[_N/A_]
//   } else {
//     it
//   }
// }
//
#let a = table.cell[A]
#let b = table.cell[B]

Wow, tables work natively!
```typst
#let a = table.cell[A]
#let b = table.cell[B]
#table(
  columns: 4,
  [], [Exam 1], [Exam 2], [Exam 3],

  [John], [], a, [],
  [Mary], [], a, a,
  [Robert], b, a, b,
)
```
#table(
  columns: 4,
  [], [Exam 1], [Exam 2], [Exam 3],

  [John], [], a, [],
  [Mary], [], a, a,
  [Robert], b, a, b,
)
