# vim-halo

Make the current line blink in a given interval using timers. Idea stolen from
@[justinmk](https://github.com/justinmk).

Works with Neovim and Vim with the `+timers` feature compiled in.

## To be done

- [ ] Add more shapes

## Usage

```
:call halo#run()
:call halo#run({'hlgroup': 'IncSearch'})
:call halo#run({'intervals': [100, 300, 600, 300, 100]})
:call halo#run({'intervals': [100, 300, 600, 300, 100], 'hlgroup': 'IncSearch'})
```
