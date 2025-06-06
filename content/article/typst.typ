#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Learning How To Use Typst",
  desc: [Typst is like Latex but redesigned to be a usable programming language.],
  date: "2025-05-18",
  tags: ("typst", "tutorial", "programming"),
)

#set text(
  font: "New Computer Modern",
  size: 11pt
)

Typst is like Latex but redesigned to be a usable programming language. It has many other improvements, such as incremental compilation, which lets me see this PDF update in real time. I can even click on lines in the PDF and jump to the exact point in the code which generated them (I'm using the tinymist vscode extension).

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



We can also do fancy graphics and callouts, but sadly all such things require exporting to svg, and typst doesn't support selectable text for this. I think this will be useful for plotting graphs and tables though.
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

There's also a bunch of meta-programming in the language (like show rules, argument spreading, sinks, etc.) which I had to deal with to get the html export to work. It mainly boiled down to wrapping the typst functions in custom html functions, and then emitting appropriate css.








