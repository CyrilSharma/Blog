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
      cycle(6, absolute: (180deg + 30deg), {
        for i in range(6) {
          single()
          branch({
            single()
            if i == 0 {
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
      for i in range(5) {
        single()
        branch({
          single(angle: 2)
          fragment("OH")
        })
      }
    })
  )
) <Ribose>

Hexoses (six Carbons) are used in cellulose and glycogen (think energy storage, sugars).


#table(
  columns: 2,
  graphic(
    skeletize({
      fragment("O")
      cycle(5, absolute: (180deg + 36deg), {
        for i in range(5) {
          single()
          fragment("C^" + str(5 - (i + 1)))
          branch({
            single()
            if i == 0 {
              fragment("C^5")
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
The Phosphate and Sugars link to form a backbone, via #link(<Ribose>)[the fifth and third carbons]. The orientation of the backbone is thus described as 5' to 3' or 3' to 5' Once again, the backbone uses condensation reactions! Now, two such backbones are wound together to form a double-helix (one oriented opposite to the other), and the nucleic bases pair off in the center via Hydrogen bonding to form the interior of DNA. 

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

= Gene Expression
== DNA Replication
+ Unravel DNA (it's wrapped around Histone proteins to form Chromatin, which are in turn wrapped into several more complex structures until you arrive at a Chromosome).
+ Use Helicase to find an origin of replication and start unzipping the DNA. Places that will cleave easily have lots of As and Ts (only two instead of three hydrogen bonds).
+ Use Single Strand Binding Proteins (SSBPs) to sit on the backbone of each strand and prevent the cleaved DNA from reforming.
+ Use RNA Polymerase to create a primer strand of RNA for DNA Polymerase to latch onto.
+ Using the primer, let DNA Polymerase start building the leading strand. DNA Polymerase always lays things down 5' to 3'. Therefore, the strand attached to the leading strand will go from 3' to 5'.
+ Later, use RNAse to cut out the RNA primer, and use Ligase to fill in the gap.
+ Occasionally do the same procedure on the lagging strand (you make short chunks at a time, called Okazaki strands).
+ Lastly, throughout this process use Topoisomerase to cut the DNA and relieve the built-up tension. 

There's a slight problem with primers. Primers are a temporary piece of RNA that is used to get DNA polymerase rolling, but is later removed. This gap can be filled by using polymerase with the section _before_ the gap as a primer. However, at the ends of chromosomes this no longer works, and polymerase cannot repair the gap. There are two ways to combat this.
+ Store irrelevant genetic material at the end (Telomeres) so that losing it is no big deal. This only works so many times, and eventually cells will begin to get rid of useful genetic material.
+ For Germ and Stem cells (who need perfect copies of the genome), there's an enzyme called Telomerase which will repair the ends of the DNA strand.

You might wonder why every cell doesn't use Telomerase. It's because losing your telomeres puts a cap on how many times a cell can replicate, and hence a cap on how many mutations you can accumulate. For this reason, Cancer almost always finds a way to synthesize Telomerase.

== Replication Accuracy
DNA replication in Eukaryotes is remarkably accurate. DNA Polymerase actually can check if the previous base pair is wrong, and if so remove it, thanks to Exonuclease!

This increase in accuracy comes with a cost in speed. DNA in Eukaryotes is transcribed about 30-50 base pairs per second, whereas Bacteria can do about 1000 base pairs per second. Eukaryotes retain the accuracy of this process while speeding it up by starting in many places at once.

Furthermore, Eukaryotes have very sophisticated mechanisms to repair broken DNA e.g. from radiation, chemicals, etc. These are called the *Guardians of the Genome*. In all cases it involves some enzyme to cleave out mistakes, plus DNA polymerase and ligase to clean things up afterward.
+ Glycosylase can remove bad bases at arbitrary points in DNA. This is part of Nucleotide Excision Repair (NER).
+ Radiation can cause Thymine to bond with itself on the same strand. Endonuclease (note that this is different from Exonuclease, which only acts on the ends) fixes this by making two cuts around a small portion of the strand (\~12 BPs) containing the bonded thymines, cutting it out and letting other enzymes patch things. Endonuclease's cleaving ability is incredibly useful. It is also used to cut open Bacterial's DNA to allow foreign eukaryotic DNA to be inserted.

Without these repair mechanisms, you quickly begin to accumulate mutations. For example, people who have Xeroderma Pigmentosum cannot perform NER. This gives them a 1000x chance of getting skin cancer with sunlight exposure.

== Transcription
Very similar to Replication. The major differences are as follows.
+ Use Ribose instead of 2-Deoxyribose (ATP vs. dATP, CTP vs. dCTP, etc.)
+ Only transcribe the portions of DNA relevant to making proteins.
+ Only transcribe one strand at a time.
+ Use Uracil instead of Thymine.
+ RNA Polymerase does not need a primer, and performs some of the functions of Helicase.
+ Higher error rate.

Transcription is shortly followed by a few other processes. 

#definition(name: [5' Capping])[
  Soon after the RNA is synthesized, a certain molecule is attached to its 5' end. This essentially marks the RNA as mRNA, so enzymes (such as Exonuclease) will know to handle it differently.
]

#definition(name: [3' Polyadenylation])[
  On the other side of the RNA, a bunch of Adenine molecules are added. Why?
  - Safeguards the cell from Exonuclease (makes it target the As instead of coding RNA).
  - Acts as an in-built timer for when the mRNA should expire.
  - Marks the mRNA as something that should leave the Nucleus.
]

#definition(name: "Splicing")[
  Now, a bunch of genetic material is removed from the mRNA. The pieces that are removed are called introns, and the pieces that are removed are called exons.
  - This greatly increases the diversity of proteins a sequence of DNA can encode for.
]

== Transcription Control
Because a protein's utility can depend on a lot of factors, its essential that a cell has fine-grained control over when each protein is transcribed. This is accomplished through several mechanisms, often called *Transcription Factors*.
+ Promoters. These are regions of DNA (located near a transcription site) attracts certain proteins which in turn attract RNA polymerase to the transcription site.
+ Enhancers. These are similar to Promoters, but they can be located far away from the transcription site, and they have different strategies for enhancing transcription.
+ Chromatin Remodeling. Histone has a bunch of positive charge which allows it to hold onto DNA. You need to unravel DNA in order to transcribe it, hence one way of increasing transcription rates is to neutralize some of the Histone's charge. There are other compounds which can be used to make Chromatin more stable, which has the opposite effect.

== Translation
#definition(name: "Codon")[
  A sequence of three letters of RNA. Each sequence encodes one Amino acid. There are also codons to encode where translation should start and where it should stop.
]

#definition(name: "tRNA")[
  Pre-existing molecular adaptors which carry Amino acids. One end attaches to an Amino acid, the other end has what is called an Anti-Codon which allows it to attach to the relevant piece of RNA.
]

#definition(name: "Ribosomes")[
  Made up of rRNA, these complexes translate RNA to Proteins.
]

The process looks like this. Part of the Ribosome finds a start codon and latches on. Then the tRNA that corresponds to the start codon latches onto this. Finally, the top half of the Ribosome latches onto _this_. Then, tRNA molecules keep floating around and bumping into the Ribosome. Only the tRNA with the appropriate anti-codon is able to bind to the RNA and donate its amino acid to the new protein. This continues on until you reach an end codon. At this point either a protein release factor is bound or a suppressor tRNA, in either case stopping the process.

= Cells
/ Endocytosis: Taking something into the cell, via wrapping it in a portion of cell membrane.
/ Exocytosis: Pushing something out of a cell, opposite process of Endocytosis.
/ Cytoskeleton: A complex network of proteins that fills the cell and gives it its resistance to deformation. 
/ Microtubules: The hollow protein tubes that make up the Cytoskeleton.
/ Mitosis: Asexual Cellular Reproduction
/ Meiosis: Sexual Cellular Reproduction

#align(center, image("../img/mitosis_and_meosis.png"))
The main difference between Meiosis 1 and Meiosis 2 is that phase 1 has homologous chromosomes (the same gene from different parents) pair up followed by potential genetic exchange (crossovers), while phase 2 has the sister chromosomes (two previously identical chromosomes) pair up.

It should be noted that which homologue ends up in which cell is random. Hence, it would be extremely unlikely for all the father's homologues to separate in one cell and all the mother's homologues to separate in the other.

Here's how Meiosis ties into actual reproduction. Initially, some sperm cell fertilizes some egg cell. This forms the Zygote, which then undergoes Mitosis many times to form the body. Later in life, many cells in the gonads undergo Meiosis, forming a huge variety of germ cells. Hence, Meiosis sets the genetic stage for the next generation, the current generations genotype is determined purely by what egg and sperm cell meet.

== Genetics

#definition(name: [Mendel's Laws])[
  + Dominance: For every gene you have two alleles. The dominant variant will mask the effect of the recessive variant.
  + Segregation: For every gene, you receive exactly one allele from each parent.
  + Independence: The inheritance of one allele is independent of the inheritance of another allele. I.e. just because I got my father's allele for gene 1 does mean I will get it for gene 2.
]

The discovery of these laws was done by cross-breeding pea plants and drawing Punnett squares. 

Mendel's 2nd law stems from Meiosis splitting homologues into different cells. Mendel's 3rd law stems from this homologue separation being random for each chromosome. However, if you have multiple alleles within a chromosome, then those alleles are _not_ independent and are likely to be inherited together. This is called genetic linkage. There's a little more complexity here, as there is also genetic crossover between homologous chromosomes, which means a particular allele might end up opposite its parent chromatid. The further apart two alleles are on a chromosome, the greater the chance of crossover between them. Hence, linkage is strongest when two genes are close-by on a chromosome. Interestingly, genetic crossover does not respect gene boundaries. This seems like it should result in genes frequently breaking but in fact the crossover regions are not equally likely across the chromosome and there are tons of non-coding DNA. Hence, it's often the case that only entire alleles are exchanged.

You can determine the relative order and degree of linkage of three genes using what's known as a #link("https://bio.libretexts.org/Bookshelves/Genetics/Online_Open_Genetics_(Nickle_and_Barrette-Ng)/07%3A_Linkage_and_Mapping/7.07%3A__Mapping_With_Three-Point_Crosses")[three-point cross]. Essentially, you just measure the proportion of some population that has crossovers between each pair of genes and this gives you a distance you can use to order the genes.

To detect cross-over events, you need the cross-over events to be distinguishable from non-crossover events. Hence, you typically do a cross-breed like this.
$
  (A B C)/(a b c) times.o (a b c)/(a b c)
$

You expect the organism to either be dominant in all traits or recessive in all traits, hence if its dominant in some and recessive in others, you immediately know which crossover event happened.

#align(center, image("../img/XLinked.jpg"))

Mendelian inheritance can cause some interesting patterns. For one, traits often skip a generation. This is because the original generation might have only one copy of a recessive gene, hence none of their direct descents can have the recessive trait. Furthermore, traits can be sex-linked (e.g. primarily males or females are affected), if the alleles in question happen to live on the X-chromosome like in the above example.

== Genetic Engineering

=== Molecular Cloning 
+ Use a specific type of Endonuclease to cut a Bacteria's DNA.
+ Use the same kind of Endonuclease to cut up the DNA of an organism of interest. The collection of DNA fragments is called a DNA library.
+ Put a DNA library into the medium. Bacterial DNA will adopt the fragments.
+ Put DNA Ligase in the medium to repair the DNA.
+ Apply selection pressure, such that only the Bacteria which have the DNA fragment you're interested in survive.

=== PCR
#align(center, image("../img/PCR.jpg"))
This is an amplification based approach. The idea is by dumping in the appropriate primers, you can get DNA polymerase to replicate the DNA strand of interest twice, while everything else only gets replicated once. After several iterations of this, the stuff left in solution is primarily made up of the DNA sequence you're actually interested in.

=== CRISPR
CRISPR is an RNA guided endonuclease. It has some target piece of RNA in it that allows it to make specific cuts in DNA. To use this for gene-editing, start by using CRISPR to cut out the portion of DNA you want to replace and then add in your replacement DNA and some Ligase.

Bacteria evolved CRISPR as a sort of adaptive immune system for Bacteriophages. Essentially, whenever a phage was encountered, a short sequence of its DNA (which often look like clustered regularly interspaced short palindromic repeats) was put into the Bacteria's DNA. A CRISPR enzyme based on each repeat exists in the Bacteria and will kill the corresponding Bacteriophage should it enter the cell. What's kind of amazing about this system is that it's in the DNA, so the descendants of these Bacteria will also be immune to the Phage.

There are two main CRISPR treatments as the moment.\
/ In vitro: Take the target cells outside the patient, modify them, then put them back. To ensure the modified cells end up being a significant portion, you need to somehow kill of your cells, like with Chemotherapy for example.
/ In-vivo: Modify the DNA of cells in the patient. This is pretty hard to do at the moment but would theoretically not require killing many cells, unlike in vitro.

=== Sequencing

*TODO*: Sanger Sequencing, Next Generation Sequencing, Single Nucleotide Polymorphism, Restriction Fragment Length Polymorphism, Gel Electrophoresis, Single Sequence Repeat, Positional Gene Cloning, Chromosome Walk, Retrovirus, Complementary DNA, Reverse Transcriptase, making a cDNA library, make flies sprout extra eyes

== Cellular Trafficking 
*TODO*: Targeting sequences, Post Translational Modification (PTMs), Lipidation, Phosphorolation, NLS + Importin, Signal Recognition Particle (SRP), Rough ER