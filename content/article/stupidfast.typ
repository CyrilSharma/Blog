#import "/typ/templates/blog.typ": *
#show: main.with(
  title: "Do Stupid Fast",
  desc: ["do stupid fast!"],
  date: "2025-06-13T19:51:36-04:00",
  tags: ("musings", "cs"),
)

This is an observation I've had about a lot of concepts in Computer Science (and perhaps it generalizes to other places). Rather then trying to think of a better, more clever way to do something, sometimes the best solution is to just do the naive thing really fast.

== Polling
If you've taken a CS class you've probably been told polling is bad. You should never do something like 
```python
data = fetch_data()
while (data.is_not_here_yet_gimme_a_sec()):
  pass
# fancy data processing!
```
Instead, you should #ctext(red)[yield] the thread, let something else do work, and then come back when the operation is ready. 

Seems logical. Wait... how do you know the data is ready? Oh, right, the OS has interrupts. How does the OS know to throw an interrupt? Oh right, when you do I/O or something hardware can set a flag in memory saying hey I finished doing the stuff! Wait how do you know that flag is set? Oh hardware checks certain memory regions on each clock cycle to see if they've been written too, and then it runs an interrupt handler. 

And there it is. We're still doing polling, just with fast hardware.

== Locks
How do you stop two processes from accessing the same resource at the same time? There's an easy solution, make them do different things. If A and B try to access it at the same time, just always give it to A.
#columns(2)[
  ```python
  a_wants_it = False
  b_wants_it = False
  locked = False
  while (1):
    b_wants_it = True
    if not locked and not a_wants_it:
      locked = True
      # do some work...
      locked = False

  ```
  #colbreak()
  ```python
  a_wants_it = False
  b_wants_it = False
  locked = False
  while (1):
    b_wants_it = True
    if not locked and not a_wants_it:
      locked = True
      # do some work...
      locked = False

  ```
]
However, this means we'd have to write different code for each process, which feels unnecessary.
