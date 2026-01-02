#import "/typ/templates/blog.typ": *
#import "@preview/alchemist:0.1.8": *
#show: main.with(
  title: "Biology",
  desc: "",
  date: "2026-01-02T12:27:42-05:00",
  tags: ("notes",),
)

#show: body => note_page(body)

= Chemistry 
#definition(name: "Covalent Bond")[
  Strong bonds formed by sharing electrons to fill valence shells. Typically, Carbon can form four, Nitrogen 3, and Oxygen 2. For Nitrogen and Oxygen the valence electrons that don't participate in a covalent bond will pair off to form a lone pair.

  Nitrogen and Oxygen commonly bond with lone protons. If this happens Oxygen can form 1 or 3 covalent bonds, and Nitrogen can form 4.

  Sulfur essentially copies Oxygen. Phosphorus commonly appears in forms with 5 covalent bonds to Oxygen.
]

#let drawing(..args, content) = {
  figure(..args, graphic(content))
}

Here are the most common functional groups.
#table(
  rows: 5,
  columns: 2,
  [*Lewis Structure*],
  [*Functional Group*],
  graphic(skeletize({
    fragment("R")
    single(angle:0)
    fragment("OH", lewis:(
      lewis-double(angle: -90),
      lewis-double(angle: 90),
    ))
  })),
  "Hydroxide",
  graphic(skeletize({
    fragment("R")
    single(angle:0)
    fragment("C")
    branch({
      double(angle: +1)
      fragment("O", lewis:(
        lewis-double(),
        lewis-double(angle: 120deg),
      ))
    })
    single(angle: -1)
    fragment("OH")
  })),
  "Carboxyl",
  graphic(skeletize({
    fragment("R")
    single(angle:0)
    fragment("NH_2", lewis:(
      lewis-double(angle: 90),
    ))
  })),
  "Amine",
  graphic(skeletize({
    fragment("R")
    single()
    fragment("O")
    single()
    fragment("P")
    branch({
      double(angle: 90)
      fragment("O")
    })
    branch({
      single(angle: 135)
      fragment("O^-")
    })
    single()
    fragment("O^-")
  })),
  "Phosphate",
  graphic(skeletize({
    fragment("R")
    single()
    fragment("SH", lewis:(
      lewis-double(angle: 90),
    ))
  })), 
  "Sulfhydryl / Thiol"
)

These are some common condensation reactions. They're called this because they release a water molecule in the process.
#table(
  rows: 2,
  columns: 2,
  graphic(skeletize(config: (angle-increment: 30deg), {
    fragment("R_1")
    single(angle:1)
    fragment("N")
    branch({
      single(angle: 3)
      fragment("H")
    })
    single(angle: -1)
    branch({
      double(angle: -3)
      fragment("O")
    })
    single(angle: 0)
    fragment("R_2")
  })),
  "Amine + Carboxyl = Amide",
  graphic(skeletize(
    config: (angle-increment: 30deg), {
    fragment("R_1")
    single(angle:1)
    fragment("O")
    single(angle: -1)
    branch({
      double(angle: -3)
      fragment("O")
    })
    single(angle: 1)
    fragment("R_2")
  })),
  "Hydroxide + Carboxyl = Ester"
)

#definition(name: "Non-Covalent Bond")[
  Weaker bonds that can be formed and broken much more readily. These are what facilitate "dynamic" systems. 
  + Ionic bonds are formed when you have two oppositely charged things (2-10 kcal/mol).
  + Hydrogen bonds when a hydrogen atom bonded to an electronegative element (Oxygen, Nitrogen, Sulfur) interacts with a lone electron pair (3-7 kcal/mol).
  + Hydrophobic bonds are the tendency for non-polar substances to group together in the presence of water (think oil). Why this happens isn't understood too well (1-2 kcal/mol).
  + Van der Waals bonds are just the tiny forces you get from weakly polarized bonds (1 kcal/mol).
]

#definition(name: "Lipids")[
  Chemical structures rich in C-C and C-H bonds. Because they primarily have C-H bonds, they can't Hydrogen bond and are hydrophobic. They're used a lot for energy storage (one reason being they don't attract water molecules, allowing them to attain higher energy densities) and insulation (because water conducts heat a lot better than fat does). Notable examples are fats, some vitamins, cholesterol, and cell membranes.

  Saturated lipids have no carbon-carbon double bonds, and unsaturated lipids have at least one such bond. These terms are important because double bonds are much more rigid than single bonds.
]

#definition(name: "Phospholipids")[
  These guys have one of the phosphate groups at their head, with a non-polar lipid tail. Put them in water, and you will quickly end up with Bilayer, where the heads form the exterior and the hydrophobic tail forms the interior.
]

#definition(name: "Fatty Acids")[
  These molecules consist of a long hydro-phobic tail (C-C and C-H bonds) with a hydrophilic head. These include things like Trans-Fats and Cis-Fats.
]

== Amino Acids, Peptides and Proteins
Amino acids are just amines plus carboxylic acids. $alpha$-Amino acids are a subclass of amino acids where the amines and carboxylic acid are attached to the same Carbon atom.

#align(center, graphic(
  skeletize({
    fragment("H_2 N")
    single(angle: 1)
    single(angle: -1)
    branch({
      double(angle: -2)
      fragment("O")
    })
    single(angle: 1)
    fragment("OH")
  })
))

They can also appear with a $upright(H_3 N^+)$ term.

Peptides are small chains of amino acids (like 1-50), and proteins are huge chains of $alpha$-amino acids (hundreds to thousands). The chains are formed via condensation reactions between the carboxyl and amine groups.