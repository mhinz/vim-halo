# vim-halo

Make the current line blink in a given interval using timers. The cursor won't
block.

This could be used to visually highlight the cursor after jumping to a tag and
similar situations. Be creative!

_Works with Neovim and Vim with the `+timers` feature compiled in._

Idea stolen from @[justinmk](https://github.com/justinmk).

## Usage

There's only one function `halo#run()` which takes one optional argument, a
dictionary.

The dictionary takes up to 3 keys:

- **hlgroup**: Highlight group as *string*. Default is `Halo` which is provided
  by the plugin itself.
- **shape**: Shape as a *string*. Can by any of `halo1`, `halo2`, `cross1`,
  `cross2`, `cross2halo1`, `rectangle2`, or `line`. Default is `halo1`.
- **intervals**: A *list of numbers*. Calling `halo#run()` immediately shows a
  visual highlight. The numbers denote the alternating times visual highlights
  are shown and hidden. Thus an odd number of elements is sensible. Given an
  even number, the last element is ignored. Default is `[100,100,100,100,100]`.

```
:call halo#run()
:call halo#run({'shape': 'cross2halo1'})
:call halo#run({'intervals': [100, 300, 600, 300, 100]})
:call halo#run({'intervals': [200,200,200], 'hlgroup': 'IncSearch'})
```

## Disclaimer

Only the `line` shape works works with wrapped lines!
