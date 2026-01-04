
#import "@preview/zebraw:0.6.1": zebraw-init, zebraw
#import "@preview/shiroa:0.2.3": templates
#import templates: *

#let code-font = (
  "DejaVu Sans Mono",
)

/// Creates an embedded block typst frame.
#let div-frame(content, attrs: (:), tag: "div") = html.elem(tag, html.frame(content), attrs: attrs)
#let span-frame = div-frame.with(tag: "span")
#let p-frame = div-frame.with(tag: "p")

#let hseperator() = [
  #context if shiroa-sys-target() == "html" {
    html.hr()
  } else {
    line(length: 100%)
  }
]

#let graphic(content) = [
  #context if shiroa-sys-target() == "html" {
    html.frame(content)
  } else {
    content
  }
]

#let css-len(v) = {
  if type(v) == relative {
    let parts = ()
    if v.ratio != 0% { parts.push(str(v.ratio)) }
    if v.length != 0pt { parts.push(str(v.length.pt()) + "pt") }
    if parts.len() == 0 { "0" }
    else if parts.len() == 1 { parts.at(0) }
    else { "calc(" + parts.join(" + ") + ")" }
  } else if type(v) == length {
    let amt = calc.abs(v.pt());
    let sgn = v.pt() >= 0;
    if sgn {
      str(str(amt) + "pt")
    } else {
      str("-" + str(amt) + "pt") 
    }
  } else {
    str(v)
  }
}

#let css-add(key, value) = {
  return key + ": " + value + ";";
}

#let css-radius(v) = {
  let style = ()
  if type(v) in (relative, length) {
    style.push(css-add("border-radius", css-len(v)));
  } else if type(v) == dictionary {
    let top = v.at("top", default: none);
    let right = v.at("right", default: none);
    let bottom = v.at("bottom", default: none);
    let left = v.at("left", default: none);
    // style.push(repr(top))
    if top != none {
      style.push(css-add("border-top-left-radius", css-len(top)));
      style.push(css-add("border-top-right-radius", css-len(top)));
    }
    if right != none {
      style.push(css-add("border-top-right-radius", css-len(right)));
      style.push(css-add("border-bottom-right-radius", css-len(right)));
    }
    if bottom != none {
      style.push(css-add("border-bottom-left-radius", css-len(bottom)));
      style.push(css-add("border-bottom-right-radius", css-len(bottom)));
    }
    if left != none {
      style.push(css-add("border-top-left-radius", css-len(left)));
      style.push(css-add("border-bottom-left-radius", css-len(left)));
    }
  }
  style
}

#let mblock(..attrs, content) = [
  #context if shiroa-sys-target() == "html" {
    let style = ()
    if attrs.at("inset", default: none) != none {
      let inset = attrs.at("inset")
      if type(inset) == length {
        style.push(css-add("padding", repr(inset)));
      } else if type(inset) == dictionary {
        let top = inset.at("top", default: none);
        let right = inset.at("right", default: none);
        let bottom = inset.at("bottom", default: none);
        let left = inset.at("left", default: none); 
        if left != none {
          style.push(css-add("padding-left", repr(left)));
        }
        if right != none {
          style.push(css-add("padding-right", repr(right)) )
        }
        if top != none {
          style.push(css-add("padding-top", repr(top)))
        }
        if bottom != none {
          style.push(css-add("padding-bottom", repr(bottom))) 
        }
      }
    }
    if attrs.at("fill", default: none) != none {
      style.push("background: " + attrs.at("fill").to-hex() + ";")
    }
    if attrs.at("radius", default: none) != none {
      style += css-radius(attrs.at("radius"))
      // style.push("border-radius:" + css-len(attrs.at("radius")) + ";");
    }
    if attrs.at("stroke", default: none) != none {
      style.push("border-color: " + attrs.at("stroke").to-hex() + ";")
      style.push("border-width: 2pt; border-style: solid;")
    }
    let above = attrs.at("above", default: none)
    let below = attrs.at("below", default: none)
    if above != none or below != none {
      style.push("position: relative;");
    }
    if above != none {
      style.push("margin-top:" + css-len(attrs.at("above")) + ";");
    }
    if below != none {
      style.push("margin-bottom:" + css-len(attrs.at("below")) + ";");
    }
    html.elem("div", attrs: ("style": "" + style.join(" ")), content)
  } else {
    block(..attrs)[#content]
  }
]

#let ctext(..attrs, content) = [
  #context if shiroa-sys-target() == "html" {
    let style = ()
    if attrs.at("fill", default: none) != none {
      style.push("color: " + attrs.at("fill").to-hex() + ";") 
    }
    if attrs.at("weight", default: none) != none {
      style.push("font-weight: " + attrs.at("weight") + ";") 
    }
    html.elem("span", attrs: ("style": "" + style.join(" ")), content)
  } else {
    text(..attrs)[#content]
  }
]

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
    // html.elem("div", attrs: ("style": "break-after: column;"), [])
  } else {
    colbreak()
  }
]

// These don't work as show rules.
#let block = mblock;
#let columns = mcolumns
#let colbreak = mcolbreak

#let html_rules(body) = {
  let theme = "light"
  let (
    style: theme-style,
    is-dark: is-dark-theme,
    is-light: is-light-theme,
    main-color: main-color,
    dash-color: dash-color,
    code-extra-colors: code-extra-colors,
  ) = book-theme-from(toml("theme-style.toml"), xml: it => xml(it), target: theme)

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

  show v: it => context if shiroa-sys-target() == "html" {
    let style = ()
    style.push("inline-block;")
    let amount = it.amount.pt();
    if amount > 0 {
      style.push("margin-top: " + str(it.amount.pt()) + "pt;")
    } else {
      style.push("margin-bottom: " + str(it.amount.pt()) + "pt;") 
    }
    html.elem("div", attrs: ("style": "" + style.join(" ")))[]
  } else {
    it
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
     if measure(it).width >= 270pt {
      text(fill: red, [
        Warning, this equation is a very wide 
        and won't render well on small screens.
      ])
    }
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

  body
}