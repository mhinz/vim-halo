# vim-halo

Make the current line blink in a given interval using timers. Idea stolen from
@[justinmk](https://github.com/justinmk).

This could be used to visually highlight the cursor after jumping to a tag and
similar situations. Be creative!

_Works with Neovim and Vim with the `+timers` feature compiled in._

## To be done

- [ ] Add more shapes. Not only highlight the current line but draw rectangles
  around the cursor and stuff like that. Or a crosshair.

## Usage

```
:call halo#run()
:call halo#run({'hlgroup': 'IncSearch'})
:call halo#run({'intervals': [100, 300, 600, 300, 100]})
:call halo#run({'intervals': [100, 300, 600, 300, 100], 'hlgroup': 'IncSearch'})
```
