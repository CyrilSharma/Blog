// #import "@preview/zebraw:0.5.2": zebraw-init, zebraw
#import "@preview/zebraw:0.6.1": zebraw-init, zebraw
#import "@preview/shiroa:0.2.3": templates
#import "@preview/cetz:0.4.2"
#import templates: *

#let sys-is-html-target = ("target" in dictionary(std))

#let code-font = (
  "DejaVu Sans Mono",
)

#let author = "Cyril Sharma"


/// Creates an embedded block typst frame.
#let div-frame(content, attrs: (:), tag: "div") = html.elem(tag, html.frame(content), attrs: attrs)
#let span-frame = div-frame.with(tag: "span")
#let p-frame = div-frame.with(tag: "p")

#let graphic(content) = [
  #context if shiroa-sys-target() == "html" {
    html.frame(content)
  } else {
    content
  }
]

#let mblock(..attrs, content) = [
  #context if shiroa-sys-target() == "html" {
    if attrs.at("inset", default: none) != none {
      let inset = repr(attrs.at("inset"))
      html.elem("div", attrs: ("style": "padding-left: " + inset + ";" + "padding-right: " + inset), content)
    } else {
      block(..attrs)[#content]
    }
  } else {
    block(..attrs)[#content]
  }
]

#let ctext(..attrs, content) = [
  #context if shiroa-sys-target() == "html" {
    if attrs.at("fill", default: none) != none {
      html.elem("span", attrs: ("style": "color: " + attrs.at("fill").to-hex()), content)
    } else {
      text(..attrs)[#content]
    }
  } else {
    text(..attrs)[#content]
  }
]

// This is a general pattern which lets us apply custom html functionality 
// Without having to change how we write typst code.
// mblock is a strict super set of block.
#let block = mblock;

#let theme = "light"
#let (
  style: theme-style,
  is-dark: is-dark-theme,
  is-light: is-light-theme,
  main-color: main-color,
  dash-color: dash-color,
  code-extra-colors: code-extra-colors,
) = book-theme-from(toml("theme-style.toml"), xml: it => xml(it), target: theme)

// Add columns support
#let mcolumns(count, content) = [
  #context if shiroa-sys-target() == "html" {
    html.elem("div", attrs: ("style": "column-count: " + str(count) + "; column-gap: 2em;"), content)
  } else {
    columns(count)[#content]
  }
]

#let mcolbreak() = [
  #context if shiroa-sys-target() == "html" {
    html.elem("div", attrs: ("style": "break-after: column;"), [])
  } else {
    colbreak()
  }
]

// Override the built-in functions
#let columns = mcolumns
#let colbreak = mcolbreak

#let main(
  title: "Untitled",
  desc: [This is a blog post.],
  date: "2024-08-15",
  tags: [],
  body,
) = {
  // set basic document metadata
  set document(
    author: (author),
    title: title,
  )

  show link: set text(fill: dash-color)
  show align: it => context if shiroa-sys-target() == "html" {
    let h-align = "center";
    if it.alignment.x == left {
      h-align = "left";
    } else if it.alignment.x == right {
      h-align = "right"
    }

    let v-align = "text-top";
    if it.alignment.y == top {
      v-align = "text-top";
    } else if it.alignment.y == bottom {
      v-align = "text-bottom"
    }
    let s = "text-align: " + h-align + ";" + "vertical-align: " + v-align
    html.elem("div", attrs: ("style": s, "class": "align"))[#it.body]
  } else {
    it
  } 

  let css-len(v) = {
    if type(v) == relative {
      let parts = ()
      if v.ratio != 0% { parts.push(str(v.ratio)) }
      if v.length != 0pt { parts.push(str(v.length.pt()) + "pt") }
      if parts.len() == 0 { "0" }
      else if parts.len() == 1 { parts.at(0) }
      else { "calc(" + parts.join(" + ") + ")" }
    } else if type(v) == length {
      str(v.pt() + "pt")
    } else {
      str(v)
    }
  }

  show box: it => context if shiroa-sys-target() == "html" {
    let style = ()
    if it.fill != none {
      style.push("background:" + it.fill.to-hex() + ";");
    }
    if type(it.radius) == relative {
      style.push("border-radius:" + css-len(it.radius) + ";");
    }
    if type(it.outset) == relative {
      style.push("margin:" + css-len(it.outset) + ";");
    }
    html.elem("div", attrs: ("style": "" + style.join(" ")))[#it.body]
  } else {
    it
  }

  // math setting
  show math.equation: set text(weight: 500, fill: if is-dark-theme { rgb("#fff") } else { rgb("#111") })
  show math.equation.where(block: true): it => context if shiroa-sys-target() == "html" {
    p-frame(attrs: ("class": "block-equation"), it)
  } else {
    it
  }

  show math.equation.where(block: false): it => context if shiroa-sys-target() == "html" {
    span-frame(attrs: (class: "inline-equation"), it)
  } else {
    it
  }

  set text(fill: rgb("dfdfd6")) if is-dark-theme

  /// HTML code block supported by zebraw.
  show: if is-dark-theme {
    zebraw-init.with(
      // should vary by theme
      background-color: if code-extra-colors.bg != none {
        (code-extra-colors.bg, code-extra-colors.bg)
      },
      highlight-color: rgb("#3d59a1"),
      comment-color: rgb("#394b70"),
      lang-color: rgb("#3d59a1"),
      lang: false,
      numbering: false,
    )
  } else {
    zebraw-init.with(lang: false, numbering: false)
  }

  // code block setting
  set raw(theme: theme-style.code-theme) if theme-style.code-theme.len() > 0
  show raw: set text(font: code-font)
  show raw.where(block: true): it => context if shiroa-sys-target() == "paged" {
    rect(
      width: 100%,
      inset: (x: 4pt, y: 5pt),
      radius: 4pt,
      fill: code-extra-colors.bg,
      [
        #set text(fill: code-extra-colors.fg) if code-extra-colors.fg != none
        #set par(justify: false)
        // #place(right, text(luma(110), it.lang))
        #it
      ],
    )
  } else {
    set text(fill: code-extra-colors.fg) if code-extra-colors.fg != none
    set par(justify: false)
    zebraw(
      block-width: 100%,
      // line-width: 100%,
      wrap: false,
      it,
    )
  }

  if not sys-is-html-target {
    align(center, [= #title])
    align(center, [#date.split("T").at(0)])
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
      tags: tags,
    )) <frontmatter>
  ]

  // Main body.
  set par(justify: true)

  body
}
