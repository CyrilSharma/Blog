#import "/typ/templates/blog.typ": *
#import "@preview/alchemist:0.1.8": *
#show: main.with(
  title: "Biology",
  desc: "",
  date: "2026-01-02T12:27:42-05:00",
  tags: ("notes",),
)

#show: body => note_page(body)

= Biochemistry
== Basics
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
  Chemical structures rich in C-C and C-H bonds. Because they primarily have C-H bonds, they can't Hydrogen bond and are hydrophobic. They're used a lot for energy storage (one reason being they don't attract water molecules, allowing them to attain higher energy densities) and insulation (because they repel water which is good at transferring heat). Notable examples are fats, some vitamins, cholesterol, and cell membranes.
]

An important terminology with lipids is saturated and unsaturated. Saturated lipids have no carbon-carbon double bonds, and unsaturated lipids have at least one such bond. Double-bonds are very strong and rigid, and greatly affect the geometry of the lipid.

#align(center, table(
  columns: 2,
  graphic(
    skeletize({
      single()
      single()
      branch({
        single(absolute: -100deg)
        fragment("H")
      })
      double(angle: 0.25)
      branch({
        single(absolute: -70deg)
        fragment("H")
      })
      single(angle: 0.50)
      single(angle: 0.50)
    })
  ),
  graphic(
    skeletize({
      single()
      single()
      branch({
        single(absolute: 90deg)
        fragment("H")
      })
      double(angle: -0.25)
      branch({
        single(absolute: -90deg)
        fragment("H")
      })
      single()
      single()
    })
  )
))

When the Hydrogens are on the same side, this is called a cis-lipid, and when they're on opposite sides it's called a trans-lipid. The close-by hydrogen atoms of the cis-lipid cause a kink to form in the lipid, which makes it a lot harder for Van der Waal forces to keep strands of such lipids together. For this reason, unsaturated lipids are typically not solids at room temperature whereas saturated lipids are.


#definition(name: "Phospholipids")[
  These guys have one of the phosphate groups at their head, with a non-polar lipid tail. Put them in water, and you will quickly end up with Bilayer, where the heads form the exterior and the hydrophobic tail forms the interior.
]

#definition(name: "Fatty Acids")[
  These molecules consist of a long hydro-phobic tail (C-C and C-H bonds) with a hydrophilic head. These include things like Trans-Fats and Cis-Fats (like Monounsaturated and Polyunsaturated Fats).
]

=== Why are Trans and Saturated Fats Bad?
Your body doesn't want to consume fats which pack too tightly into membranes, as this will mess up various receptors. In particular, your liver has receptors for detecting Cholesterol. It won't release proteins to pull LDL from the blood-stream if it thinks it already has a lot of Cholesterol. Trans and Saturated fats can mess up these receptors causing your body to under-estimate how much Cholesterol has been delivered and consequently deliver too much. #link("https://www.health.harvard.edu/staying-healthy/the-truth-about-fats-bad-and-good")[More on fats].

=== What is Cholesterol?
Cholesterol is a lipid which essentially makes cell membranes more rigid by inserting itself into cell membranes and pulling hard on neighboring lipids. Without Cholesterol, your cell membranes would be too loose and let too much stuff in.

LDL proteins transfer Cholesterol from your liver to tissue through your veins, and HDL proteins do the reverse. If you produce too much Cholesterol then LDL proteins will end up causing cholesterol build up on your veins, reducing blood flow and setting the stage for a lot of problems.

== Amino Acids, Peptides and Proteins
Amino acids are just amines plus carboxylic acids. For this reason, they almost always end with "ine", although in a few cases they end with "ic". $alpha$-Amino acids are a subclass of amino acids where the amines and carboxylic acid are attached to the same Carbon atom. 

#align(center, graphic(
  skeletize({
    fragment("H_2 N")
    single(angle: 1)
    branch({
      single(absolute: 90deg)
      fragment("R")
    })
    single(angle: -1)
    branch({
      double(absolute: -90deg)
      fragment("O")
    })
    single(angle: 1)
    fragment("OH")
  })
))

They're often written with H#sub[3]N#super[+] instead of H#sub[2]N and O#super[-] instead of OH because that is their typical form in a solution of PH7.

Peptides are small chains of amino acids (like 1-50), and proteins are huge chains of $alpha$-amino acids (hundreds to thousands). When one chemical compound is used as the building block for another structure, it is called a *monomer*, hence Amino Acids are *monomers* of Proteins. What gives proteins and (to a lesser extent) peptides their structure? Many different factors. It's common to group these into four groups. 
+ Primary: The amino acid chain itself. This is formed via condensation reactions between the carboxyl and amine groups of successive amino acids. This is called a peptide bond.
#align(center, graphic(
  skeletize({
    fragment("H_2 N")
    single(angle: 1)
    branch({
      single(absolute: 90deg)
      fragment("R_1")
    })
    single(angle: -1)
    branch({
      double(absolute: -90deg)
      fragment("O")
    })
    single()
    fragment("N")
    branch({
      single(absolute: -90deg)
      fragment("H")
    })
    branch({
      single(absolute: 105deg, stroke: white)
      fragment("H_2O")
    })
    single(angle: 1)
    branch({
      single(absolute: 90deg)
      fragment("R_2")
    })
    single(angle: -1)
    branch({
      double(absolute: -90deg)
      fragment("O")
    })
    single(angle: 1)
    fragment("OH")
  })
))

+ Secondary: Non-Covalent bonds between just the chain (not the attached R-groups) which allows things like coils to form. Often hydrogen bonds between one acid's double-bonded O and another acid's Nitrogen attached H.
+ Tertiary: The full 3D structure of a single amino acid chain, formed using forces between the R-groups.
+ Quaternary: Complex structures formed with multiple polymer chains.

== Enzymes
A reaction can proceed spontaneously if it's Gibb's Free Energy is negative.
$
  Delta G = Delta H - T Delta S
$

Where $T$ is the temperature, $H$ is energy and $S$ is entropy. *TODO*: This formula deserves a whole section of its own.

However, just because a reaction can occur spontaneously doesn't mean it occurs very fast. The conditions needed might be complex. Enzymes reduce the activation energy needed to perform the reaction. In a closed system with no energy input they don't change the equilibrium point of the system (moving the equilibrium point requires fighting thermodynamics; hence energy).

Enzymes are typically pretty big. This is because they need to be able to bind the products and do very complex things like orient them optimally, twist them, charge them, etc.

=== Inhibition
There are two main ways to inhibit an enzyme. One way is to bind to a non-active site of the enzyme, and change its shape. This is called an *allosteric* inhibitor. The second way is to bind to the active site itself, competing with the reactants. In either case, if you bind non-covalently this is considered reversible and if you bind covalently it is considered irreversible.

=== Pathways
Reactions often occur in pathways. This is because the rate of production decreases as you approach equilibrium concentrations. However, if you continuously use up the products in _another_ reaction, then you continue to produce products at the pre-equilibrium rate. This secondary reaction can be a fast, spontaneous reaction that releases energy to maximize the effect.

Pathways are often achieved by physically linking enzymes together, making it easy for several consecutive reactions to occur.

=== Reverse Feedback
This is a trick used to regulate the amount of product produced at the end of the pathway. The idea is just to have the final products bind to one of the enzymes earlier in the chain, which stops the whole production pipeline.

== Carbohydrates and Glycoproteins
Carbohydrates got their name because their chemical formulas often looked like
$
  C_k (H_2 O)_l
$ 

Hence, hydrated carbon. The distinguishing feature is that they are rich in hydroxyl.
#align(center, graphic(
  skeletize({
    fragment("C")
    branch({
      single(angle: 2)
    })
    branch({
      single(angle: -2)
    })
    branch({
      single(angle: 4)
    })
    single()
    fragment("OH")
  })
))

So generally, rich in C-H is likely to be a lipid, rich in C-OH is likely to be a carbohydrate.
#table(
  columns: 2,
  graphic(
    skeletize({
      fragment("O")
      cycle(6, {
        for i in range(6) {
          single()
          branch({
            single()
            if i == 3 {
              single(angle: 1)
            }
            fragment("OH")
          })
        }
      })
    })
  ),
  graphic(
    skeletize({
      for i in range(5) {
        single()
        branch({
          single(angle: 2)
          fragment("OH")
        })
      }
    })
  )
)

Hexoses (six Carbons) are used in cellulose and glycogen (think energy storage, sugars).


#table(
  columns: 2,
  graphic(
    skeletize({
      fragment("O")
      cycle(5, {
        for i in range(5) {
          single()
          branch({
            single()
            if i == 3 {
              single(angle: 2)
            }
            fragment("OH")
          })
        }
      })
    })
  ),
  graphic(
    skeletize({
      branch({
        double(angle: 3)
        fragment("O")
      })
      branch({
        single(angle: 5)
        fragment("H")
      })
      for i in range(4) {
        single()
        branch({
          single(angle: 2)
          fragment("OH")
        })
      }
    })
  ),
)

Pentoses show up in DNA. Both molecules above are forms of Ribose. Change one of the OH's to H, and it's called 2-Deoxyribose which you should recognize from the full name of DNA!

One cool thing about Carbohydrates is they can bond from any of their OHs. This means there are quite a lot more ways to link together carbohydrates then there are for Amino Acids or Lipids. Furthermore, even for a fixed linkage site, there are multiple ways to join the two OHs, further increasing diversity.

=== Glycans
Glycans are compounds made of more than one carbohydrate. Cellulose is essentially many Glucose molecules linked together in a linear chain. Glycogen is also made up of Glucose, but it links things in a more complex fashion. The different set of linkages require different enzymes to break down, which is why humans cannot process Cellulose.

=== Blood
Antigens are little things that stick outside a cell that are responsible for telling the immune system what's going on inside. If a cell refuses to present antigens it can be destroyed, and if it presents antigens indicating some viral activity it can also be destroyed. 

Antigens often are Carbohydrates! In particular, for blood what differentiates the O, A and B blood groups is just a matter of one or two carbohydrates present on the antigen.

This has lead to a pretty cool piece of biotech: modify the antigens of a given type of blood to make it look like the O blood group, which would theoretically allow blood donated from someone to be given to anyone else.

== Nucleic Acids
The three ingredients of a nuclear acid are a sugar (Ribose or 2-Deoxyribose), a Phosphate, and a nuclear base.
#align(center, image("../img/nucleic-acids.png", width: 100%))

Nucleic acids are used for more than just DNA. ATP and GTP are made with almost the same recipe as a Nucleic acid.

Here's some common terminology.
*Nucleoside*: Ribose + Nucleic Base
*Nucleotide*: *Nucleoside* + Phosphate

The most stable form for DNA's attached Phosphate is this.
#align(center, graphic(skeletize({
  fragment("R_1")
  single()
  fragment("O")
  single()
  fragment("P")
  branch({
    double(angle: 2)
    fragment("O")
  })
  branch({
    single(angle: -2)
    fragment("O^-")
  })
  single()
  fragment("O")
  single()
  fragment("R_2")
})))

That O#super[-] makes DNA quite acidic, hence the name Nucleic Acid.

=== DNA Structure
The Phosphate and Sugars link to form a backbone. Once again, the backbone uses bonds formed via condensation reactions! Now, two such backbones are wound together to form a double-helix (one oriented opposite to the other), and the nucleic bases pair off in the center via Hydrogen bonding to form the interior of DNA. 

*Fun Facts*
+ Interestingly, the GC bond consists of 3 Hydrogen bonds, while the AT bond consists of just 2. This makes the GC bond a bit more structurally stable.
+ A fascinating property of DNA is if you heat it, it will come apart, but once the heat is removed it will naturally reform. This is another example of self-healing in Biology!

=== DNA vs. RNA
#table(
  columns: 2,
  [*DNA*],
  [*RNA*],
  [Uses 2-Deoxyribose (needs more stability)],
  [Uses Ribose],
  [AGCT],
  [AGCU],
  [Usually double-stranded (durable, information storage)],
  [Found in a million different forms (active, protein building)]
)

= Cells