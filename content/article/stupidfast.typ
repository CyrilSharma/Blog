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
  # a
  a_wants_it = False
  b_wants_it = False
  locked = False
  while (1):
    a_wants_it = True
    if not locked:
      locked = True
      # do some work...
      locked = False
    a_wants_it = False
  ```
  #colbreak()
  ```python
  # b
  a_wants_it = False
  b_wants_it = False
  locked = False
  while (1):
    b_wants_it = True
    if not locked and not a_wants_it:
      locked = True
      # do some work...
      locked = False
    b_wants_it = False
  ```
]


Actually this definitely doesn't work see #link("https://en.wikipedia.org/wiki/Dekker%27s_algorithm#:~:text=Dekker's%20algorithm%20is%20the%20first,Dekker%20by%20Edsger%20W.")[Dekker's Algorithm] for a correct implementation. However, this means we'd have to write different code for each process, and it's pretty tricky code too. At which point you're told just use Mutexes or Semaphores. Oh, but what happens if two processes call #ctext(red)[lock]at the same time? Well the cache will ensure only one process can access the memory at a time. But how does it choose? Ah, it does basically the same thing, but just embedded as a hardware circuit.

== Content-Addressable Memory (CAM)
Hmmm we have all these virtual addresses, and we need to figure out what physical addresses they correspond too. We have a page table for this purpose, but it's kinda slow. We want a recency cache, but that requires a hashtable which seems hard to make fast. Ah, what if instead of a hashtable we just checked every key in parallel.

== Network Communication
I want to send you an email, but your computer is down. Ah, well I can just send it to a third server which will hold onto the mail, then when your computer wakes up it'll fetch the mail. Hmm how do we do this for cell phones which are constantly moving around? Ah just track where it's going and move the proxies around. 

Actually Celluar is super complicated and the logic behind moving all these proxies around is very hard to follow. Still, there's really no better way of talking with an unavailable agent then just having it send everything through a proxy.
