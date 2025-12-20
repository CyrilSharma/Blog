#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "rationality",
  desc: "",
  date: "2025-12-20T11:26:04-05:00",
  tags: ("musings",),
)

#show: note_page.with(should_outline: false)

#definition(header: false)[
  *Rationalism*: A reasoning framework for estimating the truth. It cannot answer questions about what a "good" decision or "bad" decision by itself. For that you need a set of values. \
  *Values*: Your _objective function_. As far as I can tell, there isn't just one valid set of values. However, there are some desirable properties any set of values should have.
  + Self-consistency (no internal contradictions).
  + The ability to compare any two decisions.
]

Another way to think about it is *Values* are your axioms, and *Rationalism* is constraint propogation. Hence, you cannot rationally derive all your values... which begs the following questions.
+ How do you choose good values?
+ Where should values come from? 
+ How should you update your values?