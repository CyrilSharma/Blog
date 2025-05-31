#import "/typ/templates/blog.typ": main
#show: main.with(
  title: "Tools",
  desc: ["Tools I use"],
  date: "2025-05-31T09:30:06-04:00",
  tags: ("random","cs"),
)

This is a list of tools I use that aren't universal (e.g. Github) but that I think are really cool.

- alacritty (Terminal)
  - The main feature I care about is OSC52 support. This is a protocol which makes remote copy and paste possible with zero setup.
  - It also has True Color support, which lets me have nice color highlighting and neovim support. 
  - It's also pretty fast as it uses OpenGL.
  - While most modern terminals provide this, all others feel a bit unsatisfying
    - Warp adds a ton of features I don't need, and gets rid of keybinds (like ctrl-R) that I have deliberately configured.
    - iTerm2 has notifications and "tip of the day" stuff and a UI that looks slightly off to me.
    - Haven't tried Kitty, but I don't need any fancy features like printing images in the terminal.
- zellij (Terminal Multiplexer)
  - So, zellij is basically tmux
    - The main usecase for me is collecting many terminals into windows. This grouping prevents terminals from getting lost amidst many applications, and makes switching between different projects easier.
    - The second nice thing is the sessions are persistent, which means if I have a zellij session on a remote machine, those terminals will still be up and running when I get back. Code Editors don't make great session managers, especially if I'm just trying to get into some tiny VM and mess around. 
  - Unlike tmux, it solves a bunch of problems right out of the box, which means I don't need to port configurations when I install it in remote machines.
    - Sessions metadata is stored, so even if the machine goes down I can still reload my configuration.
    - COPY AND PASTE WORKS WITH ZERO CONFIGURATION.
    - There's a lock configuration key which gets rid of most keybinds, making it unobtrusive.
    - I can easily search individual panes. 
- alfred (Search Tool)
  - It's faster then spotlight, let's you google things, let's you add your own commands, and a bunch of other stuff I haven't tried using too much.
- fzf
  - This let's you fuzzy search over files. There are a bunch of arguments you can use, which allow custom previews and such, but the main usecase for me is the shell integrations. By typing ctrl-R I can fuzzy search over my command history! By typing ctrl-T I can search for whatever filename I need.
- rg
  - Occasionally very useful. This is highly optimized grep implementation designed to search directories recursively. If you were using ```bash find | grep``` before, you will find this tool is orders of magnitude faster. 
- zoxide
  - With this you can just type the first word of whatever your target directory is, and cd directly into it. No need to hunt around your filesystem. It does this through usage patterns.
- neovim with Astronvim configuration (Code & File Editor)
  - The default astronvim configuration is honestly really good. I would strongly advise against trying to configure it, or you might spend way too long on things of way too little value. I honestly prefer it over vscode for coding (nice list syntax things like dif or dic to delete functions or classes entirely, runs out of a terminal so good for viewing and editing files no matter where they are, etc.). The Lisp integrations are quite good.
  - Sidenote 1, I would NOT reccomend using Vim as your code editor because of the amount of setup needed to get a fraction of VSCode's functionality. Lisp's improve your development speed quite significantly!
  - Sidenote 2, if you are learning vim, I recccomend remapping your Caps-Lock to Ctrl when pressed with another key and escape when pressed by itself. This is actually roughly the layout of the keyboard that vim was designed with. For me, this made the difference between vim feeling clunky and vim feeling much better then normal editing. If you're on MacOs you can do this with Karabiner-Elements. I've found the escape and ctrl being so close-by also makes me use those keys way, way more.
- rectangle
  - Provides intuitive keybinds for snapping windows into reasonable places. Top-left corner, right side of the screen, up to the top monitor, etc. You can also use
- clipboard manager
  - This is a relatively new addition, but it seems obvious in retrospect. I spend a lot of time hopping back and forth to try and recover whatever my last copy was. Being able to use a search bar and just summon it at any time is pretty cool!
- cursor
  - A lot of times I prefer the lisp suggestions over what copilot says, and for that reason I have it disabled. However, Cursor's in-house tab completion model is really good. It suggests multi-line changes, is relatively fast, and it's code-base aware. If I know what I'm trying to write, then Cursor Tabs strictly improve the speed with which I can write it.
  - The fully agentic mode often completely borks things, so I don't use it too much. Lately I've been having it explain new codebases, e.g. how can I build X, how does X configuration influence Y variable. Accuracy is mediocre. A lot of these usecases could probably be addresses faster by simply reading the relevant configuration files, so I'm still figuring this one out.
- notion
  - It's just really nice for taking notes, organizing them, and sharing them. I've also been using it for so long that there's a fair amount of friction towards switching.
  - I think the database feature is also quite nice. I have a big database of thoughts I find cool which I can easily search by tags or other attributes
- typst (formerly latex)
  - You need latex for any document that needs to be precisely formatted, usually resumes, papers, math stuff, etc.
  - Typst provides this same functionality, but it's syntax is SO MUCH MORE SANE. Adding custom features feels like coding in a normal language (and a nice one too). Compile errors are readable. The verbosity is way lower. Also, it has an html export, which makes things like this blog possible...
