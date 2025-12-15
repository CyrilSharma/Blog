#import "/typ/templates/blog.typ": block, ctext

#let classes = ("Definition", "Lemma", "Theorem", "Corollary")
#let h1_marker = counter("h1")
#let h2_marker = counter("h2")

#let note_block(body, class: "Block", fill: rgb("#FFFFFF"), stroke: rgb("#000000"), name: "") = {
  let block_counter = counter(class)

  context {
    let serial_num = (
      h1_marker.get().last(),
      h2_marker.get().last(),
      block_counter.get().last() + 1
    ).map(str).join(".")

    let serial_label = label(class + " " + serial_num)
    let wrapped_name = if name != "" { " (" + name + ")" } else { "" }
    ctext(12pt, weight: "bold")[#class #serial_num #serial_label #block_counter.step() #wrapped_name]
    block(
      above: -8pt,
      fill:fill,
      width: 100%,
      inset:8pt,
      radius: 4pt,
      stroke:stroke,
      body
    )
  }
}

// You can change the class name or color here
#let definition(body, name: "") = note_block(
  body, class: "Definition", fill: rgb("#EDF1D6"), stroke: rgb("#609966"), name: name
)

#let theorem(body, name: "") = note_block(
  body, class: "Theorem", fill: rgb("#FEF2F4"), stroke: rgb("#EE6983"), name: name
)

#let lemma(body, name: "") = note_block(
  body, class: "Lemma", fill: rgb("#FFF4E0"), stroke: rgb("#F4B183"), name: name
)

#let corollary(body, name: "") = note_block(
  body, class: "Corollary", fill: rgb("#F7FBFC"), stroke: rgb("#769FCD"), name: name
)

#let notefig(figure) = {
  let figure_counter = counter("Figure")
  
  context {
    let serial_num = (
      h1_marker.get().last(),
      h2_marker.get().last(),
      figure_counter.get().last() + 1
    ).map(str).join(".")

    block(width: 100%, inset:8pt, align(center)[#figure])
    let serial_label = label("Figure" + " " + serial_num)
    align(center, 
      ctext(12pt, weight: "bold")[Figure #serial_num #serial_label #figure_counter.step()]
    )
  }
}

/* Proofs */
#let proof(body) = {
  [*#smallcaps("Proof: ")*]

  [#body]

  align(right)[$qed$]
}

// Automatically jump to the corresponding blocks
// The form of the input should look something like "Definition 1.3.1"
#let refto(class_with_serial_num, alias: none) = {
  if alias == none {
    link(label(class_with_serial_num), [*#class_with_serial_num*])
  } else {
    link(label(class_with_serial_num), [*#alias*])
  }
}

// Templates support up to three levels of headings,
#let set_headings(body) = {
  set heading(
    numbering: "1.1.1."
  )
  
  // 1st level heading
  show heading.where(level: 1): it => [
    // Under each new h1, reset the sequence number of the blocks
    #for class in classes {
      counter(class).update(0)
    }
    #counter("h2").update(0)
    #counter("Figure").update(0)

    // Font size and white space
    #set text(20pt, weight: "bold")
    #block[#it]
    #h1_marker.step()
  ]

  // 2st level heading
  show heading.where(level: 2): it => [
    #set text(17pt, weight: "bold")
    #block[#it]
    #h2_marker.step()
  ]

  // 3st level heading
  show heading.where(level: 3): it => [
    #set text(14pt, weight: "bold")
    #block[#it]
  ]
  
  body
}

#let body_page(body) = {
  set_headings(body)
}

#let note_page(body) = {
  outline(title: "Outline", depth: 2, indent: auto)
  body_page(body)
}